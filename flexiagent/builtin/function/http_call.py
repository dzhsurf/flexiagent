import json
from typing import Any, Dict, Union

import httpx

from flexiagent.task.base import TaskActionContext, TaskEntity


class BuiltinHttpcallInput(TaskEntity):
    endpoint: str
    timeout: float = 30
    http_response_encoding: str = "utf-8"


def builtin_http_call(
    ctx: TaskActionContext, input: Dict[str, Any], addition: Dict[str, Any]
) -> Union[TaskEntity, str]:
    input_param = BuiltinHttpcallInput(**addition)
    output_schema = ctx["config"].output_schema

    timeout = httpx.Timeout(input_param.timeout)
    response = httpx.get(input_param.endpoint, timeout=timeout)
    if response.status_code == 200:
        if output_schema is None:
            return
        elif output_schema is str:
            body = response.content.decode(encoding=input_param.http_response_encoding)
            return body
        elif issubclass(output_schema, TaskEntity):
            body = response.json()
            return output_schema.model_validate_json(json.dumps(body))
        else:
            raise TypeError(f"output schema not support, {output_schema}")
    else:
        raise ValueError(f"HTTP Error. {response.status_code}")
