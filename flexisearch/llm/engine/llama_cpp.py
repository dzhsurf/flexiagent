from typing import Dict, Optional, Type, cast

from llama_cpp import CreateCompletionResponse, Llama

from flexisearch.llm.engine.engine_base import LLMEngineConfig, LLMEngineImpl
from flexisearch.prompt import PromptInstTemplate, PromptTemplate, PromptValue


class LLMConfigLlamaCpp(LLMEngineConfig):
    path_or_name: str
    n_ctx: Optional[int] = None
    echo: bool = True


class LLMEngineLlamaCpp(LLMEngineImpl[LLMConfigLlamaCpp]):
    def __init__(self, config: LLMConfigLlamaCpp):
        super().__init__(config)

        self.llm = Llama(
            model_path=config.path_or_name,
            n_ctx=config.n_ctx if config.n_ctx else 512,
            n_batch=config.n_ctx if config.n_ctx else 512,
            verbose=False,
        )
        # qwen: models--Qwen--Qwen2-7B-Instruct-GGUF/snapshots/c3024c6fff0a02d52119ecee024bbb93d4b4b8e4/qwen2-7b-instruct-q4_k_m.gguf
        # pip install huggingface-hub
        # self.llm2 = Llama.from_pretrained(
        #     repo_id="TheBloke/Llama-2-7B-Chat-GGUF",
        #     filename="*Q4_K_M.gguf",
        #     verbose=False,
        # )

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
        inst_template = PromptInstTemplate()

        whole_prompt = prompt.to_text(inst_template, variables)

        response = self.llm(
            whole_prompt,
            temperature=0,
            max_tokens=self.config.n_ctx,
            stop=prompt.stop_prompt,
            echo=self.config.echo,
            stream=False,
        )
        res = cast(CreateCompletionResponse, response)

        res_text = res["choices"][0]["text"]
        p1 = res_text.find(inst_template.inst_tag_begin)
        p2 = res_text.find(inst_template.inst_tag_end)
        if p2 > p1 and p1 >= 0:
            res_text = res_text[p2 + len(inst_template.inst_tag_end) :]

        return res_text.strip()
