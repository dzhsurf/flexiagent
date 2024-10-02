import logging
import os
from typing import Any, Dict, List, Optional

from gradio_chatbot import AgentChatBot
from pydantic import BaseModel

from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

logger = logging.getLogger(__name__)


class ChatBotInput(FxTaskEntity):
    input: str
    history_as_text: str


class ChatBotResponse(FxTaskEntity):
    response: str


class ChatMessage(BaseModel):
    role: str
    metadata: Dict[str, Any]
    content: str


def get_llm_config() -> LLMConfig:
    # local config from environment
    engine = os.environ.get("LLM_CONFIG_ENGINE", "LlamaCpp")
    if engine == "OpenAI":
        llm_model = os.environ.get("LLM_CONFIG_OPENAI_MODEL", "gpt-4o-mini")
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": llm_model})
        if "OPENAI_API_KEY" not in os.environ:
            raise ValueError("OPENAI_API_KEY not set")
    elif engine == "LlamaCpp":
        default_repo_id = "QuantFactory/Llama-3.2-3B-Instruct-GGUF"
        llm_repo_id_or_model_path = os.environ.get(
            "LLM_CONFIG_LLAMACPP_REPO_ID_OR_PATH", default_repo_id
        )
        llm_repo_filename = os.environ.get(
            "LLM_CONFIG_LLAMACPP_REPO_FILENAME", "*Q4_K_M.gguf"
        )
        llm_model_ctx = int(os.environ.get("LLM_CONFIG_LLAMACPP_MODEL_CTX", "4096"))
        llm_config = LLMConfig(
            engine="LlamaCpp",
            params={
                "repo_id_or_model_path": llm_repo_id_or_model_path,
                "repo_filename": llm_repo_filename,
                "n_ctx": llm_model_ctx,
            },
        )
    else:
        raise ValueError(f"LLM_CONFIG_ENGINE not suppport. {engine}")

    return llm_config


class SimpleChatBot(AgentChatBot[ChatBotInput, ChatBotResponse]):
    def __init__(self):
        super().__init__()
        self.session_history_max_limit = 30

    @classmethod
    def create_agent(cls) -> FxTaskAgent:
        llm_config = get_llm_config()
        instruction = """You are a chatbot assistant. Assist user and response user's question.

{input.history_as_text}

Question: {input.input}
"""
        chatbot_agent = FxTaskAgent(
            task_graph=[
                FxTaskConfig(
                    task_key="output",
                    input_schema={"input": ChatBotInput},
                    output_schema=ChatBotResponse,
                    action=FxTaskAction(
                        type="llm",
                        act=FxTaskActionLLM(
                            llm_config=llm_config,
                            instruction=instruction,
                        ),
                    ),
                ),
            ]
        )

        return chatbot_agent

    def create_agent_input(
        self, message: str, history: List[Dict[str, Any]]
    ) -> ChatBotInput:
        # change histroy to chatmessage list
        session_message = [ChatMessage.model_validate(msg) for msg in history]
        session_message = session_message[-self.session_history_max_limit :]

        # generate history as text
        history_as_text = "History conversation:\n"
        for msg in session_message:
            history_as_text += f"{msg.role}: {msg.content}\n"
        if len(history) == 0:
            history_as_text += "No history conversation."

        return ChatBotInput(
            input=message,
            history_as_text=history_as_text,
        )

    def process_agent_output(self, response: Optional[ChatBotResponse]) -> str:
        if response:
            return response.response
        return "[Agent without any output]"
