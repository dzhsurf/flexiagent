import logging
from typing import Any, Dict, List
import unittest
from unittest import mock

import pytest

from flexisearch.agent import FxAgentRunnerConfig
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput
from flexisearch.database.db_executor import DBConfig
from flexisearch.llm.config import LLMConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.llm import LLM
from .bird_utils import BirdDatasetProvider
from .utils import DatasetItem, SQLExecuteParams, execution_accuracy


logger = logging.getLogger(__name__)


TEST_CONFIG: Dict[str, Any] = {
    "bird_dataset_path": "",
}


class TestText2Sql(unittest.TestCase):
    def setUp(self):
        self.agent = FxAgentText2SQL()
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
        self.llm = LLM(llm_config)
        self.indexer = FxIndexer()
        self.configure = FxAgentRunnerConfig(self.llm, self.indexer)

    def tearDown(self):
        logger.info("tearDown")

    @mock.patch.dict(
        TEST_CONFIG, {"bird_dataset_path": "../../benchmark/bird/dev_20240627/"}
    )
    def test_bird(self):
        pred_sqls: List[str] = []

        bird_utils = BirdDatasetProvider()
        bird_utils.setup(TEST_CONFIG["bird_dataset_path"])
        items = bird_utils.get_all_dataset_items()

        # prepare indexer metadb
        for item in items:
            self.indexer.add_metadb(DBConfig(name=item.db_id, db_uri=item.db_uri))

        for item in items:
            pred_sql = self._run_predict(item.question)
            pred_sqls.append(pred_sql)

        self._do_evaluation(items, pred_sqls)

    # def test_spider_1(self):
    #     pass

    def _run_predict(self, question: str) -> str:
        input = FxAgentText2SQLInput(input=question)
        result = self.agent.invoke(self.configure, input)
        return result.value

    def _do_evaluation(self, items: List[DatasetItem], pred_sqls: List[str]):
        if len(items) != len(pred_sqls):
            raise ValueError(
                f"items ({len(items)}) count not match pred_sqls ({len(pred_sqls)})."
            )

        pred_queries: List[SQLExecuteParams] = []
        gold_queries: List[SQLExecuteParams] = []
        for item, pred_sql in zip(items, pred_sqls):
            pred_query = SQLExecuteParams(
                db_uri=item.db_uri,
                sql=pred_sql,
            )
            gold_query = SQLExecuteParams(db_uri=item.db_uri, sql=item.sql)
            pred_queries.append(pred_query)
            gold_queries.append(gold_query)

        acc_res = execution_accuracy(pred_queries, gold_queries)
        assert len(acc_res) == len(items)


# @pytest.mark.parametrize("question_id,question,sql,db_id,db_path", setup_testcases())
# def test_text2sql_bird(
#     setup_target: Tuple[FxAgentText2SQL, LLM, FxIndexer],
#     question_id: int,
#     question: str,
#     sql: str,
#     db_id: str,
#     db_path: str,
# ):
#     agent = setup_target[0]
#     llm = setup_target[1]
#     indexer = setup_target[2]

#     result = agent.invoke(
#         configure=FxAgentRunnerConfig(llm, indexer),
#         input=FxAgentText2SQLInput(
#             input=question,
#         ),
#     )
#     pred_sql = result.value

#     # assert pred_sql == sql
#     db = DBExecutor(
#         DBConfig(name=db_id, db_uri=f"sqlite:///{db_path}/{db_id}/{db_id}.sqlite")
#     )
#     evaluation = db.query(pred_sql)
#     expected = db.query(sql)
#     assert evaluation == expected


if __name__ == "__main__":
    unittest.main()
