import os
import unittest
from typing import Any, Callable, Dict
from unittest import mock
from unittest.mock import patch

from flexiagent.agents.agent_db_recognition import (
    AllDatabasesMetaInfo,
    DatabaseMetaInfo,
)
from flexiagent.agents.agent_text2sql import (
    Text2SQLOutput,
    create_text2sql_agent_with_db_recognition,
)
from flexiagent.indexer import FxIndexer
from flexiagent.llm.config import LLMConfig


def create_fetch_all_databases_metainfo_func(
    indexer: FxIndexer,
) -> Callable[[Dict[str, Any]], AllDatabasesMetaInfo]:
    def fn(context: Dict[str, Any]) -> AllDatabasesMetaInfo:
        result = AllDatabasesMetaInfo(db_metainfo_list=[])
        for db_name in indexer.get_all_dbnames():
            metainfo = DatabaseMetaInfo(
                db_id=db_name,
                db_uri=indexer.get_db_uri(db_name),
                db_metainfo=indexer.get_db_schema(db_name),
            )
            result.db_metainfo_list.append(metainfo)
        return result

    return fn


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

    # @patch("flexisearch.llm.llm.LLM.chat_completion_with_structured_output")
    # @patch("flexisearch.agents.agent_text2sql.create_db_recognition_agent")
    def test_text2sql(self):
        # TODO: ...
        # result = self.agent.invoke("What is the most population song")
        # self.assertIsInstance(result, Text2SQLOutput)
        assert True


if __name__ == "__main__":
    unittest.main()
