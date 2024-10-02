import logging
import os
from functools import wraps

from flexiagent.llm.config import LLMConfig

logger = logging.getLogger(__name__)


class HookObjectMethod:
    def __init__(self, obj, method_name, postprocess_hook):
        self.obj = obj
        self.method_name = method_name
        self.original_method = getattr(obj, method_name)
        self.postprocess_hook = postprocess_hook

    def __enter__(self):
        @wraps(self.original_method)
        async def new_method(*args, **kwargs):
            # call original method
            ret_value = self.original_method(*args, **kwargs)
            # call postprocess_hook
            return self.postprocess_hook(*ret_value)

        setattr(self.obj, self.method_name, new_method)

    def __exit__(self, exc_type, exc_value, traceback):
        setattr(self.obj, self.method_name, self.original_method)


class HookObjectAsyncMethod:
    def __init__(self, obj, method_name, postprocess_hook):
        self.obj = obj
        self.method_name = method_name
        self.original_method = getattr(obj, method_name)
        self.postprocess_hook = postprocess_hook

    def __enter__(self):
        logger.info(f"HookAsyncMethod: {self.method_name}")

        @wraps(self.original_method)
        async def new_method(*args, **kwargs):
            # call original method
            ret_value = await self.original_method(*args, **kwargs)
            # call postprocess_hook
            return await self.postprocess_hook(*ret_value)

        setattr(self.obj, self.method_name, new_method)

    def __exit__(self, exc_type, exc_value, traceback):
        logger.info(f"HookAsyncMethod recover original method: {self.method_name}")
        setattr(self.obj, self.method_name, self.original_method)


def get_llm_config() -> LLMConfig:
    # local config from environment
    engine = os.environ.get("LLM_CONFIG_ENGINE", "LlamaCpp")
    if engine == "OpenAI":
        llm_model = os.environ.get("LLM_CONFIG_OPENAI_MODEL", "gpt-4o-mini")
        llm_config = LLMConfig(engine="OpenAI", params={"openai_model": llm_model})
        if "OPENAI_API_KEY" not in os.environ:
            raise ValueError("OPENAI_API_KEY not set")
    elif engine == "LlamaCpp":
        default_repo_id = "QuantFactory/Llama-3.2-3B-Instruct-GGUF"
        llm_repo_id_or_model_path = os.environ.get(
            "LLM_CONFIG_LLAMACPP_REPO_ID_OR_PATH", default_repo_id
        )
        llm_repo_filename = os.environ.get(
            "LLM_CONFIG_LLAMACPP_REPO_FILENAME", "*Q4_K_M.gguf"
        )
        llm_model_ctx = int(os.environ.get("LLM_CONFIG_LLAMACPP_MODEL_CTX", "4096"))
        llm_config = LLMConfig(
            engine="LlamaCpp",
            params={
                "repo_id_or_model_path": llm_repo_id_or_model_path,
                "repo_filename": llm_repo_filename,
                "n_ctx": llm_model_ctx,
            },
        )
    else:
        raise ValueError(f"LLM_CONFIG_ENGINE not suppport. {engine}")

    return llm_config
