from typing import List, Optional

from flexisearch.database.db_executor import DBConfig, DBExecutor


class FxIndexer:
    metadb: Optional[DBExecutor]

    def __init__(self):
        self.metadb = None

    def connect_to_metadb(self, db_config: DBConfig):
        if self.metadb:
            self.disconnect_metadb()
        self.metadb = DBExecutor(db_config)

    def disconnect_metadb(self):
        self.metadb = None

    def dialect(self) -> str:
        if self.metadb:
            return self.metadb.dialect
        return ""

    def get_all_schemas_as_text(self) -> str:
        result = ""

        if self.metadb:
            schemas = self.metadb.get_schemas_as_text()
            result += "DB: " + self.metadb.config.name + "\n" + schemas

        return result

    def retrieval_documents(self, query: str) -> List[str]:
        if self.metadb:
            return self.metadb.query(query)
        return []
