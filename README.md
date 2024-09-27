FlexiAgent
-----------

FlexiAgent is an open-source project on GitHub that provides a simple and easy-to-use interface for creating agents based on Directed Acyclic Graphs (DAGs). The agent supports formatted output and includes built-in practical agents such as a text2sql agent, allowing for quick deployment in applications.

Features
--------

- **DAG-Based Agent Creation**: Easily construct agents using a DAG structure to orchestrate multiple tasks.

- **Formatted Output**: FlexiAgent supports generating structured and formatted output to meet specific application needs.

- **Built-In Agents**: Includes useful agents like text2sql for fast deployment and reduced development time.


Installation
------------

To begin using FlexiAgent, clone the repository from GitHub:
```shell
git clone https://github.com/dzhsurf/flexiagent.git
cd flexiagent
```

Ensure you have Python installed and set up a virtual environment(conda recommand):
```shell
# python3.11 recommendation, support python3.8+
conda create -n proj python=3.11 
```

Install the necessary dependencies:
```shell
pip install -e .
# or poetry
# poetry install
```


Usage
-----

Before using FlexiAgent, you'll need to set up your `OPENAI_API_KEY`. You can set this environment variable in your system or include it in your code:

```shell
export OPENAI_API_KEY='your-api-key-here' 
```

FlexiAgent can be easily integrated into your existing projects. Below is a basic setup to get you started:


```python
from flexiagent.llm.config import LLMConfig
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

llm_config = LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"})

class Step1Output(FxTaskEntity):
    num1: float 
    num2: float 
    op: str 

class Step2Output(FxTaskEntity):
    result: float

def compute_nums(input: Dict[str, Any]) -> Step2Output:
    nums: Step1Output = input["step_1"]
    result = 0.0
    if nums.op == "+":
        result = nums.num1 + nums.num2
    elif nums.op == "-":
        result = nums.num1 - nums.num2
    elif nums.op == "*":
        result = nums.num1 * nums.num2
    elif nums.op == "/":
        result = nums.num1 / nums.num2
    else:
        result = 0
    return Step2Output(
        result=result,
    )

agent = FxTaskAgent(
    task_graph=[
        # step 1: llm extract data
        FxTaskConfig(
            task_key="step_1",
            input_schema={"input": str},
            output_schema=Step1Output,
            action=FxTaskAction(
                type="llm",
                act=FxTaskActionLLM(
                    llm_config=llm_config,
                    instruction="""
Extract the numbers and operators from mathematical expressions based on the user's questions. 
Only support +, -, *, / operations with two numbers.

Question: {input}
""",
                ),
            ),
        ),
        # step 2: compute
        FxTaskConfig(
            task_key="output",
            input_schema={"step_1": Step1Output},
            output_schema=Step2Output,
            action=FxTaskAction(
                type="function",
                act=compute_nums,
            ),
        ),
    ],
)

output = agent.invoke("Compute: 3 + 5 =")
# output is Step2Output, result is 8
```

Contributing
------------

Contributions are welcome! Please fork the repository and use a branch for your feature or bug fix. Submitting a pull request is the best way to see your feature merged.


License
-------
This project is licensed under the MIT License - see the LICENSE file for details.