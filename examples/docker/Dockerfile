FROM python:3.11.10-bookworm

WORKDIR /app
SHELL ["/bin/bash", "-c"] 

COPY ../requirements.txt ./

RUN pip install -r requirements.txt 

COPY ../main.py .
COPY ../gradio_chatbot ./gradio_chatbot

ENTRYPOINT ["python", "main.py"]