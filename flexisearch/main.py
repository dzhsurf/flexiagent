import logging
import os

# from flexisearch.agents.agent_context_qa import FxAgentContextQA
from flexisearch.agents.agent_intent_recognizer import FxAgentIntentRecognizer
from flexisearch.agents.agent_output_parser import FxAgentOutputParser
from flexisearch.agents.agent_text2sql_qa import FxAgentText2SqlQA
from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.searcher import FxSearcher

logging.basicConfig(level=logging.INFO)


def main():
    db_name = "real_estate_properties"
    db_path = os.path.abspath(
        f"../../../benchmark/spider/database/{db_name}/{db_name}.sqlite"
    )
    db_uri = f"sqlite:///{db_path}"

    indexer = FxIndexer()
    indexer.connect_to_metadb(DBConfig(name=db_name, db_uri=db_uri))
    indexer.add_knowledge("""Table real_estate_properties property_type_code must be one of this values:
"Apartment", "Field", "House", "Other", "Shop"
""")

    # repo_id = "TheBloke/Llama-2-7B-Chat-GGUF"
    # repo_filename = "*Q4_K_M.gguf"
    # llm_config = LLMConfig(
    #     engine="LlamaCpp",
    #     params={
    #         "repo_id_or_model_path": repo_id,
    #         "repo_filename": repo_filename,
    #         "n_ctx": 4096,
    #     },
    # )

    llm_config = LLMConfig(
        engine="OpenAI", params={"openai_model": "gpt-4o-mini"}
    )

    searcher = FxSearcher(llm_config, indexer)
    searcher.register(FxAgentOutputParser())
    searcher.register(FxAgentIntentRecognizer())
    searcher.register(FxAgentText2SqlQA())
    # searcher.register(FxAgentContextQA())

    print(
        "QA:",
        searcher.assist(
            "What are the names of properties that are either houses or apartments with more than 1 room?"
        ),
    )

    # db_name = "singer"
    # print(
    #     "QA:",
    #     searcher.assist("What is the names of every sing that does not have any song?"),
    # )


if __name__ == "__main__":
    main()
