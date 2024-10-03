import logging
from typing import Any, Dict, List, Literal, Optional, Tuple

from gradio_chatbot import AgentChatBot
from gradio_chatbot.utils import get_llm_config
from pydantic import BaseModel
from sqlalchemy import Column, ForeignKey, Integer, MetaData, String, create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from flexiagent.agents.agent_db_recognition import DatabaseMetaInfo
from flexiagent.agents.agent_text2sql_qa import create_text2sql_qa_agent
from flexiagent.database.db_executor import DBConfig, DBExecutor
from flexiagent.task.task_node import (
    FxTaskAction,
    FxTaskActionConditionResult,
    FxTaskActionLLM,
    FxTaskAgent,
    FxTaskConfig,
    FxTaskEntity,
)

logger = logging.getLogger(__name__)


# create db


class Base(DeclarativeBase):
    metadata = MetaData()


class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True)
    student_name = Column(String)
    student_class = Column(String)
    student_note = Column(String)


class Subject(Base):
    __tablename__ = "subject"

    subject_id = Column(Integer, primary_key=True)
    subject_name = Column(String)


class StudentScore(Base):
    __tablename__ = "student_scores"

    student_id = Column(Integer, ForeignKey("students.student_id"), primary_key=True)
    subject_id = Column(Integer, ForeignKey("subject.subject_id"), primary_key=True)
    score = Column(Integer)


engine = create_engine("sqlite:///school.db")
Base.metadata.create_all(engine)


def init_db():
    Session = sessionmaker(bind=engine)
    session = Session()

    students = session.query(Student).all()
    if len(students) == 0:
        # add initialize data
        student_1 = Student(
            student_id=10001,
            student_name="Alex Zhao",
            student_class="Class_101",
            student_note="Lazy boy",
        )
        student_2 = Student(
            student_id=10002,
            student_name="Bobo Cheung",
            student_class="Class_101",
            student_note="Study hard",
        )
        student_3 = Student(
            student_id=10003,
            student_name="Grace Fu",
            student_class="Class_102",
            student_note="Super Rich",
        )
        session.add_all([student_1, student_2, student_3])

        subject_1 = Subject(subject_id=1, subject_name="Sport")
        subject_2 = Subject(subject_id=2, subject_name="Math")
        subject_3 = Subject(subject_id=3, subject_name="Language")
        session.add_all([subject_1, subject_2, subject_3])

        session.add_all(
            [
                StudentScore(student_id=10001, subject_id=1, score=5),
                StudentScore(student_id=10001, subject_id=2, score=7),
                StudentScore(student_id=10001, subject_id=3, score=12),
                StudentScore(student_id=10002, subject_id=1, score=99),
                StudentScore(student_id=10002, subject_id=2, score=87),
                StudentScore(student_id=10002, subject_id=3, score=80),
                StudentScore(student_id=10003, subject_id=1, score=100),
                StudentScore(student_id=10003, subject_id=2, score=82),
                StudentScore(student_id=10003, subject_id=3, score=57),
            ]
        )

        session.commit()
    session.close()


class ChatBotInput(FxTaskEntity):
    input: str
    history_as_text: str


class ChatBotResponse(FxTaskEntity):
    response: str


class ChatMessage(BaseModel):
    role: str
    metadata: Dict[str, Any]
    content: str


class UserIntent(FxTaskEntity):
    intent: Literal["QA", "Other"]


def _fetch_database_metainfo(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> DatabaseMetaInfo:
    db_id = "school"
    db_uri = "sqlite:///school.db"
    db = DBExecutor(DBConfig(name=db_id, db_uri=db_uri))
    return DatabaseMetaInfo(
        db_id=db_id,
        db_uri=db_uri,
        db_metainfo=db.get_schemas_as_text(),
    )


def _convert_chatbot_input_to_text2sql_qa_input(
    input: Dict[str, Any],
) -> Tuple[Dict[str, Any], bool]:
    if not isinstance(input["input"], ChatBotInput):
        raise TypeError(f"Input not match, {input}")

    user_question_with_history = ""
    chatbot_input: ChatBotInput = input["input"]
    user_question_with_history = chatbot_input.history_as_text + "\n"
    user_question_with_history += "Question: " + chatbot_input.input + "\n"

    input["input"] = user_question_with_history
    return input, False


def _condition_text2sql_qa(input: Dict[str, Any]) -> FxTaskActionConditionResult:
    if not isinstance(input["user_intent"], UserIntent):
        raise TypeError(f"Input not match, {input}")

    user_intent: UserIntent = input["user_intent"]
    skip_action = user_intent.intent != "QA"

    return FxTaskActionConditionResult(
        skip_action=skip_action,
        action_ret_value="",
    )


def _condition_fallback_action(input: Dict[str, Any]) -> FxTaskActionConditionResult:
    if not isinstance(input["user_intent"], UserIntent):
        raise TypeError(f"Input not match, {input}")

    user_intent: UserIntent = input["user_intent"]
    skip_action = user_intent.intent != "Other"

    return FxTaskActionConditionResult(
        skip_action=skip_action,
        action_ret_value="",
    )


def _generate_output(
    input: Dict[str, Any], addition: Dict[str, Any]
) -> ChatBotResponse:
    if not isinstance(input["user_intent"], UserIntent):
        raise TypeError(f"Input not match, {input}")

    user_intent = input["user_intent"]
    final_result = ""
    if user_intent.intent == "QA":
        final_result = input["text2sql_qa"]
    elif user_intent.intent == "Other":
        final_result = input["fallback_action"]
    else:
        raise ValueError(f"Unknow user intention, {user_intent}")

    return ChatBotResponse(
        response=str(final_result),
    )


class Text2SqlQAChatBot(AgentChatBot[ChatBotInput, ChatBotResponse]):
    def __init__(self):
        super().__init__(examples=[
            "Hi",
            "Show me all the students info",
            "Who are the hardest student",
        ])
        self.session_history_max_limit = 30
        init_db()

    @classmethod
    def create_agent(cls) -> FxTaskAgent:
        llm_config = get_llm_config()

        chatbot_agent = FxTaskAgent(
            task_graph=[
                # step 1: analyze user intent
                FxTaskConfig(
                    task_key="user_intent",
                    input_schema={"input": ChatBotInput},
                    output_schema=UserIntent,
                    action=FxTaskAction(
                        type="llm",
                        act=FxTaskActionLLM(
                            llm_config=llm_config,
                            instruction="""Based on the user's question, analyze the user's intent. The classification is as follows:
- QA: If the question is about student information, grades, class information, etc. Use this category.
- Other: Otherwise, it falls under this category.

{input.history_as_text}

Question: {input.input}
""",
                        ),
                    ),
                ),
                # step 2.1: text2sql qa action
                FxTaskConfig(
                    task_key="text2sql_qa",
                    input_schema={
                        "input": ChatBotInput,
                        "user_intent": UserIntent,
                    },
                    output_schema=str,
                    action=FxTaskAction(
                        type="agent",
                        act=create_text2sql_qa_agent(
                            llm_config,
                            _fetch_database_metainfo,
                            preprocess_hook=_convert_chatbot_input_to_text2sql_qa_input,
                        ),
                        condition=_condition_text2sql_qa,
                    ),
                ),
                # step 2.2: fallback action
                FxTaskConfig(
                    task_key="fallback_action",
                    input_schema={
                        "input": ChatBotInput,
                        "user_intent": UserIntent,
                    },
                    output_schema=str,
                    action=FxTaskAction(
                        type="llm",
                        act=FxTaskActionLLM(
                            llm_config=llm_config,
                            instruction="""You are a chatbot assistant. Assist user and response user's question.

{input.history_as_text}

Question: {input.input}
""",
                        ),
                        condition=_condition_fallback_action,
                    ),
                ),
                # step 3:
                FxTaskConfig(
                    task_key="output",
                    input_schema={
                        "user_intent": UserIntent,
                        "text2sql_qa": str,
                        "fallback_action": str,
                    },
                    output_schema=ChatBotResponse,
                    action=FxTaskAction(
                        type="function",
                        act=_generate_output,
                    ),
                ),
            ]
        )

        return chatbot_agent

    def create_agent_input(
        self, message: str, history: List[Dict[str, Any]]
    ) -> ChatBotInput:
        # change histroy to chatmessage list
        session_message = [ChatMessage.model_validate(msg) for msg in history]
        session_message = session_message[-self.session_history_max_limit :]

        # generate history as text
        history_as_text = "History conversation:\n"
        for msg in session_message:
            history_as_text += f"{msg.role}: {msg.content}\n"
        if len(history) == 0:
            history_as_text += "No history conversation."

        return ChatBotInput(
            input=message,
            history_as_text=history_as_text,
        )

    def process_agent_output(self, response: Optional[ChatBotResponse]) -> str:
        if response:
            return response.response
        return "[Agent without any output]"
