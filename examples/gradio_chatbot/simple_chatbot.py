import logging
from typing import Any, Dict, List, Optional

from gradio_chatbot import AgentChatBot
from gradio_chatbot.utils import get_llm_config
from pydantic import BaseModel

from flexiagent.task.task_node import (
    TaskAction,
    TaskActionLLM,
    TaskAgent,
    TaskConfig,
    TaskEntity,
)

logger = logging.getLogger(__name__)


class ChatBotInput(TaskEntity):
    input: str
    history_as_text: str


class ChatBotResponse(TaskEntity):
    response: str


class ChatMessage(BaseModel):
    role: str
    metadata: Dict[str, Any]
    content: str


class SimpleChatBot(AgentChatBot[ChatBotInput, ChatBotResponse]):
    def __init__(self):
        super().__init__()
        self.session_history_max_limit = 30

    @classmethod
    def create_agent(cls) -> TaskAgent:
        llm_config = get_llm_config()
        instruction = """You are a chatbot assistant. Assist user and response user's question.

{input.history_as_text}

Question: {input.input}
"""
        chatbot_agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": ChatBotInput},
                    output_schema=ChatBotResponse,
                    action=TaskAction(
                        type="llm",
                        act=TaskActionLLM(
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
