import asyncio
import logging
import multiprocessing
import os
import queue
import time
from typing import Any, AsyncGenerator, Dict, List, Optional, Tuple

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


def create_agent(llm_config: LLMConfig) -> FxTaskAgent:
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


def worker_process(i: int, input_queue: queue.Queue, output_queue: queue.Queue):
    logger.info(f"Worker {i} start.")

    # worker logic
    try:
        chatbot_agent = create_agent(get_llm_config())
        stop_flag = False
        while not stop_flag:
            input: Optional[ChatBotInput] = input_queue.get(block=True)
            if input is None:
                break
            if isinstance(input, ChatBotInput):
                try:
                    session_id = input.session_id
                    output = chatbot_agent.invoke(input)
                    output_queue.put((session_id, output))
                except Exception as e:
                    logger.error(e)
                    stop_flag = True
            else:
                raise ValueError(f"Input not match. {input}")
    except KeyboardInterrupt:
        pass
    logger.info(f"Worker {i} exit.")


class SimpleChatBot(GradioChatbot):
    def __init__(self):
        super().__init__()
        self.session_list: List[Tuple[int, List[ChatMessage]]] = []
        self.session_list_max_limit = 50
        self.session_history_max_limit = 30
        self.result_dict: Dict[str, ChatBotResponse] = {}

        self.processing_manager = multiprocessing.Manager()
        self.input_queue: queue.Queue[Optional[ChatBotInput]] = (
            self.processing_manager.Queue()
        )
        self.output_queue: queue.Queue[Tuple[int, ChatBotResponse]] = (
            self.processing_manager.Queue()
        )
        self.worker_num = 1
        self.worker_processor: List[multiprocessing.Process] = []
        for i in range(self.worker_num):
            worker = multiprocessing.Process(
                target=worker_process,
                args=(i, self.input_queue, self.output_queue),
            )
            self.worker_processor.append(worker)
            worker.start()

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        # update history to session
        session_id, history_as_text = self._update_session_history(history)
        # create input and call agent
        input = ChatBotInput(
            session_id=session_id,
            input=message,
            history_as_text=history_as_text,
        )
        response: str = await self._ask(input)
        yield response

    async def on_exit(self):
        self.input_queue.put(None)
        for worker in self.worker_processor:
            worker.join()

    async def _launch_task(self, input: ChatBotInput) -> str:
        self.input_queue.put(input)

        # wait for response
        key = f"{input.session_id}"
        logger.info(
            f"Wait for session_id: {input.session_id} input: {input.input} response..."
        )
        begin_time = time.time()
        while True:
            try:
                output: Optional[Tuple[int, ChatBotResponse]] = None
                output = self.output_queue.get(block=False)
                if (
                    output
                    and isinstance(output, tuple)
                    and isinstance(output[1], ChatBotResponse)
                ):
                    output_session_id = output[0]
                    output_response = output[1]
                    self.result_dict[f"{output_session_id}"] = output_response
                    if key in self.result_dict:
                        break
            except queue.Empty:
                pass
            except Exception as e:
                logger.error(e)
                break
            await asyncio.sleep(1)  # in seconds
        end_time = time.time()
        cost = end_time - begin_time
        logger.info(f"Get session_id: {input.session_id} response. cost: {cost}")
        if key in self.result_dict:
            response: ChatBotResponse = self.result_dict[key]
            return response.response
        return ""

    async def _ask(self, input: ChatBotInput) -> str:
        return await self._launch_task(input)

    def _update_session_history(self, history: List[Dict[str, Any]]) -> Tuple[int, str]:
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

        # generate history as text
        history_as_text = "History conversation:\n"
        for msg in session_message:
            history_as_text += f"{msg.role}: {msg.content}\n"
        if len(history) == 0:
            history_as_text += "No history conversation."

        return (session_id, history_as_text)
