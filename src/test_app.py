import json

import pytest
from app import app
from bs4 import BeautifulSoup


def test_index_page():
    response = app.test_client().get("/")

    assert response.status_code == 200

    soup = BeautifulSoup(response.data.decode("utf-8"), features="html.parser")

    assert soup.title.string == "A simple QA model"


@pytest.mark.parametrize(
    "context, question, answer",
    [
        ("", "", "Kit-Ho Mak"),
        ("I'm Kit-Ho Mak. I come from Hong Kong.", "What is my name?", "Kit-Ho Mak"),
        ("My pen is blue. My friend is you.", "What color is my pen?", "blue"),
    ],
)
def test_predict(question, context, answer):
    response = app.test_client().post(
        "/answer",
        data={
            "context": context,
            "question": question,
        },
        follow_redirects=True,
    )

    assert response.status_code == 200

    data = json.loads(response.data.decode("utf-8"))
    print(data)

    assert all(key in data for key in ["answer", "score", "start", "end"])
    assert data["answer"] == answer
