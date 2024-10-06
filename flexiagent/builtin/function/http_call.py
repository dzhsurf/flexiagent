import json
from typing import Any, Dict, Type, Union

import httpx

from flexiagent.task.task_node import FxTaskEntity


class BuiltinHttpcallInput(FxTaskEntity):
    endpoint: str
    timeout: float = 30
    http_response_encoding: str = "utf-8"


def builtin_httpcall(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> Union[FxTaskEntity, str]:
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

    output_schema: Type[Union[FxTaskEntity, str, None]] = addition["output_schema"]

    timeout = httpx.Timeout(params.timeout)
    response = httpx.get(params.endpoint, timeout=timeout)
    if response.status_code == 200:
        if output_schema is None:
            return
        elif output_schema is str:
            body = response.content.decode(encoding=params.http_response_encoding)
            return body
        elif issubclass(output_schema, FxTaskEntity):
            body = response.json()
            return output_schema.model_validate_json(json.dumps(body))
        else:
            raise TypeError(f"output schema not support, {output_schema}")
    else:
        raise ValueError(f"HTTP Error. {response.status_code}")
