import logging
from typing import Dict, Type

from flexisearch.llm.config import LLMConfig
from flexisearch.llm.engine_factory import LLMEngineLoader
from flexisearch.llm.structured_schema import FxLLMStructuredSchema
from flexisearch.prompt import PromptTemplate, PromptValue

logger = logging.getLogger(__name__)


class LLM:
    def __init__(self, config: LLMConfig):
        self.engine = LLMEngineLoader.load_engine(config)

    def chat_completion(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ):
        return self.engine.chat_completion(prompt, variables=variables)

    def chat_completion_with_structured_output(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
        response_format: Type[FxLLMStructuredSchema] = FxLLMStructuredSchema,
    ) -> FxLLMStructuredSchema:
        return self.engine.chat_completion_with_structured_output(
            prompt,
            variables=variables,
            response_format=response_format,
        )
