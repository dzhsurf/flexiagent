from typing import Any, Dict, List, Union, Literal

# from pydantic import BaseModel
from langchain_core.pydantic_v1 import BaseModel, Field


class UnstructuredData(BaseModel):
    data: str


class StructuredInput(BaseModel):
    prompt_template_name: str = Field(description="Based on the user's query, infer the appropriate prompt template to use.")
