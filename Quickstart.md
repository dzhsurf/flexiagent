Quickstart
----------



## Concept

**Objects to Import**

```
from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    TaskAction,
    TaskActionLLM,
    TaskAgent,
    TaskConfig,
    TaskEntity,
)
```



**Three Types of Agents Supported Currently**

- LLM
- Function
- Agent 



**Input and Output of an Agent**

When the agent is called using `invoke`, the key `"input"` is passed as a parameter to the agent’s task. The type of input must be consistent with the type used in the `invoke` call. The `task_key` set for the agent is `"output"`, and the type set in `output_schema` will be used as the return type of the agent. You can choose not to set an output, in which case the agent returns None.



**Input and Output of an Agent's Task**

Through the configuration of `input_schema`, an agent can use the key of an upstream task's `task_key` to obtain the output of the upstream task. The `output_schema` of the upstream task needs to be consistent with the type of the `input_schema` of the downstream task; otherwise, a TypeError will be raised. Tasks can use `input_schema` and `output_schema` to build a task DAG. If the DAG has loops, an exception will be raised.



**LLMConfig**

```python
# Use OpenAI API, you must set the OPENAI_API_KEY env.
llm_config = LLMConfig(
  engine="OpenAI", params={"openai_model": "gpt-4o-mini"}
)
# Use llama.cpp model
# If repo_id_or_model_path is repo_id, it will download the model from huggingface
# If repo_id_or_model_path is a model file(e.g. xxx_model.gguf ...), it will load the model directly.
llm_config = LLMConfig(
  engine="LlamaCpp",
  params={
    "repo_id_or_model_path": "QuantFactory/Llama-3.2-3B-Instruct-GGUF",
    "repo_filename": "*Q4_K_M.gguf",
    "n_ctx": 4096,
  },
)
```



## Creating an LLM type agent

```python
class ChatOutput(TaskEntity):
  response: str 

instruction = """You are an expert responsible for answering users' questions.
User: {input}
"""

agent = TaskAgent(
  task_graph=[
    TaskConfig(
      task_key="output",
      input_schema={"input": str},
      output_schema=ChatOutput,
      action=TaskAction(
        type="llm",
        act=TaskActionLLM(
          llm_config=llm_config,
          instruction=instruction,
        ),
      ),
    ),
  ],
)
output = agent.invoke("Who are you?")
```



## Creating a function type agent

```python
def agent_fn(input: Dict[str, Any], addition: Dict[str, Any]) -> str:
  result = str(input)
  return result

agent = TaskAgent(
  task_graph=[
    TaskConfig(
      task_key="output",
      input_schema={"input": str},
      output_schema=str,
      action=TaskAction(
        type="function",
        act=agent_fn,
      ),
    ),
  ],
)

output = agent.invoke("Call function")
```



## Creating an agent type agent (support sub-agent)

```python
instruction = """You are an expert responsible for answering users' questions.
User: {input}
"""

llm_agent = TaskAgent(
  task_graph=[
    TaskConfig(
      task_key="output",
      input_schema={"input": str},
      output_schema=ChatOutput,
      action=TaskAction(
        type="llm",
        act=TaskActionLLM(
          llm_config=llm_config,
          instruction=instruction,
        ),
      ),
    ),
  ],
)

agent = TaskAgent(
  task_graph=[
    TaskConfig(
      task_key="output",
      input_schema={"input": str},
      output_schema=ChatOutput,
      action=TaskAction(
        type="agent",
        act=llm_agent,
      ),
    ),
  ],
)

output = agent.invoke("Who are you?")
```



## Building a complex task DAG

```python
context: Dict[str, List[str]] = collections.defaultdict(list)
counter: int = 0
  
# Record the call stack to trace the DAG path
def create_trace_step_fn(name: str) -> Callable[[Dict[str, Any], Dict[str, Any]], str]:
    def trace_step(input: Dict[str, Any], addition: Dict[str, Any]) -> str:
      global counter
      for item_k, _ in input.items():
        context[name].append(item_k)
        context[name + "_call"] = [str(counter)]
        counter += 1
        return name
    return trace_step

agent = TaskAgent(
  task_graph=[
    TaskConfig(
      task_key="step_1",
      input_schema={
        "input": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("step_1"),
      ),
    ),
    TaskConfig(
      task_key="step_2",
      input_schema={
        "step_1": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("step_2"),
      ),
    ),
    TaskConfig(
      task_key="step_3",
      input_schema={
        "step_2": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("step_3"),
      ),
    ),
    TaskConfig(
      task_key="step_4",
      input_schema={
        "step_2": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("step_4"),
      ),
    ),
    TaskConfig(
      task_key="step_5",
      input_schema={
        "step_1": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("step_5"),
      ),
    ),
    TaskConfig(
      task_key="output",
      input_schema={
        "step_4": str,
        "step_5": str,
      },
      output_schema=str,
      action=TaskAction(
        type="function",
        act=create_trace_step_fn("output"),
      ),
    ),
  ],
)

output = agent.invoke("Hello")
```

```plaintext
# DAG Trace Path
input -> step_1 (0) -> step_2 (1) -> step_3 (2)
input -> step_1 (0) -> step_2 (1) -> step_4 (3) -> output (5)
input -> step_1 (0) -> step_5 (4) -> output (5)
```



## Builtin Agent / Function

### Builtin Agent

- **text2sql-qa-agent**

  ```python
  def _fetch_database_metainfo(input: Dict[str, Any], addition: Dict[str, Any]
  ) -> DatabaseMetaInfo:
    # Add db info here
    return DatabaseMetaInfo(
      db_id="db_id",
      db_uri="sqlite:///xxxx.db",
      db_metainfo="db schema",
    )
  
  # create text2sql QA agent 
  agent = create_text2sql_qa_agent(llm_config,
    _fetch_database_metainfo,
    preprocess_hook=_convert_chatbot_input_to_text2sql_qa_input,
  )
  
  # ask question
  answer = agent.invoke("What's your name?")
  # output type is str 
  ```

  

### Builtin Function

- `builtin_httpcall`

  ```python
  from flexiagent.builtin.function.http_call import (
  	BuiltinHttpcallInput, 
    builtin_httpcall,
  )
  from pydantic import RootModel
  
  # define Restful API JSON Schema
  class APIItemSchema(RootModel[Dict[str, Any]]):
      pass
    
  class APISchema(TaskEntity, RootModel[List[APIItemSchema]]):
      pass
  
  # Config builtin function: httpcall
  TaskConfig(
    task_key="output",
    input_schema={},
    output_schema=APISchema,
    action=TaskAction(
      type="function",
      act=builtin_httpcall,
      addition={
        "input": BuiltinHttpcallInput(
          endpoint="https://api.restful-api.dev/objects",
          output_schema=APISchema,
        ),
      },
    ),
  )
  ```

  

## Concurrent agent task

TODO: ...