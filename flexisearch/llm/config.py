from typing import Any, Dict, Literal, Union

from pydantic import BaseModel

from flexisearch.llm.engine.llama_cpp import LLMConfigLlamaCpp
from flexisearch.llm.engine.openai import LLMConfigOpenAI

LLMEngineConfigALL = Union[LLMConfigOpenAI, LLMConfigLlamaCpp]


class LLMConfig(BaseModel):
    engine: Literal["OpenAI", "LlamaCpp"]
    engine_config: Union[str, Dict[str, Any], LLMEngineConfigALL]
