from typing import Any, Dict, Literal
import unittest

from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)


class Step1Output(FxTaskEntity):
    num1: float
    num2: float
    op: Literal["+", "-", "*", "/"]


class Step2Output(FxTaskEntity):
    result: float


def compute_nums(input: Dict[str, Any]) -> Step2Output:
    nums: Step1Output = input["step_1"]
    result = 0.0
    if nums.op == "+":
        result = nums.num1 + nums.num2
    elif nums.op == "-":
        result = nums.num1 - nums.num2
    elif nums.op == "*":
        result = nums.num1 * nums.num2
    elif nums.op == "/":
        result = nums.num1 / nums.num2
    else:
        result = 0
    return Step2Output(
        result=result,
    )


def create_agent_with_llm_config(llm_config: LLMConfig) -> FxTaskAgent:
    agent = FxTaskAgent(
        task_graph=[
            # step 1: llm extract data
            FxTaskConfig(
                task_key="step_1",
                input_schema={"input": str},
                output_schema=Step1Output,
                action=FxTaskAction(
                    type="llm",
                    act=FxTaskActionLLM(
                        llm_config=llm_config,
                        instruction="""
Extract the numbers and operators from mathematical expressions based on the user's questions. 
Only support +, -, *, / operations with two numbers.

Question: {input}
""",
                    ),
                ),
            ),
            # step 2: compute
            FxTaskConfig(
                task_key="output",
                input_schema={"step_1": Step1Output},
                output_schema=Step2Output,
                action=FxTaskAction(
                    type="function",
                    act=compute_nums,
                ),
            ),
        ],
    )
    return agent


class TestText2SqlBenchmark(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_custom_agent_openai(self):
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
        agent = create_agent_with_llm_config(llm_config)
        self._run_testcases(agent)

    def test_custom_agent_llamacpp(self):
        llm_config = LLMConfig(
            engine="LlamaCpp",
            params={
                "repo_id_or_model_path": "QuantFactory/Meta-Llama-3.1-8B-Instruct-GGUF",
                "repo_filename": "*Q8_0.gguf",
                "n_ctx": 4096,
            },
        )
        agent = create_agent_with_llm_config(llm_config)
        self._run_testcases(agent)

    def _run_testcases(self, agent: FxTaskAgent):
        output = agent.invoke("Compute: 3 + 5 =")
        self.assertIsInstance(output, Step2Output)
        self.assertEqual(output.result, 8)

        output = agent.invoke("Compute: 3.2 - 5.4 =")
        self.assertIsInstance(output, Step2Output)
        self.assertEqual(output.result, -2.2)

        output = agent.invoke("Compute: 12 * 8 =")
        self.assertIsInstance(output, Step2Output)
        self.assertEqual(output.result, 96)

        output = agent.invoke("Compute: 10 / 5 =")
        self.assertIsInstance(output, Step2Output)
        self.assertEqual(output.result, 2)


if __name__ == "__main__":
    unittest.main()
