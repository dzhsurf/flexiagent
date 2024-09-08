import os

from flexisearch.agents.agent_intent_recognizer import FxAgentIntentRecognizer
from flexisearch.agents.agent_output_parser import FxAgentOutputParser
from flexisearch.agents.agent_text2sql_qa import FxAgentText2SqlQA
from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.searcher import FxSearcher


def main():
    db_path = os.path.abspath(
        "../../../benchmark/spider/database/concert_singer/concert_singer.sqlite"
    )
    db_uri = f"sqlite:///{db_path}"

    indexer = FxIndexer()
    indexer.connect_to_metadb(DBConfig(name="concert_singer", db_uri=db_uri))

    huggingface_cache_path = os.path.abspath("/Users/hiramdeng/.cache/huggingface/hub/")
    llm_config = LLMConfig(
        engine="LlamaCpp",
        engine_config={
            "path_or_name": f"{huggingface_cache_path}/models--TheBloke--Llama-2-7B-Chat-GGUF/snapshots/191239b3e26b2882fb562ffccdd1cf0f65402adb/llama-2-7b-chat.Q4_K_M.gguf",
            "n_ctx": 4096,
        },
    )

    # llm_config = LLMConfig(
    #     engine="OpenAI", engine_config={"openai_model": "gpt-4o-mini"}
    # )

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
