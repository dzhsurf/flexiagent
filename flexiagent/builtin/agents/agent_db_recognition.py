from typing import Any, Callable, Dict, List, Optional, Tuple

from flexiagent.llm.config import LLMConfig
from flexiagent.task.base import (
    TaskAction,
    TaskActionContext,
    TaskActionLLM,
    TaskConfig,
    TaskEntity,
)
from flexiagent.task.task_agent import TaskAgent


class DatabaseMetaInfo(TaskEntity):
    db_id: str
    db_uri: str
    db_metainfo: str


class AllDatabasesMetaInfo(TaskEntity):
    db_metainfo_list: List[DatabaseMetaInfo]


class DBRecognitionAgentInput(TaskEntity):
    question: str


class DBRecognitionAgentOutput(TaskEntity):
    metainfo: DatabaseMetaInfo


class _DBRecognitionTaskOutput(TaskEntity):
    db_id: str


class DBRecognitionAgentLogic:
    @classmethod
    def generate_all_databases_metainfo_as_text(
        cls, ctx: TaskActionContext, input: Dict[str, Any], addition: Dict[str, Any]
    ) -> str:
        result = ""
        for _, v in input.items():
            if isinstance(v, AllDatabasesMetaInfo):
                result += f"Total database count: {len(v.db_metainfo_list)}\n"
                for idx, knowledge in enumerate(v.db_metainfo_list):
                    result += f"Database ({idx})\n"
                    result += "DB_ID: " + knowledge.db_id + "\n"
                    # result += "DB_URI: " + knowledge.db_uri + "\n"
                    result += "DB_METAINFO:\n" + knowledge.db_metainfo + "\n\n"
        return result

    @classmethod
    def generate_output(
        cls, ctx: TaskActionContext, input: Dict[str, Any], addition: Dict[str, Any]
    ) -> DBRecognitionAgentOutput:
        if not isinstance(input["database_recognition"], _DBRecognitionTaskOutput):
            raise TypeError(f"input not match: {input}")
        if not isinstance(input["fetch_all_databases_metainfo"], AllDatabasesMetaInfo):
            raise TypeError(f"input not match: {input}")

        task_output: _DBRecognitionTaskOutput = input["database_recognition"]
        all_metainfos: AllDatabasesMetaInfo = input["fetch_all_databases_metainfo"]
        for metainfo in all_metainfos.db_metainfo_list:
            if task_output.db_id == metainfo.db_id:
                return DBRecognitionAgentOutput(metainfo=metainfo)
        raise ValueError(f"db_id not found: {input}")


def create_db_recognition_agent(
    llm_config: LLMConfig,
    fetch_all_databases_metainfo_func: Callable[
        [TaskActionContext, Dict[str, Any], Dict[str, Any]], AllDatabasesMetaInfo
    ],
    preprocess_hook: Optional[
        Callable[[Dict[str, Any]], Tuple[Dict[str, Any], bool]]
    ] = None,
    postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
) -> TaskAgent:
    agent = TaskAgent(
        task_graph=[
            # step 1: fetch all database metainfo
            TaskConfig(
                task_key="fetch_all_databases_metainfo",
                input_schema={},
                output_schema=AllDatabasesMetaInfo,
                action=TaskAction(
                    type="function",
                    act=fetch_all_databases_metainfo_func,
                ),
            ),
            # step 2: generate metainfo into text
            TaskConfig(
                task_key="generate_all_databases_metainfo_as_text",
                input_schema={"fetch_all_databases_metainfo": AllDatabasesMetaInfo},
                output_schema=str,
                action=TaskAction(
                    type="function",
                    act=DBRecognitionAgentLogic.generate_all_databases_metainfo_as_text,
                ),
            ),
            # step 3: llm recognition
            TaskConfig(
                task_key="database_recognition",
                input_schema={
                    "input": DBRecognitionAgentInput,
                    "generate_all_databases_metainfo_as_text": str,
                },
                output_schema=_DBRecognitionTaskOutput,
                action=TaskAction(
                    type="llm",
                    act=TaskActionLLM(
                        llm_config=llm_config,
                        instruction="""
Match the user's questions with the corresponding database from the knowledge base based on the user's inquiries.

Question: {input.question}
Databases metainfo:
{generate_all_databases_metainfo_as_text}
""",
                    ),
                ),
            ),
            # step 4: combine everything
            TaskConfig(
                task_key="output",
                input_schema={
                    "database_recognition": _DBRecognitionTaskOutput,
                    "fetch_all_databases_metainfo": AllDatabasesMetaInfo,
                },
                output_schema=DBRecognitionAgentOutput,
                action=TaskAction(
                    type="function",
                    act=DBRecognitionAgentLogic.generate_output,
                ),
            ),
        ],
        preprocess_hook=preprocess_hook,
        postprocess_hook=postprocess_hook,
    )
    return agent
