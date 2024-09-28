import json
import logging
import os
from typing import Any, Dict, Optional, Type, TypedDict, cast

from llama_cpp import (
    ChatCompletionRequestMessage,
    ChatCompletionRequestResponseFormat,
    CreateChatCompletionResponse,
    Llama,
)

from flexiagent.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexiagent.llm.structured_schema import FxLLMStructuredSchema
from flexiagent.prompts.prompt import PromptFewshotSample, PromptTemplate, PromptValue

logger = logging.getLogger(__name__)


class LLMConfigLlamaCpp(LLMEngineConfig):
    repo_id_or_model_path: str
    repo_filename: Optional[str] = None
    n_ctx: Optional[int] = None
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
                verbose=False,
            )
        else:
            self.llm = Llama.from_pretrained(
                model_path,
                config.repo_filename,
                n_ctx=config.n_ctx if config.n_ctx else 512,
                n_batch=config.n_ctx if config.n_ctx else 512,
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
            stop=prompt.stop_prompt,
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
        # fields = response_format.__annotations__
        # json_schema = [f"{name}: {_type}" for name, _type in fields.items()]
        # json_schema_text = "\n".join(json_schema)
        #         prompt.user_question_prompt += f"""
        # Answer in JSON format:
        # {json_schema_text}
        # """

        # prompt_text = prompt.to_text(
        #     inst_template=PromptInstTemplate(),
        #     variables=variables,
        # )
        # print(prompt_text)
        # response = self.llm.create_completion(
        #     prompt_text,
        #     max_tokens=20000,
        #     temperature=0,
        #     stop=prompt.stop_prompt,
        # )

        messages = [
            cast(ChatCompletionRequestMessage, msg)
            for msg in prompt.to_openai_chat_completion_messages(variables)
        ]
        logger.debug(messages)
        print("\n\n", messages)

        response = self.llm.create_chat_completion(
            temperature=0,
            messages=messages,
            stop=prompt.stop_prompt,
            # response_format=ChatCompletionRequestResponseFormat(type="json_object"),
        )

        print(type(response), response)

        return response
        # res = cast(CreateChatCompletionResponse, response)
        # res["choices"][0]["message"]["content"].

        # if len(res["choices"]) > 0 and res["choices"][0]["message"]["content"]:
        #     return res["choices"][0]["message"]["content"].strip()

        # return ""

        # raise ValueError("llama.cpp not support structured output.")
