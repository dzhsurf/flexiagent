import logging
import os
from typing import Any, AsyncGenerator, Dict, List, Tuple

from gradio_chatbot import GradioChatbot
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
    session_id: int
    input: str


class ChatBotResponse(FxTaskEntity):
    response: str


class ChatMessage(BaseModel):
    role: str
    metadata: Dict[str, Any]
    content: str


class FetchHistoryMessagesOutput(FxTaskEntity):
    history: List[ChatMessage]
    history_as_text: str


class SimpleChatBot(GradioChatbot):
    def __init__(self):
        super().__init__()
        self.session_list: List[Tuple[int, List[ChatMessage]]] = []
        self.session_list_max_limit = 50
        self.session_history_max_limit = 30

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

        instruction = """You are a chatbot assistant. Assist user and response user's question.

{fetch_history.history_as_text}

Question: {input.input}
"""
        self.chatbot_agent = FxTaskAgent(
            task_graph=[
                FxTaskConfig(
                    task_key="fetch_history",
                    input_schema={"input": ChatBotInput},
                    output_schema=FetchHistoryMessagesOutput,
                    action=FxTaskAction(
                        type="function",
                        act=self._fetch_history,
                    ),
                ),
                FxTaskConfig(
                    task_key="output",
                    input_schema={
                        "input": ChatBotInput,
                        "fetch_history": FetchHistoryMessagesOutput,
                    },
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

    def _get_history_by_session_id(self, session_id: int) -> List[ChatMessage]:
        for session in self.session_list:
            if session[0] == session_id:
                return session[1]
        return []

    def _fetch_history(
        self, input: Dict[str, Any], addition: Dict[str, Any]
    ) -> FetchHistoryMessagesOutput:
        if not isinstance(input["input"], ChatBotInput):
            raise TypeError(f"Input not match. {input}")
        chatbot_input: ChatBotInput = input["input"]
        history = self._get_history_by_session_id(chatbot_input.session_id)

        history_as_text = "History conversation:\n"
        for msg in history:
            history_as_text += f"{msg.role}: {msg.content}\n"
        if len(history) == 0:
            history_as_text += "No history conversation."
        logger.info(f"\nInput: {chatbot_input}\n{history_as_text}")
        return FetchHistoryMessagesOutput(
            history=history,
            history_as_text=history_as_text,
        )

    async def _ask(self, input: ChatBotInput) -> str:
        response: ChatBotResponse = self.chatbot_agent.invoke(input)
        return response.response

    def _update_session_history(self, history: List[Dict[str, Any]]) -> int:
        # generate next session id
        if len(self.session_list) > 0:
            last_session = self.session_list[-1]
            session_id = last_session[0] + 1
        else:
            session_id = 1
        # change histroy to chatmessage list
        session_message = [ChatMessage.model_validate(msg) for msg in history]
        session_message = session_message[-self.session_history_max_limit :]
        # update to session
        self.session_list.append((session_id, session_message))
        if len(self.session_list) > self.session_list_max_limit:
            self.session_list.pop(0)
        return session_id

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        # update history to session
        session_id = self._update_session_history(history)
        # create input and call agent
        input = ChatBotInput(session_id=session_id, input=message)
        response: str = await self._ask(input)
        yield response
