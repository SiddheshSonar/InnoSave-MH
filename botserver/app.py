import os
import google.generativeai as genai
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv, get_key
import yfinance as yf

load_dotenv()
app = Flask(__name__)

CORS(app)

genai.configure(api_key=os.environ.get("API_KEY"))
model = genai.GenerativeModel('models/gemini-1.5-flash')

def get_hist_data(symbol):
    stock = yf.Ticker(symbol)
    hist = stock.history(period="1y")
    # Reset index to get the Date as a column
    hist.reset_index(inplace=True)
    # Convert Date to string format to ensure JSON serializable
    hist['Date'] = hist['Date'].dt.strftime('%Y-%m-%d')
    return hist.to_json(orient='records')

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
    
if __name__ == '__main__':
    
    app.run(debug=True)