import logging
import os
from typing import Any, Dict, List, Literal
import unittest
from unittest import mock

from tqdm import tqdm

from flexisearch.agent import FxAgentRunnerConfig
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput
from flexisearch.database.db_executor import DBConfig
from flexisearch.llm.config import LLMConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.engine.engine_base import LLMEngineConfig
from flexisearch.llm.engine.openai import LLMConfigOpenAI, LLMEngineOpenAI
from flexisearch.llm.llm import LLM
from .bird_utils import BirdDatasetProvider
from .utils import DatasetItem, SQLExecuteParams, execution_accuracy

# disable some module log
logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("flexisearch").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)


ENV_KEYS = Literal["BIRD_DATASET_PATH", "SPIDER_V1_PATH"]


def get_env_value(key: ENV_KEYS) -> str:
    return os.environ.get(key, "")


class TestText2Sql(unittest.TestCase):
    @mock.patch.dict(os.environ, {"LLM_HTTP_API_TIMEOUT": "30"}, clear=False)
    def setUp(self):
        self.agent = FxAgentText2SQL()
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
        self.llm = LLM(llm_config)
        self.indexer = FxIndexer()
        self.configure = FxAgentRunnerConfig(self.llm, self.indexer)

    def tearDown(self):
        pass

    @mock.patch.dict(
        os.environ,
        {
            "BIRD_DATASET_PATH": "../../benchmark/bird/dev_20240627/",
        },
        clear=True,
    )
    def test_bird(self):
        pred_sqls: List[str] = []

        logger.info("Initialize BIRD dataset...")
        bird_utils = BirdDatasetProvider()
        bird_utils.setup(get_env_value("BIRD_DATASET_PATH"))
        items = bird_utils.get_all_dataset_items()

        # prepare indexer metadb
        for item in items:
            self.indexer.add_metadb(DBConfig(name=item.db_id, db_uri=item.db_uri))

        logger.info("Start run cases...")
        for i in tqdm(range(len(items))):
            item = items[i]
            pred_sql = self._run_predict(item.question)
            pred_sqls.append(pred_sql)

        logger.info("Start evaluation...")
        self._do_evaluation(items, pred_sqls)

    def test_bird_mock_db_selector(self):
        assert True

    def test_spider_1(self):
        assert True

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


if __name__ == "__main__":
    unittest.main()
