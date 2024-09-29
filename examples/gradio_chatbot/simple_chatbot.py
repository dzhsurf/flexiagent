from typing import Any, AsyncGenerator, Dict, List, Tuple

from pydantic import BaseModel

from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

from gradio_chatbot import GradioChatbot


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
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
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
