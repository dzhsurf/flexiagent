import argparse
import asyncio
import logging
from typing import Callable, Dict

from gradio_chatbot.simple_chatbot import SimpleChatBot
from gradio_chatbot.text2sql_qa_chatbot import Text2SqlQAChatBot

logger = logging.getLogger(__name__)

logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("flexiagent").setLevel(logging.WARNING)
logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(funcName)s - %(message)s",
    level=logging.INFO,
)


async def gradio_simple_chatbot():
    chatbot = SimpleChatBot()
    await chatbot.launch()


async def text2sql_qa_chatbot():
    chatbot = Text2SqlQAChatBot()
    await chatbot.launch()


async def main():
    parser = argparse.ArgumentParser(description="Examples launcher.")
    parser.add_argument("name", help="Example name")
    args = parser.parse_args()

    name: str = args.name
    all_examples: Dict[str, Callable] = {
        "gradio-simple-chatbot": gradio_simple_chatbot,
        "gradio-text2sql-qa-chatbot": text2sql_qa_chatbot,
    }
    if name in all_examples:
        await all_examples[name]()
    else:
        logger.info("Example not found. name:", name)


if __name__ == "__main__":
    asyncio.run(main())
