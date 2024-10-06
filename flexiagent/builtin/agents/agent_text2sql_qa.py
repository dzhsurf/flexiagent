from typing import Any, Callable, Dict, Optional, Tuple

from flexiagent.builtin.agents.agent_db_recognition import DatabaseMetaInfo
from flexiagent.builtin.agents.agent_text2sql import (
    Text2SQLAgentInput,
    Text2SQLAgentOutput,
    create_text2sql_agent,
)
from flexiagent.database.db_executor import DBConfig, DBExecutor
from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    TaskAction,
    TaskActionLLM,
    TaskAgent,
    TaskConfig,
    TaskEntity,
)


class _SQLExecutionOutput(TaskEntity):
    result: str


def _convert_input_to_text2sql_agent_input(
    input: Dict[str, Any],
) -> Tuple[Dict[str, Any], bool]:
    if not isinstance(input["input"], str):
        raise TypeError(f"input not match. {input}")
    if not isinstance(input["setup_database_metainfo"], DatabaseMetaInfo):
        raise TypeError(f"input not match. {input}")

    question: str = input["input"]
    metainfo: DatabaseMetaInfo = input["setup_database_metainfo"]
    metainfo_text = f"""
DB_ID: {metainfo.db_id}
DB_Metainfo:
{metainfo.db_metainfo}

"""
    input["input"] = Text2SQLAgentInput(
        question=question,
        db_metainfo=metainfo_text,
    )

    return input, False


def _sql_execute(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> _SQLExecutionOutput:
    if not isinstance(input["text2sql_agent"], Text2SQLAgentOutput):
        raise TypeError(f"Input not match. {input}")
    if not isinstance(input["setup_database_metainfo"], DatabaseMetaInfo):
        raise TypeError(f"Input not match. {input}")

    text2sql: Text2SQLAgentOutput = input["text2sql_agent"]
    metainfo: DatabaseMetaInfo = input["setup_database_metainfo"]

    db_config = DBConfig(name=metainfo.db_id, db_uri=metainfo.db_uri)
    executor = DBExecutor(db_config)
    result = executor.pretty_print_query(text2sql.sql)

    return _SQLExecutionOutput(result=result)


def create_text2sql_qa_agent(
    llm_config: LLMConfig,
    fetch_databases_metainfo_func: Callable[
        [Dict[str, Any], Dict[str, Any]], DatabaseMetaInfo
    ],
    preprocess_hook: Optional[
        Callable[[Dict[str, Any]], Tuple[Dict[str, Any], bool]]
    ] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
) -> TaskAgent:
    agent = TaskAgent(
        task_graph=[
            # step 1: setup database metainfo
            TaskConfig(
                task_key="setup_database_metainfo",
                input_schema={},
                output_schema=DatabaseMetaInfo,
                action=TaskAction(
                    type="function",
                    act=fetch_databases_metainfo_func,
                ),
            ),
            # step 2: llm text2sql agent
            TaskConfig(
                task_key="text2sql_agent",
                input_schema={
                    "input": str,
                    "setup_database_metainfo": DatabaseMetaInfo,
                },
                output_schema=Text2SQLAgentOutput,
                action=TaskAction(
                    type="agent",
                    act=create_text2sql_agent(
                        llm_config,
                        preprocess_hook=_convert_input_to_text2sql_agent_input,
                    ),
                ),
            ),
            # step 3: execute db query
            TaskConfig(
                task_key="execute_db_query",
                input_schema={
                    "text2sql_agent": Text2SQLAgentOutput,
                    "setup_database_metainfo": DatabaseMetaInfo,
                },
                output_schema=_SQLExecutionOutput,
                action=TaskAction(
                    type="function",
                    act=_sql_execute,
                ),
            ),
            # step 4: llm response with context
            TaskConfig(
                task_key="output",
                input_schema={
                    "input": str,
                    "execute_db_query": _SQLExecutionOutput,
                },
                output_schema=str,
                action=TaskAction(
                    type="llm",
                    act=TaskActionLLM(
                        llm_config=llm_config,
                        instruction="""You are a helpful assistant, follow the instructure and response the question below.

The following are results accurately matched from the database based on the user's question. 
Answer the user's question based on these results.

{execute_db_query.result}

{input}
""",
                    ),
                ),
            ),
        ],
        preprocess_hook=preprocess_hook,
        postprocess_hook=postprocess_hook,
    )
    return agent
