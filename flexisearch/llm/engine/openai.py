from typing import Type

from llama_cpp import Dict
from openai import OpenAI

from flexisearch.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexisearch.prompt import PromptTemplate, PromptValue


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

    def query(
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
        )

        if len(response.choices) > 0 and response.choices[0].message.content:
            return response.choices[0].message.content.strip()

        return ""
