from typing import Any, AsyncGenerator, Dict, List, Tuple

import gradio as gr
from gradio_chatbot.utils import HookObjectAsyncMethod


class GradioChatbot:
    def __init__(self):
        pass

    async def launch(self, port: int = 3000):
        # replace undo, retry btn event
        with HookObjectAsyncMethod(
            gr.ChatInterface,
            "_delete_prev_fn",
            postprocess_hook=self.on_postprocess_delete_message,
        ):
            with gr.ChatInterface(
                fn=self.on_process_submit,
                type="messages",
                show_progress="full",
                multimodal=False,
            ) as inst:
                # replace clear btn click event
                inst.clear_btn.click(
                    self._on_clear_btn_click,
                    None,
                    [inst.chatbot, inst.saved_input],
                    queue=False,
                    show_api=False,
                ).then(
                    self.on_postprocess_clear_message,
                    None,
                    None,
                    show_api=False,
                    queue=False,
                )
                # launch webui
                inst.launch(server_name="0.0.0.0", server_port=port)

    async def on_process_submit(
        self, message: str, history: List[Dict[str, Any]]
    ) -> AsyncGenerator[str, None]:
        yield message

    async def on_postprocess_delete_message(
        self, history: List[Dict[str, Any]], message: str
    ) -> Tuple[List[Dict[str, Any]], str]:
        return (history, message)

    async def on_postprocess_clear_message(self):
        return

    async def _on_clear_btn_click(self):
        return ([], [], None)
