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

#helper functions
def get_stock_price(ticker: str) -> float:
    """Fetches the current stock price of a company in USD using its ticker symbol.

    Args:
      ticker: The ticker symbol of the company (e.g., 'AAPL' for Apple).

    Returns: 
      The current stock price of the company in USD.
    """
    
    stock = yf.Ticker(ticker)
    current_price = stock.history(period="1d")['Close'].iloc[0]
    
    return current_price

def convert_currency(amount: float, from_currency: str, to_currency: str) -> float:
    """Converts a specified amount from one currency to another using Yahoo Finance.

    Args:
      amount: The amount of money to be converted.
      from_currency: The currency code from which to convert (e.g., 'USD' for US Dollar).
      to_currency: The currency code to which to convert (e.g., 'EUR' for Euro).

    Returns:
      The equivalent amount in the target currency.
    """
    
    pair = f"{from_currency}{to_currency}=X"  # Yahoo Finance format for currency pairs (e.g., 'USDEUR=X')
    exchange_rate = yf.Ticker(pair).history(period="1d")['Close'].iloc[0]
    converted_amount = amount * exchange_rate
    
    return converted_amount

def get_stock_price_history(ticker: str) -> dict:
    """Fetches the yearly stock prices of a company in the currency of the country where they are listed for the past 10 years or from the year it was first listed, whichever is closer.

    Args:
      ticker: The ticker symbol of the company (e.g., 'AAPL' for Apple).

    Returns:
      A dictionary containing:
        - 'name': The company's name.
        - 'history': A list of dictionaries with:
            - 'year': The year the price was recorded (start of the year).
            - 'price': The stock's price at the start of that year.
    """
    
    stock = yf.Ticker(ticker)
    company_name = stock.info.get('shortName', ticker)
    
    # Define date range for the past 10 years
    end_date = datetime.now()
    start_date = end_date - timedelta(days=10*365)
    
    # Fetch monthly data within the date range
    stock_data = stock.history(start=start_date, end=end_date, interval="1mo")
    
    # Filter data to get the first trading day of each year
    history = []
    years_seen = set()
    for date, row in stock_data.iterrows():
        if date.year not in years_seen:
            history.append({
                "year": date.year,
                "price": int(row['Close'])
            })
            years_seen.add(date.year)
    
    return {
        "name": company_name,
        "history": history
    }

#chat made from model
chat = model_pf.start_chat(history=[
    {
        'role': "user",
        'parts': "Act as an investment advisor, large language model. Ask for the user's risk tolerance, age, and financial goals, all other important things necessary and based on the inputs, generate a portfolio suggestion, detailing the asset allocation (stocks, bonds, etc.) with an explanation of the risk levels and potential returns. Consider factors such as market trends, long-term growth, and inflation use the given default apis to its full potential for making suggestions."
    },
    {
        'role': "model",
        'parts': "Understood"
    },
], enable_automatic_function_calling = True)

# chatbot for suggestions on portfolio
@app.route('/chat-portfolio', methods = ['POST'])
def chat_with_bot_for_portfolio():
    user_message = request.json.get('message')
    if not user_message:
        return jsonify({"error": "No message provided."}), 400

    # Send user message to the chatbot and get the response
    response = chat.send_message(user_message, tools = [get_stock_price_history, get_stock_price])
    # Return the chatbot's response as JSON
    return jsonify({"response": response.text})


if __name__ == "__main__":
    app.run(port=5002, debug=True)  