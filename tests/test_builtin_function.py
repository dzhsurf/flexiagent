import unittest
from typing import Any, Dict, List

from pydantic import RootModel

from flexiagent.builtin.function.http_call import BuiltinHttpcallInput, builtin_httpcall
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)


class APIItemSchema(RootModel[Dict[str, Any]]):
    pass


class APISchema(FxTaskEntity, RootModel[List[APIItemSchema]]):
    pass


class TestBuiltinFunction(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_builtin_httpcall_output_entity(self):
        agent = FxTaskAgent(
            task_graph=[
                FxTaskConfig(
                    task_key="output",
                    input_schema={},
                    output_schema=APISchema,
                    action=FxTaskAction(
                        type="function",
                        act=builtin_httpcall,
                        addition={
                            "input": BuiltinHttpcallInput(
                                endpoint="https://api.restful-api.dev/objects",
                            ),
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        self.assertIsInstance(output, APISchema)

    def test_builtin_httpcall_output_str(self):
        agent = FxTaskAgent(
            task_graph=[
                FxTaskConfig(
                    task_key="output",
                    input_schema={},
                    output_schema=str,
                    action=FxTaskAction(
                        type="function",
                        act=builtin_httpcall,
                        addition={
                            "input": BuiltinHttpcallInput(
                                endpoint="https://api.restful-api.dev/objects",
                            ),
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        self.assertIsInstance(output, str)


if __name__ == "__main__":
    unittest.main()
