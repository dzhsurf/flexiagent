from dataclasses import dataclass
import json
import logging
import os
from typing import Any, Generator, List, Tuple
import unittest
from unittest import mock

# from pydantic import BaseModel
from pydantic import BaseModel
import pytest

from flexisearch.agent import FxAgentRunnerConfig
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput
from flexisearch.database.db_executor import DBConfig, DBExecutor
from flexisearch.llm.config import LLMConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.llm import LLM
# from flexisearch.searcher import FxSearcher
# import unittest
# from unittest import mock

logger = logging.getLogger(__name__)


@pytest.fixture
def setup_target() -> Generator[Tuple[FxAgentText2SQL, LLM, FxIndexer], None, None]:
    # setup
    llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
    llm = LLM(llm_config)

    db_name = "real_estate_properties"
    db_path = os.path.abspath(
        f"../../benchmark/spider/database/{db_name}/{db_name}.sqlite"
    )
    db_uri = f"sqlite:///{db_path}"
    db_config = DBConfig(name=db_name, db_uri=db_uri)

    indexer = FxIndexer()
    indexer.connect_to_metadb(db_config)

    agent = FxAgentText2SQL()

    yield (agent, llm, indexer)
    # cleanup work here...
    indexer.disconnect_metadb()


class DatasetItem(BaseModel):
    question_id: int
    question: str
    SQL: str
    db_id: str


def setup_testcases() -> List[Tuple[int, str, str, str, str]]:
    dataset_path = "../../benchmark/bird/dev_20240627/"
    dataset_path = os.path.abspath(dataset_path)
    dataset_json = dataset_path + "/dev.json"

    ans: List[Tuple[int, str, str, str, str]] = []

    # read dataset from json
    with open(dataset_json, "r", encoding="utf-8") as fin:
        json_text = fin.read()
        json_data = json.loads(json_text)
        # total = len(json_data)
        for json_item in json_data:
            item = DatasetItem(**json_item)
            ans.append(
                (
                    item.question_id,
                    item.question,
                    item.SQL,
                    item.db_id,
                    dataset_path + "/dev_databases",
                )
            )

    return ans[:0]


# class TestText2Sql(unittest.TestCase):
#     def setUp(self):
#         logger.info("setup")

#     def tearDown(self):
#         logger.info("tearDown")

#     @mock.patch.dict(os.environ, {"OPENAI_API_KEY": "test"}, clear=True)
#     def test_run(self):
#         assert os.environ["OPENAI_API_KEY"] == "test"
#         assert True


@pytest.mark.parametrize("question_id,question,sql,db_id,db_path", setup_testcases())
def test_text2sql(
    setup_target: Tuple[FxAgentText2SQL, LLM, FxIndexer],
    question_id: int,
    question: str,
    sql: str,
    db_id: str,
    db_path: str,
):
    agent = setup_target[0]
    llm = setup_target[1]
    indexer = setup_target[2]

    result = agent.invoke(
        configure=FxAgentRunnerConfig(llm, indexer),
        input=FxAgentText2SQLInput(
            input=question,
        ),
    )
    pred_sql = result.value

    # assert pred_sql == sql
    db = DBExecutor(
        DBConfig(name=db_id, db_uri=f"sqlite:///{db_path}/{db_id}/{db_id}.sqlite")
    )
    evaluation = db.query(pred_sql)
    expected = db.query(sql)
    assert evaluation == expected

if __name__ == "__main__":
    unittest.main()
