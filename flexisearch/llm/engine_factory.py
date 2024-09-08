import json
from typing import List, Type

from flexisearch.llm.config import LLMConfig
from flexisearch.llm.engine.engine_base import LLMEngine
from flexisearch.llm.engine.llama_cpp import LLMEngineLlamaCpp
from flexisearch.llm.engine.openai import LLMEngineOpenAI


class LLMEngineLoader:
    @classmethod
    def get_support_engines(self) -> List[Type[LLMEngine]]:
        return [
            LLMEngineOpenAI,
            LLMEngineLlamaCpp,
        ]

    @classmethod
    def load_engine(cls, config: LLMConfig) -> LLMEngine:
        if isinstance(config.engine_config, (str, dict)):
            if isinstance(config.engine_config, dict):
                config_dict = config.engine_config
            else:
                config_dict = dict(json.loads(config.engine_config))
            for engine in LLMEngineLoader.get_support_engines():
                if config.engine == engine.engine_name():
                    return engine(engine.config_cls()(**config_dict))
        else:
            for engine in LLMEngineLoader.get_support_engines():
                if isinstance(config.engine_config, engine.config_cls()):
                    return engine(config.engine_config)

        raise TypeError(f"Engine not support. Config: {config}")
