import logging
from typing import Any, Callable, Dict, Optional, Tuple

from flexiagent.builtin.agents.agent_db_recognition import (
    AllDatabasesMetaInfo,
    DatabaseMetaInfo,
    DBRecognitionAgentInput,
    DBRecognitionAgentOutput,
    create_db_recognition_agent,
)
from flexiagent.builtin.agents.agent_text2sql import (
    Text2SQLAgentInput,
    Text2SQLAgentOutput,
    create_text2sql_agent,
)
from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import FxTaskAction, FxTaskAgent, FxTaskConfig

logger = logging.getLogger(__name__)


def _convert_str_to_dbrecog_input(input: Dict[str, Any]) -> Tuple[Dict[str, Any], bool]:
    input["input"] = DBRecognitionAgentInput(question=input["input"])
    return input, False


def _convert_str_dbrecog_to_text2sql_input(
    input: Dict[str, Any],
) -> Tuple[Dict[str, Any], bool]:
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
    input["input"] = Text2SQLAgentInput(
        question=question,
        db_metainfo=metainfo_text,
    )
    return input, False


class Text2SQLAgentOutputEx(Text2SQLAgentOutput):
    metainfo: DatabaseMetaInfo


def _text2sql_agent_with_db_recog_output(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> Text2SQLAgentOutputEx:
    if not isinstance(input["text2sql_agent"], Text2SQLAgentOutput):
        raise TypeError(f"input not match. {input}")
    if not isinstance(input["db_recognition_agent"], DBRecognitionAgentOutput):
        raise TypeError(f"input not match. {input}")

    text2sql_agent_output: Text2SQLAgentOutput = input["text2sql_agent"]
    db_recognition_agent_output: DBRecognitionAgentOutput = input[
        "db_recognition_agent"
    ]

    return Text2SQLAgentOutputEx(
        sql=text2sql_agent_output.sql,
        metainfo=db_recognition_agent_output.metainfo,
    )


def create_text2sql_agent_with_db_recognition(
    llm_config: LLMConfig,
    fetch_all_databases_metainfo_func: Callable[
        [Dict[str, Any], Dict[str, Any]], AllDatabasesMetaInfo
    ],
    preprocess_hook: Optional[
        Callable[[Dict[str, Any]], Tuple[Dict[str, Any], bool]]
    ] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    custom_text2sql_instruction: Optional[str] = None,
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
                        preprocess_hook=_convert_str_to_dbrecog_input,
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
                output_schema=Text2SQLAgentOutput,
                action=FxTaskAction(
                    type="agent",
                    act=create_text2sql_agent(
                        llm_config,
                        preprocess_hook=_convert_str_dbrecog_to_text2sql_input,
                        custom_llm_instruction=custom_text2sql_instruction,
                    ),
                ),
            ),
            # step 3: output
            FxTaskConfig(
                task_key="output",
                input_schema={
                    "text2sql_agent": Text2SQLAgentOutput,
                    "db_recognition_agent": DBRecognitionAgentOutput,
                },
                output_schema=Text2SQLAgentOutputEx,
                action=FxTaskAction(
                    type="function",
                    act=_text2sql_agent_with_db_recog_output,
                ),
            ),
        ],
        preprocess_hook=preprocess_hook,
        postprocess_hook=postprocess_hook,
    )
    return agent
