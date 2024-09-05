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
        result = ""

        metadata = MetaData()
        # Reflect the database schema
        metadata.reflect(bind=self.engine)
        # Iterate through tables and print their columns
        for table_name in metadata.tables:
            result += "Table: " + table_name + "\n"
            table = metadata.tables[table_name]
            for column in table.columns:
                result += (
                    "\tColumn: " + column.name + ", Type: " + str(column.type) + "\n"
                )
            result += "\n"

        return result

    def query(self, sql_query: str) -> List[str]:
        query = text(sql_query)
        ans = []

        with self.engine.connect() as connection:
            result = connection.execute(query)
            # Iterate over the result and print each row
            for row in result:
                ans.append(str(row))

        return ans
