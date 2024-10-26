import os
import google.generativeai as genai
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv, get_key
import yfinance as yf
from datetime import timedelta, datetime

#setup
load_dotenv()
app = Flask(__name__)
CORS(app, origins="http://localhost:5173")
genai.configure(api_key=os.environ.get("API_KEY"))
model_pf = genai.GenerativeModel('models/gemini-1.5-flash')

#chat made from model
chat = model_pf.start_chat(history=[
    {
        'role': "user",
        'parts': "Act as an Indian financial advisor, large language model. You will be given monthly expenses and you are supposed to suggest improvements in my expenses, so that i don't waste my money."
    },
    {
        'role': "model",
        'parts': "Understood"
    },
], enable_automatic_function_calling = True)

# chatbot for suggestions on portfolio
@app.route('/suggestion', methods = ['POST'])
def chat_with_bot_for_portfolio():
    user_message = request.json.get('expenses')
    print(user_message)
    if not user_message:
        return jsonify({"error": "No message provided."}), 400
    
    msg = ""
    i = 1
    for x in user_message:
        msg += str(i) + ". paid to: " + x["paid_to"] + " description: " + x["description"] + " amount: " + str(x["amount"]) + " payment method: " + x["payment_method"]
        i+=1

    print(msg)
    # Send user message to the chatbot and get the response
    response = chat.send_message(msg)
    # Return the chatbot's response as JSON
    return jsonify({"response": response.text})


if __name__ == "__main__":
    app.run(port=5003, debug=True)  