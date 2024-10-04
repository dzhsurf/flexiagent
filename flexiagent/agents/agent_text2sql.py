import logging
from typing import Any, Callable, Dict, Optional, Tuple

import sqlparse

from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

logger = logging.getLogger(__name__)


class Text2SQLAgentInput(FxTaskEntity):
    question: str
    db_metainfo: str


class Text2SQLAgentOutput(FxTaskEntity):
    sql: str


def _sql_format_and_output(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> Text2SQLAgentOutput:
    for _, v in input.items():
        if isinstance(v, Text2SQLAgentOutput):
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
            return Text2SQLAgentOutput(sql=sql)
    raise ValueError(f"Input type not match. {input}")


def create_text2sql_agent(
    llm_config: LLMConfig,
    preprocess_hook: Optional[
        Callable[[Dict[str, Any]], Tuple[Dict[str, Any], bool]]
    ] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    custom_llm_instruction: Optional[str] = None,
) -> FxTaskAgent:
    # llm instruction
    if custom_llm_instruction:
        instruction = custom_llm_instruction
    else:
        instruction = """You are a SQLite expert. Given an input question, create a syntactically correct SQLite query to the input question.
Never query for all columns from a table. You must query only the columns that are needed to answer the question. Wrap each column name in double quotes (") to denote them as delimited identifiers.
Pay attention to use only the column names you can see in the tables below. Be careful to not query for columns that do not exist. Also, pay attention to which column is in which table.
Pay attention to use date('now') function to get the current date, if the question involves "today". 

Avoid using nested queries in the WHERE clause. 
Prefer using JOINs instead of nested queries.

Only use the following tables:
{input.db_metainfo}

{input.question}
"""
    # create agent task DAG
    agent = FxTaskAgent(
        task_graph=[
            # step 1: llm text2sql
            FxTaskConfig(
                task_key="text2sql",
                input_schema={"input": Text2SQLAgentInput},
                output_schema=Text2SQLAgentOutput,
                action=FxTaskAction(
                    type="llm",
                    act=FxTaskActionLLM(
                        llm_config=llm_config,
                        instruction=instruction,
                    ),
                ),
            ),
            # step 2: sql formater and combine everything
            FxTaskConfig(
                task_key="output",
                input_schema={"text2sql": Text2SQLAgentOutput},
                output_schema=Text2SQLAgentOutput,
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
