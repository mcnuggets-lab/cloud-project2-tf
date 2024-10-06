import serverless_wsgi
from flask import Flask, jsonify, request
from flask import render_template
from transformers import pipeline

app = Flask(__name__)

qa_pipeline = pipeline(
    "question-answering",
    model="model/",
    tokenizer="model/"
)

@app.route("/")
def index_page():
    """Render the form for QA model."""
    return render_template("index.html")


@app.route("/answer", methods=["POST"])
def predict():
    """Predict from input of the form."""
    prediction = qa_pipeline({
        "context": request.form.get("context", "") or "I'm Kit-Ho Mak. I come from Hong Kong.",
        "question": request.form.get("question", "") or "What is my name?",
    })
    return jsonify(prediction)


def handler(event, context):
    return serverless_wsgi.handle_request(app, event, context)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
