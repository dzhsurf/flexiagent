import logging
import os
from typing import Dict, Optional, Type, cast

from llama_cpp import (
    ChatCompletionRequestMessage,
    CreateChatCompletionResponse,
    Llama,
)
from pydantic import ValidationError

from flexiagent.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexiagent.llm.structured_schema import FxLLMStructuredSchema
from flexiagent.prompts.prompt import (
    PromptTemplate,
    PromptValue,
)

logger = logging.getLogger(__name__)


class LLMConfigLlamaCpp(LLMEngineConfig):
    repo_id_or_model_path: str
    repo_filename: Optional[str] = None
    n_ctx: Optional[int] = None
    chat_format: Optional[str] = None
    echo: bool = True


class LLMEngineLlamaCpp(LLMEngineImpl[LLMConfigLlamaCpp]):
    def __init__(self, config: LLMConfigLlamaCpp):
        super().__init__(config)

        model_path = config.repo_id_or_model_path
        if os.path.isfile(model_path):
            self.llm = Llama(
                model_path,
                n_ctx=config.n_ctx if config.n_ctx else 512,
                n_batch=config.n_ctx if config.n_ctx else 512,
                chat_format=config.chat_format,
                verbose=False,
            )
        else:
            self.llm = Llama.from_pretrained(
                model_path,
                config.repo_filename,
                n_ctx=config.n_ctx if config.n_ctx else 512,
                n_batch=config.n_ctx if config.n_ctx else 512,
                chat_format=config.chat_format,
                verbose=False,
            )

    @classmethod
    def engine_name(cls) -> str:
        return "LlamaCpp"

    @classmethod
    def config_cls(cls) -> Type[LLMConfigLlamaCpp]:
        return LLMConfigLlamaCpp

    def chat_completion(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        messages = [
            cast(ChatCompletionRequestMessage, msg)
            for msg in prompt.to_openai_chat_completion_messages(variables)
        ]
        logger.debug(messages)

        response = self.llm.create_chat_completion(
            temperature=0,
            messages=messages,
            stop=prompt.stop_prompt if len(prompt.stop_prompt) > 0 else None,
        )
        res = cast(CreateChatCompletionResponse, response)

        if len(res["choices"]) > 0 and res["choices"][0]["message"]["content"]:
            return res["choices"][0]["message"]["content"].strip()

        return ""

    def chat_completion_with_structured_output(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
        response_format: Type[FxLLMStructuredSchema] = FxLLMStructuredSchema,
    ) -> FxLLMStructuredSchema:
        messages = [
            cast(ChatCompletionRequestMessage, msg)
            for msg in prompt.to_openai_chat_completion_messages(variables)
        ]
        logger.debug(messages)

        json_schema = response_format.model_json_schema()

        response = self.llm.create_chat_completion(
            temperature=0,
            messages=messages,
            stop=prompt.stop_prompt if len(prompt.stop_prompt) > 0 else None,
            response_format={
                "type": "json_object",
                "schema": json_schema,
            },
        )

        logger.debug(response)

        result_json_text = ""
        res = cast(CreateChatCompletionResponse, response)
        if len(res["choices"]) > 0 and res["choices"][0]["message"]["content"]:
            result_json_text = res["choices"][0]["message"]["content"].strip()

        logger.debug(result_json_text)
        try:
            result_obj = response_format.model_validate_json(result_json_text)
        except ValidationError:
            raise TypeError(f"LLM Structured output failed. {result_json_text}")

        return result_obj
