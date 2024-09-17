import json
import os
from typing import List
from pydantic import BaseModel
from .utils import DatasetItem


class BirdDatasetItem(BaseModel):
    question_id: int
    question: str
    SQL: str
    db_id: str


class BirdDatasetProvider:
    def __init__(self) -> None:
        self.dataset_items: List[DatasetItem] = []

    def setup(self, dataset_path: str):
        dataset_path = os.path.abspath(dataset_path)
        dataset_json = dataset_path + "/dev.json"

        def build_db_uri(db_id: str) -> str:
            return f"sqlite:///{dataset_path}/dev_databases/{bird_item.db_id}/{bird_item.db_id}.sqlite"

        # read dataset from json
        dataset_items: List[DatasetItem] = []
        with open(dataset_json, "r", encoding="utf-8") as fin:
            json_text = fin.read()
            json_data = json.loads(json_text)
            # total = len(json_data)
            for json_item in json_data:
                bird_item = BirdDatasetItem(**json_item)
                item = DatasetItem(
                    question_id=f"{bird_item.question_id}",
                    question=bird_item.question,
                    sql=bird_item.SQL,
                    db_id=bird_item.db_id,
                    db_uri=build_db_uri(bird_item.db_id),
                )
                dataset_items.append(item)
        self.dataset_items = dataset_items

    def get_all_dataset_items(self) -> List[DatasetItem]:
        return self.dataset_items.copy()
