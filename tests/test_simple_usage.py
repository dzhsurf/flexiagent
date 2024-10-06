import collections
import logging
import unittest
from typing import Any, Callable, Dict, List, cast

from flexiagent.llm.config import LLMConfig
from flexiagent.task.base import (
    TaskAction,
    TaskActionContext,
    TaskActionLLM,
    TaskConfig,
    TaskEntity,
)
from flexiagent.task.task_agent import TaskAgent
from tests.utils import config_logger_level, pretty_log, trace_dag_context

logger = logging.getLogger(__name__)
config_logger_level()


class ChatOutput(TaskEntity):
    response: str


class ChatQA(TaskEntity):
    question: str
    answer: str


class TestCustomAgentWithStructuredOutput(unittest.TestCase):
    def setUp(self):
        # self.llm_config = LLMConfig(
        #     engine="OpenAI", params={"openai_model": "gpt-4o-mini"}
        # )
        self.llm_config = LLMConfig(
            engine="LlamaCpp",
            params={
                "repo_id_or_model_path": "QuantFactory/Llama-3.2-3B-Instruct-GGUF",
                "repo_filename": "*Q4_K_M.gguf",
                "n_ctx": 4096,
            },
        )

    def tearDown(self):
        pass

    def test_001_simple_llm_agent(self):
        instruction = """You are an expert responsible for answering users' questions.
User: {input}
"""

        agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": str},
                    output_schema=ChatOutput,
                    action=TaskAction(
                        type="llm",
                        act=TaskActionLLM(
                            llm_config=self.llm_config,
                            instruction=instruction,
                        ),
                    ),
                ),
            ],
        )

        output = agent.invoke("Who are you?")
        self.assertIsInstance(output, ChatOutput)
        logger.info(pretty_log(output))

    def test_002_simple_function_agent(self):
        def agent_fn(
            ctx: TaskActionContext, input: Dict[str, Any], addition: Dict[str, Any]
        ) -> str:
            result = str(input)
            return result

        agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": str},
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=agent_fn,
                    ),
                ),
            ],
        )

        output = agent.invoke("Call function")
        self.assertIsInstance(output, str)
        self.assertEqual(output, "{'input': 'Call function'}")
        logger.info(pretty_log(output))

    def test_003_simple_agent(self):
        instruction = """You are an expert responsible for answering users' questions.
User: {input}
"""

        llm_agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": str},
                    output_schema=ChatOutput,
                    action=TaskAction(
                        type="llm",
                        act=TaskActionLLM(
                            llm_config=self.llm_config,
                            instruction=instruction,
                        ),
                    ),
                ),
            ],
        )

        agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": str},
                    output_schema=ChatOutput,
                    action=TaskAction(
                        type="agent",
                        act=llm_agent,
                    ),
                ),
            ],
        )

        output = agent.invoke("Who are you?")
        self.assertIsInstance(output, ChatOutput)
        logger.info(pretty_log(output))

    def test_004_simple_agent_dag(self):
        instruction = """You are an expert responsible for answering users' questions.
User: {input}
"""

        llm_agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={"input": str},
                    output_schema=ChatOutput,
                    action=TaskAction(
                        type="llm",
                        act=TaskActionLLM(
                            llm_config=self.llm_config,
                            instruction=instruction,
                        ),
                    ),
                ),
            ],
        )

        def generate_output(
            ctx: TaskActionContext, input: Dict[str, Any], addition: Dict[str, Any]
        ) -> ChatQA:
            if not isinstance(input["input"], str):
                raise TypeError(f"input not match, {input}")
            if not isinstance(input["llm_chat"], ChatOutput):
                raise TypeError(f"input not match, {input}")
            question: str = input["input"]
            llm_chat: ChatOutput = input["llm_chat"]
            return ChatQA(
                question=question,
                answer=llm_chat.response,
            )

        agent = TaskAgent(
            task_graph=[
                # step 1: define task_key: llm_chat
                TaskConfig(
                    task_key="llm_chat",
                    input_schema={"input": str},
                    output_schema=ChatOutput,
                    action=TaskAction(
                        type="agent",
                        act=llm_agent,
                    ),
                ),
                # step 2: combine everything to output
                TaskConfig(
                    task_key="output",
                    input_schema={
                        "input": str,
                        "llm_chat": ChatOutput,  # upstream require llm_chat task
                    },
                    output_schema=ChatQA,
                    action=TaskAction(
                        type="function",
                        act=generate_output,
                    ),
                ),
            ],
        )

        question = "Who are you?"
        output = agent.invoke(question)
        self.assertIsInstance(output, ChatQA)
        self.assertEqual(cast(ChatQA, output).question, question)
        logger.info(pretty_log(output))

    def test_005_simple_agent_dag_2(self):
        context: Dict[str, List[str]] = collections.defaultdict(list)
        counter: int = 0

        def create_trace_step_fn(
            name: str,
        ) -> Callable[[TaskActionContext, Dict[str, Any], Dict[str, Any]], str]:
            def trace_step(
                ctx: TaskActionContext,
                input: Dict[str, Any],
                addition: Dict[str, Any],
            ) -> str:
                nonlocal counter
                for item_k, _ in input.items():
                    context[name].append(item_k)
                context[name + "_call"] = [str(counter)]
                counter += 1
                return name

            return trace_step

        agent = TaskAgent(
            task_graph=[
                TaskConfig(
                    task_key="step_1",
                    input_schema={
                        "input": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("step_1"),
                    ),
                ),
                TaskConfig(
                    task_key="step_2",
                    input_schema={
                        "step_1": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("step_2"),
                    ),
                ),
                TaskConfig(
                    task_key="step_3",
                    input_schema={
                        "step_2": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("step_3"),
                    ),
                ),
                TaskConfig(
                    task_key="step_4",
                    input_schema={
                        "step_2": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("step_4"),
                    ),
                ),
                TaskConfig(
                    task_key="step_5",
                    input_schema={
                        "step_1": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("step_5"),
                    ),
                ),
                TaskConfig(
                    task_key="output",
                    input_schema={
                        "step_4": str,
                        "step_5": str,
                    },
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=create_trace_step_fn("output"),
                    ),
                ),
            ],
        )

        output = agent.invoke("Hello")
        self.assertIsInstance(output, str)
        msgs = trace_dag_context(context)
        logger.info(pretty_log("\n".join(msgs)))
        self.assertEqual(len(msgs), 3)
        self.assertEqual(msgs[0], "input -> step_1 (0) -> step_2 (1) -> step_3 (2)")
        self.assertEqual(
            msgs[1], "input -> step_1 (0) -> step_2 (1) -> step_4 (3) -> output (5)"
        )
        self.assertEqual(msgs[2], "input -> step_1 (0) -> step_5 (4) -> output (5)")


if __name__ == "__main__":
    unittest.main()
