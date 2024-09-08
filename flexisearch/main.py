import logging
import os

from flexisearch.agents.agent_intent_recognizer import FxAgentIntentRecognizer
from flexisearch.agents.agent_output_parser import FxAgentOutputParser
from flexisearch.agents.agent_text2sql_qa import FxAgentText2SqlQA
from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.searcher import FxSearcher

logging.basicConfig(level=logging.INFO)


def main():
    db_path = os.path.abspath(
        "../../../benchmark/spider/database/concert_singer/concert_singer.sqlite"
    )
    db_uri = f"sqlite:///{db_path}"

    indexer = FxIndexer()
    indexer.connect_to_metadb(DBConfig(name="concert_singer", db_uri=db_uri))

    # repo_id = "TheBloke/Llama-2-7B-Chat-GGUF"
    # repo_filename = "*Q4_K_M.gguf"
    # llm_config = LLMConfig(
    #     engine="LlamaCpp",
    #     engine_config={
    #         "repo_id_or_model_path": repo_id,
    #         "repo_filename": repo_filename,
    #         "n_ctx": 4096,
    #     },
    # )

    llm_config = LLMConfig(engine="OpenAI", engine_config={"openai_model": "gpt-4o"})

    searcher = FxSearcher(llm_config, indexer)
    searcher.register(FxAgentOutputParser())
    searcher.register(FxAgentIntentRecognizer())
    searcher.register(FxAgentText2SqlQA())

    # print(
    #     "QA:",
    #     searcher.assist(
    #         "What are the locations and names of all stations with capacity between 5000 and 10000 ?"
    #     ),
    # )
    print(
        "QA:",
        searcher.assist(
            "Show the stadium name and capacity with most number of concerts in year 2014 or after."
        ),
    )


if __name__ == "__main__":
    main()
