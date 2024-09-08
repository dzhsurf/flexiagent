from typing import Dict

from flexisearch.llm.config import LLMConfig
from flexisearch.llm.engine_factory import LLMEngineLoader
# from flexisearch.llm.histroy_tracker import HistoryTracker
from flexisearch.prompt import PromptTemplate, PromptValue


class LLM:
    def __init__(self, config: LLMConfig):
        # self.history_tracker = HistoryTracker()
        self.engine = LLMEngineLoader.load_engine(config)

    def query(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        response = self.engine.query(prompt, variables=variables)
        # self.history_tracker.push_message(
        #     {
        #         "prompt": prompt,
        #         "variables": variables,
        #         "response": response,
        #     }
        # )

        return response
