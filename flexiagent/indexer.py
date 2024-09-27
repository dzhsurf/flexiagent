from typing import Dict, List

from flexiagent.database.db_executor import DBConfig, DBExecutor


class FxIndexer:
    def __init__(self):
        self.knowledges: List[str] = []
        self.metadbs: Dict[str, DBExecutor] = {}

    def add_metadb(self, db_config: DBConfig):
        self.metadbs[db_config.name] = DBExecutor(db_config)

    def remove_metadb(self, db_name: str):
        if db_name in self.metadbs:
            del self.metadbs[db_name]

    def dialect(self) -> str:
        # if self.metadb:
        #     return self.metadb.dialect
        return ""

    def get_all_dbnames(self) -> List[str]:
        return [key for key, _ in self.metadbs.items()]

    def get_db_uri(self, db_name: str) -> str:
        return self.metadbs[db_name].config.db_uri

    def get_db_schema(self, db_name: str) -> str:
        return self.metadbs[db_name].get_schemas_as_text()

    def get_all_schemas_as_text(self) -> str:
        result = ""

        for db_name, db in self.metadbs.items():
            schemas = db.get_schemas_as_text()
            result += "DB: " + db_name + "\n" + schemas + "\n\n"

        return result

    def retrieve_documents(self, db_name: str, query: str) -> List[str]:
        if db_name in self.metadbs:
            return self.metadbs[db_name].query(query)
        return []

    def add_knowledge(self, content: str):
        self.knowledges.append(content)

    def clear_knowledge(self):
        self.knowledges.clear()

    def get_all_knowledges_as_text(self) -> str:
        return "\n".join(self.knowledges)
