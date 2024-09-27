from typing import Any, Dict, Literal, Union

from pydantic import BaseModel

from flexiagent.llm.engine.llama_cpp import LLMConfigLlamaCpp
from flexiagent.llm.engine.openai import LLMConfigOpenAI

LLMEngineConfigALL = Union[LLMConfigOpenAI, LLMConfigLlamaCpp]


class LLMConfig(BaseModel):
    engine: Literal["OpenAI", "LlamaCpp"]
    params: Union[str, Dict[str, Any], LLMEngineConfigALL]
