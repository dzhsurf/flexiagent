import logging
from typing import Any, Dict

from flexisearch.agents.agent_text2sql import create_text2sql_agent_with_db_recognition
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.llm.llm import LLM

logger = logging.getLogger(__name__)


class FxSearcher:
    def __init__(self, llm_config: LLMConfig, indexer: FxIndexer):
        self.llm = LLM(llm_config)
        self.indexer = indexer

    def assist(self, query: str) -> str:
        return ""
