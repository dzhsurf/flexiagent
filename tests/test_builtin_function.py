import unittest
from typing import Any, Dict, List

from pydantic import RootModel

from flexiagent.builtin.function.http_call import builtin_http_call
from flexiagent.task.base import TaskAction, TaskConfig, TaskEntity
from flexiagent.task.task_agent import create_task_agent


class APIItemSchema(RootModel[Dict[str, Any]]):
    pass


class APISchema(TaskEntity, RootModel[List[APIItemSchema]]):
    pass


class TestBuiltinFunction(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_builtin_httpcal_by_str_config(self):
        agent = create_task_agent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={},
                    output_schema=APISchema,
                    action=TaskAction(
                        type="function",
                        act="builtin.http_call",
                        addition={
                            "endpoint": "https://api.restful-api.dev/objects",
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        self.assertIsInstance(output, APISchema)

    def test_builtin_httpcall_output_entity(self):
        agent = create_task_agent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={},
                    output_schema=APISchema,
                    action=TaskAction(
                        type="function",
                        act=builtin_http_call,
                        addition={
                            "endpoint": "https://api.restful-api.dev/objects",
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        self.assertIsInstance(output, APISchema)

    def test_builtin_httpcall_output_str(self):
        agent = create_task_agent(
            task_graph=[
                TaskConfig(
                    task_key="output",
                    input_schema={},
                    output_schema=str,
                    action=TaskAction(
                        type="function",
                        act=builtin_http_call,
                        addition={
                            "endpoint": "https://api.restful-api.dev/objects",
                        },
                    ),
                ),
            ]
        )
        output = agent.invoke()
        self.assertIsInstance(output, str)


if __name__ == "__main__":
    unittest.main()
