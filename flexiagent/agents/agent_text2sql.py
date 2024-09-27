import logging
from typing import Any, Callable, Dict, Optional

import sqlparse

from flexiagent.agents.agent_db_recognition import (
    AllDatabasesMetaInfo,
    DatabaseMetaInfo,
    DBRecognitionAgentInput,
    DBRecognitionAgentOutput,
    create_db_recognition_agent,
)
from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

logger = logging.getLogger(__name__)


class RawText2SQLAgentInput(FxTaskEntity):
    question: str
    db_metainfo: str


class RawText2SQLAgentOutput(FxTaskEntity):
    sql: str


def _sql_format_and_output(input: Dict[str, Any]) -> RawText2SQLAgentOutput:
    for _, v in input.items():
        if isinstance(v, RawText2SQLAgentOutput):
            sql = v.sql
            sql = sqlparse.format(
                sql, reindent=True, keyword_case="upper", strip_comments=True
            )
            sql = " ".join(sql.split()).strip()
            if len(sql) > 0 and sql[0] == '"' and sql[-1] == '"':
                sql = sql[1:-1].strip()
            sql_valid = sqlparse.parse(sql)
            if not sql_valid:
                raise ValueError(f"SQL invalid. {sql}")
            return RawText2SQLAgentOutput(sql=sql)
    raise ValueError(f"Input type not match. {input}")


def create_raw_text2sql_agent(
    llm_config: LLMConfig,
    preprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
) -> FxTaskAgent:
    agent = FxTaskAgent(
        task_graph=[
            # step 1: llm text2sql
            FxTaskConfig(
                task_key="text2sql",
                input_schema={"input": RawText2SQLAgentInput},
                output_schema=RawText2SQLAgentOutput,
                action=FxTaskAction(
                    type="llm",
                    act=FxTaskActionLLM(
                        llm_config=llm_config,
                        instruction="""You are a SQLite expert. Given an input question, create a syntactically correct SQLite query to the input question.
Never query for all columns from a table. You must query only the columns that are needed to answer the question. Wrap each column name in double quotes (") to denote them as delimited identifiers.
Pay attention to use only the column names you can see in the tables below. Be careful to not query for columns that do not exist. Also, pay attention to which column is in which table.
Pay attention to use date('now') function to get the current date, if the question involves "today". 

Avoid using nested queries in the WHERE clause. 
Prefer using JOINs instead of nested queries.

Only use the following tables:
{input.db_metainfo}

Question: {input.question}
""",
                    ),
                ),
            ),
            # step 2: sql formater and combine everything
            FxTaskConfig(
                task_key="output",
                input_schema={"text2sql": RawText2SQLAgentOutput},
                output_schema=RawText2SQLAgentOutput,
                action=FxTaskAction(
                    type="function",
                    act=_sql_format_and_output,
                ),
            ),
        ],
        preprocess_hook=preprocess_hook,
        postprocess_hook=postprocess_hook,
    )
    return agent


class Text2SQLOutput(FxTaskEntity):
    sql: str
    metainfo: DatabaseMetaInfo


class Text2SQLAgentLogic:
    @classmethod
    def convert_db_recognition_agent_input(
        cls, input: Dict[str, Any]
    ) -> Dict[str, Any]:
        input["input"] = DBRecognitionAgentInput(question=input["input"])
        return input

    @classmethod
    def convert_text2sql_agent_input(cls, input: Dict[str, Any]) -> Dict[str, Any]:
        # RawText2SQLAgentInput
        if not isinstance(input["input"], str):
            raise TypeError(f"input not match. {input}")
        if not isinstance(input["db_recognition_agent"], DBRecognitionAgentOutput):
            raise TypeError(f"input not match. {input}")

        question: str = input["input"]
        agent_output: DBRecognitionAgentOutput = input["db_recognition_agent"]

        metainfo_text = f"""
DB_ID: {agent_output.metainfo.db_id}
DB_Metainfo:
{agent_output.metainfo.db_metainfo}

"""
        input["input"] = RawText2SQLAgentInput(
            question=question,
            db_metainfo=metainfo_text,
        )
        return input

    @classmethod
    def generate_output(cls, input: Dict[str, Any]) -> Text2SQLOutput:
        if not isinstance(input["text2sql_agent"], RawText2SQLAgentOutput):
            raise TypeError(f"input not match. {input}")
        if not isinstance(input["db_recognition_agent"], DBRecognitionAgentOutput):
            raise TypeError(f"input not match. {input}")
        text2sql_agent_output: RawText2SQLAgentOutput = input["text2sql_agent"]
        db_recognition_agent_output: DBRecognitionAgentOutput = input[
            "db_recognition_agent"
        ]
        return Text2SQLOutput(
            sql=text2sql_agent_output.sql,
            metainfo=db_recognition_agent_output.metainfo,
        )


def create_text2sql_agent_with_db_recognition(
    llm_config: LLMConfig,
    fetch_all_databases_metainfo_func: Callable[[Dict[str, Any]], AllDatabasesMetaInfo],
    preprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
) -> FxTaskAgent:
    agent = FxTaskAgent(
        task_graph=[
            # step 1: llm db recognition agent
            FxTaskConfig(
                task_key="db_recognition_agent",
                input_schema={"input": str},
                output_schema=DBRecognitionAgentOutput,
                action=FxTaskAction(
                    type="agent",
                    act=create_db_recognition_agent(
                        llm_config,
                        fetch_all_databases_metainfo_func,
                        preprocess_hook=Text2SQLAgentLogic.convert_db_recognition_agent_input,
                    ),
                ),
            ),
            # step 2: llm text2sql agent
            FxTaskConfig(
                task_key="text2sql_agent",
                input_schema={
                    "input": str,
                    "db_recognition_agent": DBRecognitionAgentOutput,
                },
                output_schema=RawText2SQLAgentOutput,
                action=FxTaskAction(
                    type="agent",
                    act=create_raw_text2sql_agent(
                        llm_config,
                        preprocess_hook=Text2SQLAgentLogic.convert_text2sql_agent_input,
                    ),
                ),
            ),
            # step 3: output
            FxTaskConfig(
                task_key="output",
                input_schema={
                    "text2sql_agent": RawText2SQLAgentOutput,
                    "db_recognition_agent": DBRecognitionAgentOutput,
                },
                output_schema=Text2SQLOutput,
                action=FxTaskAction(
                    type="function",
                    act=Text2SQLAgentLogic.generate_output,
                ),
            ),
        ],
        preprocess_hook=preprocess_hook,
        postprocess_hook=postprocess_hook,
    )
    return agent
