import logging
from typing import Dict, Optional, Type, cast
import os
from llama_cpp import (
    ChatCompletionRequestMessage,
    CreateChatCompletionResponse,
    Llama,
)

from flexisearch.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexisearch.prompt import PromptTemplate, PromptValue

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

    def query(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        # Completion
        # inst_template = PromptInstTemplate()
        # whole_prompt = prompt.to_text(inst_template, variables)

        # response = self.llm(
        #     whole_prompt,
        #     temperature=0,
        #     max_tokens=self.config.n_ctx,
        #     stop=prompt.stop_prompt,
        #     echo=self.config.echo,
        #     stream=False,
        # )
        # res = cast(CreateCompletionResponse, response)
        # res_text = res["choices"][0]["text"]
        # p1 = res_text.find(inst_template.inst_tag_begin)
        # p2 = res_text.find(inst_template.inst_tag_end)
        # if p2 > p1 and p1 >= 0:
        #     res_text = res_text[p2 + len(inst_template.inst_tag_end) :]

        # For ChatCompletion
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
