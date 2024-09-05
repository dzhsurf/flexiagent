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

    """
SQLQuery: SELECT "Location", "Name" FROM stadium WHERE "Capacity" BETWEEN 5000 AND 10000 LIMIT 5;
Retrieval: []
QA: There are no records found for stations with a capacity between 5000 and 10000.

SQLQuery: SELECT "s"."Name", "s"."Capacity", COUNT("c"."concert_ID") AS "Concert_Count" FROM "stadium" AS "s" JOIN "concert" AS "c" ON "s"."Stadium_ID" = "c"."Stadium_ID" WHERE "c"."Year" >= '2014' GROUP BY "s"."Stadium_ID" ORDER BY "Concert_Count" DESC LIMIT 5;
Retrieval: ["('Somerset Park', 11998, 2)", "('Glebe Park', 3960, 1)", "('Balmoor', 4000, 1)", "('Recreation Park', 3100, 1)", '("Stark\'s Park", 10104, 1)']
QA: The stadium with the most number of concerts in the year 2014 or after is Somerset Park, with a capacity of 11,998.
    """


if __name__ == "__main__":
    main()
