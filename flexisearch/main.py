import os

from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.searcher import FxSearcher


def main():
    db_path = os.path.abspath("../database/concert_singer/concert_singer.sqlite")
    db_uri = f"sqlite:///{db_path}"

    indexer = FxIndexer()
    indexer.connect_to_metadb(DBConfig(name="concert_singer", db_uri=db_uri))

    searcher = FxSearcher(indexer)
    print(
        "QA:",
        searcher.assist(
            "What are the locations and names of all stations with capacity between 5000 and 10000 ?"
        ),
    )
    print(
        "QA:",
        searcher.assist(
            "Show the stadium name and capacity with most number of concerts in year 2014 or after."
        ),
    )


if __name__ == "__main__":
    main()
