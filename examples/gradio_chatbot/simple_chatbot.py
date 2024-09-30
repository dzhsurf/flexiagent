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
        self.history: List[ChatMessage] = []

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

Conversation:
{fetch_history.history_as_text}

Question: {input}
"""
        self.chatbot_agent = FxTaskAgent(
            task_graph=[
                FxTaskConfig(
                    task_key="fetch_history",
                    input_schema={},
                    output_schema=FetchHistoryMessagesOutput,
                    action=FxTaskAction(
                        type="function",
                        act=self._fetch_history,
                    ),
                ),
                FxTaskConfig(
                    task_key="output",
                    input_schema={
                        "input": str,
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

    def _fetch_history(
        self, input: Dict[str, Any], addition: Dict[str, Any]
    ) -> FetchHistoryMessagesOutput:
        history_as_text = ""
        for msg in self.history:
            history_as_text += f"{msg.role}: {msg.content}\n"
        return FetchHistoryMessagesOutput(
            history=self.history,
            history_as_text=history_as_text,
        )

    async def _ask(self, question: str) -> str:
        response: ChatBotResponse = self.chatbot_agent.invoke(question)
        return response.response

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        response: str = await self._ask(message)
        yield response
        self.history.append(
            ChatMessage(
                role="user",
                metadata={},
                content=message,
            )
        )
        self.history.append(
            ChatMessage(
                role="assistant",
                metadata={},
                content=response,
            )
        )

    async def on_postprocess_delete_message(
        self, message: str, history: List[Dict[str, Any]]
    ) -> Tuple[str, List[Dict[str, Any]]]:
        if len(self.history) > 0:
            self.history.pop()  # assistant
            self.history.pop()  # user
        return (message, history)

    async def on_postprocess_clear_message(self):
        self.history.clear()
        return
