from typing import List

from pydantic import BaseModel
from sqlalchemy import MetaData, create_engine, text


class DBConfig(BaseModel):
    name: str
    db_uri: str


class DBExecutor:
    # wrap db engine api
    def __init__(self, config: DBConfig):
        self.config = config
        self.engine = create_engine(config.db_uri)

    @property
    def dialect(self) -> str:
        return self.engine.dialect.name

    def get_schemas_as_text(self) -> str:
        metadata = MetaData()
        # Reflect the database schema
        metadata.reflect(bind=self.engine)

        # Iterate through tables and print their columns
        return self._pretty_print_schema(metadata)

    def query(self, sql_query: str) -> List[str]:
        query = text(sql_query)
        ans = []

        with self.engine.connect() as connection:
            result = connection.execute(query)
            # Iterate over the result and print each row
            for row in result:
                ans.append(str(row))

        return ans

    def _pretty_print_schema(self, metadata: MetaData) -> str:
        result = ""
        for table_name, table in metadata.tables.items():
            result += f"Table: {table_name}\n"
            result += f"{'Column Name':<30} {'Type':<30} {'Nullable':<15} {'Primary Key':<10}\n"
            result += "=" * 100 + "\n"

            for column in table.columns:
                result += f"{column.name:<30} {str(column.type):<30} {str(column.nullable):<15} {str(column.primary_key):<10}\n"

            result += "\n" + "-" * 100 + "\n"
        return result
