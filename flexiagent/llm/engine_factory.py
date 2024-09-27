import json
from typing import List, Type

from flexiagent.llm.config import LLMConfig
from flexiagent.llm.engine.engine_base import LLMEngine
from flexiagent.llm.engine.llama_cpp import LLMEngineLlamaCpp
from flexiagent.llm.engine.openai import LLMEngineOpenAI


class LLMEngineLoader:
    @classmethod
    def get_support_engines(self) -> List[Type[LLMEngine]]:
        return [
            LLMEngineOpenAI,
            LLMEngineLlamaCpp,
        ]

    @classmethod
    def load_engine(cls, config: LLMConfig) -> LLMEngine:
        if isinstance(config.params, (str, dict)):
            if isinstance(config.params, dict):
                config_dict = config.params
            else:
                config_dict = dict(json.loads(config.params))
            for engine in LLMEngineLoader.get_support_engines():
                if config.engine == engine.engine_name():
                    return engine(engine.config_cls()(**config_dict))
        else:
            for engine in LLMEngineLoader.get_support_engines():
                if isinstance(config.params, engine.config_cls()):
                    return engine(config.params)

        raise TypeError(f"Engine not support. Config: {config}")
