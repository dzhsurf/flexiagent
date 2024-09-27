import logging
from typing import Type

from llama_cpp import Dict
from openai import OpenAI

from flexiagent.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexiagent.llm.structured_schema import FxLLMStructuredSchema
from flexiagent.prompts.prompt import PromptTemplate, PromptValue

# from openai.types.chat import ChatCompletion


logger = logging.getLogger(__name__)


class LLMConfigOpenAI(LLMEngineConfig):
    openai_model: str


class LLMEngineOpenAI(LLMEngineImpl[LLMConfigOpenAI]):
    def __init__(self, config: LLMConfigOpenAI):
        super().__init__(config)
        self.client = OpenAI()

    @classmethod
    def engine_name(cls) -> str:
        return "OpenAI"

    @classmethod
    def config_cls(cls) -> Type[LLMConfigOpenAI]:
        return LLMConfigOpenAI

    def chat_completion(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        response = self.client.chat.completions.create(
            temperature=0,
            model=self.config.openai_model,
            messages=prompt.to_openai_chat_completion_messages(variables),
            stop=prompt.stop_prompt,
            timeout=self.config.timeout,
        )

        if len(response.choices) > 0 and response.choices[0].message.content:
            return response.choices[0].message.content.strip()

        return ""

    def chat_completion_with_structured_output(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
        response_format: Type[FxLLMStructuredSchema] = FxLLMStructuredSchema,
    ) -> FxLLMStructuredSchema:
        response = self.client.beta.chat.completions.parse(
            temperature=0,
            model=self.config.openai_model,
            messages=prompt.to_openai_chat_completion_messages(variables),
            stop=prompt.stop_prompt,
            timeout=self.config.timeout,
            response_format=response_format,
        )
        if len(response.choices) > 0 and response.choices[0].message.parsed:
            return response.choices[0].message.parsed
        raise ValueError(f"response is None.\n\n{response}")
