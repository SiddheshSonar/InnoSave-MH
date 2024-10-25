import os
import google.generativeai as genai
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv, get_key
import yfinance as yf

load_dotenv()
app = Flask(__name__)

CORS(app, origins="http://localhost:5173")

genai.configure(api_key=os.environ.get("API_KEY"))
model = genai.GenerativeModel('models/gemini-1.5-flash')
chat = model.start_chat(
    history=[
        {"role": "user", "parts": "You are a financial chatbot. Please only answer questions related to finance. If you don't know the answer to a question, respond with 'I don't know.'"},
        {"role": "model", "parts": "Understood. I am a financial chatbot. How can I help you?"},
    ]
)

# fetches data from finance based on the ticker symbol
def get_hist_data(symbol):
    stock = yf.Ticker(symbol)
    hist = stock.history(period="1y")
    # Reset index to get the Date as a column
    hist.reset_index(inplace=True)
    # Convert Date to string format to ensure JSON serializable
    hist['Date'] = hist['Date'].dt.strftime('%Y-%m-%d')
    return hist.to_json(orient='records')

# sends the data historical data
@app.route('/get_historical_data', methods=['GET'])
def get_historical_data():
    symbol = request.args.get('symbol')
    if symbol is None:
        return jsonify({"error": "Symbol parameter is missing"}), 400
    try:
        historical_data = get_hist_data(symbol)
        return historical_data
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# general chatbot used for chatting with the bot
@app.route('/chat', methods=['POST'])
def chat_with_bot():
    user_message = request.json.get('message')
    
    if not user_message:
        return jsonify({"error": "No message provided."}), 400

    # Send user message to the chatbot and get the response
    response = chat.send_message(user_message)

    # Return the chatbot's response as JSON
    return jsonify({"response": response.text})

# chatbot for taxation
@app.route('/chat-tax', methods = ['POST'])
def chat_with_bot_for_taxation():
    pass



if __name__ == '__main__':
    app.run(debug=True)