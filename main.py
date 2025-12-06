import os
from flask import Flask, request, render_template, jsonify, Response, stream_with_context
from ollama import chat

app = Flask(__name__)

# Personalization variables
person_name = os.getenv('PERSON_NAME', 'the person')
person_role = os.getenv('PERSON_ROLE', 'professional')
person_location = os.getenv('PERSON_LOCATION', 'somewhere')

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/chat", methods=["POST"])
def chat_trigger():
    request_data = request.get_json(force=True)
    question = request_data.get("question")
    with open("data/personal_info.txt") as f:
        context = f.read()
    # Save the question/context for later use
    with open("tmp_question.txt", "w") as f:
        f.write(question)
    with open("tmp_context.txt", "w") as f:
        f.write(context)
    return jsonify({"status": "ok"})

@app.route("/chat-stream")
def chat_stream():
    with open("tmp_question.txt") as f:
        question = f.read()
    with open("tmp_context.txt") as f:
        context = f.read()

    prompt = (
        f"You are a helpful assistant designed to answer questions about {person_name}, a {person_role} based in {person_location}. "
        f"Answer questions strictly using the provided context about {person_name}. "
        "Do not use any outside knowledge or make assumptions. "
        f"If the answer is not found in the context, or the question is not about {person_name}, reply with: 'Sorry, I don’t have that information.'\n\n"
        "Answer all questions in English.\n\n"
        f"If people ask more information about them, share any other aspect of {person_name}."
        f"---\n{context}\n---\n\n"
        f"Question: {question}\nAnswer:"
    )

    def generate():
        stream = chat(
            model="personal-assistant:1.0",
            messages=[{"role": "user", "content": prompt}],
            stream=True,
        )
        for chunk in stream:
            content = chunk['message']['content']
            # SSE format: data: <content>\n\n
            yield f"data: {content}\n\n"

    return Response(stream_with_context(generate()), content_type='text/event-stream')

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8080)
