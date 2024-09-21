Flexisearch
-----------

Welcome to Flexisearch, a robust and adaptive Generation (RAG) based search framework utilizing Python. Flexisearch is designed to optimize your search functionalities and data retrieval processes through advanced Text-to-SQL conversion, multi-database integration, and benchmark-driven performance evaluation.

Features
--------

- **Advanced Text-to-SQL Conversion**
  - Integrated with the OpenAI API to enhance natural language processing tasks.
  - Facilitates seamless conversion from natural language queries to SQL, improving data query accessibility.

- **Multi-Database Integration**
  - Supports interaction across various database technologies including Relational Databases (RDB), Vector Databases (VectorDB), and Graph Databases (GraphDB).
  - Optimizes data retrieval by enabling advanced search functionalities across different database systems.

- **Benchmark-Driven Performance Evaluation**
  - Integrated with established benchmarks such as Archerfish, SPIDER, and BIRD for comprehensive performance evaluation.
  - Includes other benchmark code to ensure robust testing of search and Text2SQL capabilities.


Installation
------------

To begin using Flexisearch, clone the repository from GitHub:
```shell
git clone https://github.com/dzhsurf/flexisearch.git
cd flexisearch
```

Ensure you have Python installed and set up a virtual environment(conda recommand):
```shell
conda create -n proj python=3.11
```

Install the necessary dependencies:
```shell
pip install -e .
```


Usage
-----

Before using Flexisearch, you'll need to set up your `OPENAI_API_KEY`. You can set this environment variable in your system or include it in your code:

```shell
export OPENAI_API_KEY='your-api-key-here' 
```

Flexisearch can be easily integrated into your existing projects. Below is a basic setup to get you started:


```python
from flexisearch import ... 
# TODO: ...
```

Contributing
------------

Contributions are welcome! Please fork the repository and use a branch for your feature or bug fix. Submitting a pull request is the best way to see your feature merged.


License
-------
This project is licensed under the MIT License - see the LICENSE file for details.