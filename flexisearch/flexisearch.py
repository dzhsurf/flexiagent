import json
from dataclasses import dataclass
from typing import (Annotated, Any, Dict, Generator, List, Literal, Optional,
                    Tuple, Union)

from pydantic import BaseModel


@dataclass
class SearchResult:
    text: str


class SearchField(BaseModel):
    name: str
    type: str
    indexed: bool = True
    stored: bool = True
    multi_valued: bool = False
    required: Optional[bool] = False


class SearchSchema(BaseModel):
    fields: List[SearchField]


"""
Example:
schema = SearchSchema(
    fields = [
        SearchField(name="id", type="string", indexed=True, stored=True, required=True),
        SearchField(name="title", type="string", indexed=True, stored=True),
        ...
    ]
)

Or:
from pydantic_core import from_json
schema_definition_json = '{"fields": [{"name": "id", "type": "string"}]}'
schema = SearchSchema.model_validate(
    from_json(schema_definition_json, allow_partial=False)
)

"""


@dataclass
class LLMConfig:
    llm_engine: Literal["OpenAI", "Llama"]


@dataclass
class DBConfig:
    pass


class DBExecutor:
    # wrap db engine api
    def __init__(self, config: DBConfig):
        self.config = config

    def define_schema(self, schema: SearchSchema):
        pass

    def query(self, sql_query: str) -> List[Any]:
        return []

    def execute(self, sql_execute: str):
        pass


@dataclass
class UnstructureData:
    data: str

    @staticmethod
    def from_text(text: str) -> "UnstructureData":
        return UnstructureData(data=text)


@dataclass
class StructureData:
    fields: Dict[str, Any]

    @staticmethod
    def from_json_str(json_str: str) -> "StructureData":
        return StructureData(fields=dict(json.loads(json_str)))


class LLMEngine:
    def __init__(self, llm_config: LLMConfig):
        self.llm_config = llm_config

    def get_config(self) -> LLMConfig:
        return self.llm_config

    def query(self, text: str) -> str:
        return ""

    def stream_query(self, text: str) -> Generator[str, None, None]:
        responses = [""]
        for response in responses:
            yield response


class IndexRules:
    def __init__(self) -> None:
        self.rule_schemas: List[SearchSchema] = []

    def connect_to_knowledge_db(self, knowledge_db_config: DBConfig):
        pass

    def store(self, filepath: str):
        pass

    def restore(self, filepath: str):
        pass

    def define_rule_from_schema(self, schema: SearchSchema):
        self.rule_schemas.append(schema)

    def define_rule_from_sql(self, sql_samples: List[str]):
        """
        Q: List the latest 3 month orders
        A: SELECT * FROM A WHERE D = ???;
        """
        pass

    def clear_rules(self):
        pass

    def get_all_schema_as_text(self) -> str:
        return ""

    def get_all_knowledge_as_text(self) -> str:
        return ""


class StructureQuery:
    def __init__(
        self,
        llm_config: LLMConfig,
        index_rules: IndexRules,
        structure_data: StructureData,
    ):
        self.llm_engine = LLMEngine(llm_config)
        self.index_rules = index_rules
        self.structure_data = structure_data

    def __check_sql__(self, sql: str) -> Tuple[bool, str]:
        return (False, "Error msg")

    def build_sql_query(self) -> str:
        def gen_sql(reflection_msg: Optional[str], retry: int = 5) -> str:
            schema = self.index_rules.get_all_schema_as_text()
            knowledge = self.index_rules.get_all_knowledge_as_text()

            prompt = f"other protmpt...{schema}...{knowledge}"
            if reflection_msg:
                prompt = f"{prompt} ... {reflection_msg}"

            response = self.llm_engine.query(prompt)
            ret, err = self.__check_sql__(response)
            if ret:
                return response
            elif retry > 0:
                return gen_sql(err, retry - 1)

            return ""

        return gen_sql(None)


def convert_unstructure_data_to_structure_data(
    llm_config: LLMConfig,
    index_rules: IndexRules,
    unstructure_data: UnstructureData,
) -> StructureData:
    # build structure data
    llm_engine = LLMEngine(llm_config)
    schema = index_rules.get_all_schema_as_text()
    knowledge = index_rules.get_all_knowledge_as_text()

    prompt = f"...{schema}...{knowledge} ... {unstructure_data}"
    response = llm_engine.query(prompt)

    structure_data = StructureData.from_json_str(str(response))
    return structure_data


class UserQuery:
    def __init__(self, text: str):
        self.text = text

    @staticmethod
    def from_str(text: str) -> "UserQuery":
        return UserQuery(text)

    def understand(
        self, llm_config: LLMConfig, index_rules: IndexRules
    ) -> StructureQuery:
        unstructure_data = UnstructureData.from_text(self.text)
        structure_data = convert_unstructure_data_to_structure_data(
            llm_config, index_rules, unstructure_data
        )
        return StructureQuery(llm_config, index_rules, structure_data)


class FxSearcher:
    def __init__(self, llm_config: LLMConfig, db_config: DBConfig):
        self.llm_engine = LLMEngine(llm_config)
        self.index_db = DBExecutor(db_config)

    def configure(self, index_rules: IndexRules):
        self.index_rules = index_rules

    def assist(self, query: UserQuery) -> SearchResult:
        structure_query = query.understand(
            self.llm_engine.get_config(), self.index_rules
        )
        sql_query = structure_query.build_sql_query()

        db_result = self.index_db.query(sql_query)
        db_result_text = self.__db_result_to_text__(db_result)
        prompt = f"prompt...{db_result_text}..."

        result = self.llm_engine.query(prompt)
        return SearchResult(text=result)

    def __db_result_to_text__(self, db_resulit: List[Any]) -> SearchResult:
        return SearchResult(text="")


class IndexBuilder:
    def __init__(
        self,
        llm_config: LLMConfig,
        index_db_config: DBConfig,
    ):
        self.llm_config = llm_config
        self.index_db = DBExecutor(index_db_config)

    def configure(self, index_rules: IndexRules):
        self.index_rules = index_rules

    def index_unstructure_data(self, unstructure_data: UnstructureData):
        # index unstructure data
        structure_data = convert_unstructure_data_to_structure_data(
            self.llm_config, self.index_rules, unstructure_data
        )
        query = StructureQuery(self.llm_config, self.index_rules, structure_data)
        sql_query = query.build_sql_query()
        self.index_db.execute(sql_query)


"""

### define schema, index rules, ...
schema = SearchSchema(
    fields=[
        SearchField(name="id", type="string", indexed=True, stored=True, required=True),
        SearchField(name="title", type="string", indexed=True, stored=True),
    ]
)

index_rules = IndexRules()
index_rules.define_rule_from_schema(schema)
index_rules.define_rule_from_sql(["..."])

# QA search
searcher = FlexiSearcher(
    llm_config=LLMConfig(...),
    index_db_config=DBConfig(),
)
searcher.configure(index_rules)
result = searcher.assist(UserQuery.from_str("list latest 3 month orders"))

# build index
index_builder = IndexBuilder(
    llm_config=LLMConfig(...),
    index_db_config=DBConfig(...),
)
index_builder.config(index_rules)
index_builder.index_unstructure_data(data)

"""
