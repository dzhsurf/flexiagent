import json
from typing import Any, Dict, Type

import httpx

from flexiagent.task.task_node import FxTaskEntity


class BuiltinHttpcallInput(FxTaskEntity):
    endpoint: str
    output_schema: Type[FxTaskEntity]
    timeout: float = 30


def builtin_httpcall(input: Dict[str, Any], addition: Dict[str, Any]) -> FxTaskEntity:
    if "input" in input:
        if not isinstance(input["input"], BuiltinHttpcallInput):
            raise TypeError(f"input not match. {input}")
        params = input["input"]
    elif "input" in addition:
        if not isinstance(addition["input"], BuiltinHttpcallInput):
            raise TypeError(f"addition not match. {addition}")
        params = addition["input"]
    else:
        raise TypeError(f"no input variable. input: {input} addition: {addition}")

    timeout = httpx.Timeout(params.timeout)
    response = httpx.get(params.endpoint, timeout=timeout)
    if response.status_code == 200:
        body = response.json()
        return params.output_schema.model_validate_json(json.dumps(body))
    else:
        raise ValueError(f"HTTP Error. {response.status_code}")
