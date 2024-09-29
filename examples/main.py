import asyncio

from gradio_chatbot.simple_chatbot import SimpleChatBot


async def main():
    cahtbot = SimpleChatBot()
    cahtbot.launch()


if __name__ == "__main__":
    asyncio.run(main())
