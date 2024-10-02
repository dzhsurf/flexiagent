import logging
import multiprocessing
import queue
import time
from abc import ABC, abstractmethod
from typing import Any, AsyncGenerator, Dict, Generic, List, Optional, Tuple, TypeVar

import gradio as gr
from gradio_chatbot.utils import HookObjectAsyncMethod

from flexiagent.task.task_node import FxTaskAgent, FxTaskEntity

logger = logging.getLogger(__name__)


class GradioChatBot(ABC):
    def __init__(self):
        pass

    async def launch(self, port: int = 3000):
        # replace undo, retry btn event
        with HookObjectAsyncMethod(
            gr.ChatInterface,
            "_delete_prev_fn",
            postprocess_hook=self.on_postprocess_delete_message,
        ):
            with gr.ChatInterface(
                fn=self.on_process_submit,
                type="messages",
                show_progress="full",
                multimodal=False,
            ) as inst:
                # replace clear btn click event
                inst.clear_btn.click(
                    self._on_clear_btn_click,
                    None,
                    [inst.chatbot, inst.saved_input],
                    queue=False,
                    show_api=False,
                ).then(
                    self.on_postprocess_clear_message,
                    None,
                    None,
                    show_api=False,
                    queue=False,
                )
                # launch webui
                inst.launch(server_name="0.0.0.0", server_port=port)
        await self.on_exit()

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        yield message

    async def on_postprocess_delete_message(
        self, history: List[Dict[str, Any]], message: str
    ) -> Tuple[List[Dict[str, Any]], str]:
        return (history, message)

    async def on_postprocess_clear_message(self):
        return

    async def _on_clear_btn_click(self):
        return ([], [], None)

    async def on_exit(self):
        return


AgentInput = TypeVar("AgentInput", bound=FxTaskEntity)
AgentOutput = TypeVar("AgentOutput", bound=FxTaskEntity)


class AgentChatBot(GradioChatBot, Generic[AgentInput, AgentOutput]):
    def __init__(self):
        super().__init__()
        self.result_dict: Dict[str, Optional[AgentOutput]] = {}
        self.processing_manager = multiprocessing.Manager()
        self.input_queue: queue.Queue[Optional[Tuple[str, AgentInput]]] = (
            self.processing_manager.Queue()
        )
        self.output_queue: queue.Queue[Tuple[str, Optional[AgentOutput]]] = (
            self.processing_manager.Queue()
        )
        self.worker_num = 1
        self.worker_processor: List[multiprocessing.Process] = []
        for i in range(self.worker_num):
            worker = multiprocessing.Process(
                target=self.__class__.worker_process,
                args=(i, self.input_queue, self.output_queue),
            )
            self.worker_processor.append(worker)
            worker.start()

    @classmethod
    @abstractmethod
    def create_agent(cls) -> FxTaskAgent:
        """
        This method is responsible for creating and returning an instance of FxTaskAgent.

        You should implement this method to initialize the agent that is used by the chatbot
        to process inputs and generate responses.
        """
        pass

    @abstractmethod
    def create_agent_input(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AgentInput:
        """
        This method converts a received message and its associated history into the
        appropriate input format for the agent.

        Args:
            message (str): The current message to process.
            history (List[Dict[str, Any]]): List of dictionaries containing conversation history.

        Returns:
            AgentInput: The processed input suitable for the chatbot agent.
        """
        pass

    @abstractmethod
    def process_agent_output(self, response: Optional[AgentOutput]) -> str:
        """
        This method processes the output received from the agent into a string format
        that can be displayed to the user.

        Args:
            response (Optional[AgentOutput]): The output from the chatbot agent.

        Returns:
            str: The processed output as a string to display to the user.
        """
        pass

    @classmethod
    def worker_process(
        cls, i: int, input_queue: queue.Queue, output_queue: queue.Queue
    ):
        logger.info(f"Worker {i} start.")
        try:
            chatbot_agent = cls.create_agent()
            while True:
                input: Optional[Tuple[str, AgentInput]] = input_queue.get(block=True)
                if input is None:
                    break
                if (
                    isinstance(input, tuple)
                    and isinstance(input[0], str)
                    and isinstance(input[1], FxTaskEntity)
                ):
                    session_id = input[0]
                    try:
                        output = chatbot_agent.invoke(input[1])
                        output_queue.put((session_id, output))
                    except Exception as e:
                        logger.error(e)
                        output_queue.put((session_id, None))
                else:
                    raise ValueError(f"Input not match. {input}")
        except KeyboardInterrupt:
            pass
        except Exception as e:
            logger.error(e)
        logger.info(f"Worker {i} exit.")

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        input = self.create_agent_input(message, history)
        agent_response = await self._ask(input)
        output = self.process_agent_output(agent_response)
        yield output

    async def on_exit(self):
        self.input_queue.put(None)
        for worker in self.worker_processor:
            worker.join()

    def _generate_task_id(self) -> str:
        timestamp: int = int(time.time())
        return f"{timestamp}"

    async def _launch_task(self, input: AgentInput) -> Optional[AgentOutput]:
        task_id = self._generate_task_id()
        self.input_queue.put((task_id, input))

        # wait for response
        logger.info(f"Wait for task_id: {task_id} input: {input} response...")
        begin_time = time.time()
        while True:
            try:
                output: Optional[Tuple[str, Optional[AgentOutput]]] = None
                output = self.output_queue.get(block=False, timeout=5)
                if (
                    output
                    and isinstance(output, tuple)
                    and isinstance(output[0], str)
                    and ((output[1] is None) or isinstance(output[1], FxTaskEntity))
                ):
                    output_task_id = output[0]
                    output_response = output[1]
                    self.result_dict[output_task_id] = output_response
                    if task_id in self.result_dict:
                        break
            except queue.Empty:
                pass
            except Exception as e:
                logger.error(e)
                break
        end_time = time.time()
        cost = end_time - begin_time
        logger.info(f"Get {task_id} response. cost: {cost}")
        if task_id in self.result_dict:
            response = self.result_dict.pop(task_id)
            return response
        return None

    async def _ask(self, input: AgentInput) -> Optional[AgentOutput]:
        return await self._launch_task(input)
