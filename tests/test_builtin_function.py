from typing import Any, Dict, List
import unittest

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

    def test_builtin_httpcall(self):
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
                                output_schema=APISchema,
                            ),
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        print(output)


if __name__ == "__main__":
    unittest.main()
