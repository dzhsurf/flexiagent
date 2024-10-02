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

    def pretty_print_query(self, sql_query: str) -> str:
        query = text(sql_query)
        output: List[str] = []
        with self.engine.connect() as connection:
            result = connection.execute(query)
            columns = result.keys()
            rows = result.fetchall()

            console_width = 80
            column_widths = [len(column) for column in columns]
            for row in rows:
                for i, value in enumerate(row):
                    column_widths[i] = max(column_widths[i], len(str(value)))

            total_width = sum(column_widths) + (len(columns) - 1) * 3
            if total_width > console_width:
                scale_factor = console_width / total_width
                column_widths = [max(1, int(w * scale_factor)) for w in column_widths]

            header = " | ".join(
                f"{column: <{w}}" for column, w in zip(columns, column_widths)
            )
            output.append(header)
            output.append("-" * len(header))

            for row in rows:
                formatted_row = " | ".join(
                    f"{str(value): <{w}}" for value, w in zip(row, column_widths)
                )
                output.append(formatted_row)

            if len(rows) == 0:
                output.append("No record found.")

        return "\n".join(output)

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
