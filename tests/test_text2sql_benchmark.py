import logging
import os
import unittest
from typing import Any, Callable, Dict, List, Literal, Tuple
from unittest import mock

from tqdm import tqdm

from flexiagent.agents.agent_db_recognition import (
    AllDatabasesMetaInfo,
    DatabaseMetaInfo,
)
from flexiagent.agents.agent_text2sql import (
    Text2SQLOutput,
    create_text2sql_agent_with_db_recognition,
)
from flexiagent.database.db_executor import DBConfig
from flexiagent.indexer import FxIndexer
from flexiagent.llm.config import LLMConfig

from tests.bird_utils import BirdDatasetProvider
from tests.utils import DatasetItem, SQLExecuteParams, execution_accuracy

# disable some module log
logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("flexiagent").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)


ENV_KEYS = Literal[
    "BIRD_DATASET_PATH",
    "SPIDER_V1_PATH",
    "DATASET_NUM_TO_TAKE",
]


def get_env_value(key: ENV_KEYS) -> str:
    return os.environ.get(key, "")


def create_fetch_all_databases_metainfo_func(
    indexer: FxIndexer,
) -> Callable[[Dict[str, Any], Dict[str, Any]], AllDatabasesMetaInfo]:
    def func(input: Dict[str, Any], addition: Dict[str, Any]) -> AllDatabasesMetaInfo:
        metainfo_list: List[DatabaseMetaInfo] = []
        for db_name in indexer.get_all_dbnames():
            metainfo_list.append(
                DatabaseMetaInfo(
                    db_id=db_name,
                    db_uri=indexer.get_db_uri(db_name),
                    db_metainfo=indexer.get_db_schema(db_name),
                )
            )
        return AllDatabasesMetaInfo(db_metainfo_list=metainfo_list)

    return func


class TestText2SqlBenchmark(unittest.TestCase):
    @mock.patch.dict(os.environ, {"LLM_HTTP_API_TIMEOUT": "30"}, clear=False)
    def setUp(self):
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})
        self.indexer = FxIndexer()
        self.agent = create_text2sql_agent_with_db_recognition(
            llm_config, create_fetch_all_databases_metainfo_func(self.indexer)
        )

    def tearDown(self):
        pass

    @mock.patch.dict(
        os.environ,
        {
            "BIRD_DATASET_PATH": "../../benchmark/bird/dev_20240627/",
            # "DATASET_NUM_TO_TAKE": "5",
        },
        clear=False,
    )
    def test_bird(self):
        pred_sqls: List[SQLExecuteParams] = []

        logger.info("Initialize BIRD dataset...")
        bird_utils = BirdDatasetProvider()
        bird_utils.setup(get_env_value("BIRD_DATASET_PATH"))
        items = bird_utils.get_all_dataset_items()
        if "DATASET_NUM_TO_TAKE" in os.environ:
            num = int(get_env_value("DATASET_NUM_TO_TAKE"))
            items = items[0:num]

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

    def test_spider_1(self):
        assert True

    def _run_predict(self, question: str) -> SQLExecuteParams:
        result: Text2SQLOutput = self.agent.invoke(question)
        return SQLExecuteParams(
            db_uri=result.metainfo.db_uri,
            sql=result.sql,
        )

    def _do_evaluation(
        self, items: List[DatasetItem], pred_sqls: List[SQLExecuteParams]
    ):
        if len(items) != len(pred_sqls):
            raise ValueError(
                f"items ({len(items)}) count not match pred_sqls ({len(pred_sqls)})."
            )

        pred_queries: List[SQLExecuteParams] = []
        gold_queries: List[SQLExecuteParams] = []
        for item, pred_sql in zip(items, pred_sqls):
            pred_query = pred_sql
            gold_query = SQLExecuteParams(db_uri=item.db_uri, sql=item.sql)
            pred_queries.append(pred_query)
            gold_queries.append(gold_query)

        acc_res = execution_accuracy(pred_queries, gold_queries)
        assert len(acc_res) == len(items)


if __name__ == "__main__":
    unittest.main()
