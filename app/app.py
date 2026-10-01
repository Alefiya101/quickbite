import os

from flask import Flask, jsonify

app = Flask(__name__)

MENU = [
    {"id": 1, "name": "Classic Burger", "price": 10.5},
    {"id": 2, "name": "Veggie Wrap", "price": 8.75},
    {"id": 3, "name": "Chicken Caesar Salad", "price": 9.5},
    {"id": 4, "name": "Tomato Soup", "price": 6.25},
    {"id": 5, "name": "Grilled Cheese", "price": 7.0},
]


@app.get("/menu")
def get_menu():
    return jsonify(MENU)


@app.get("/health")
def get_health():
    return jsonify({"status": "ok"})


@app.get("/version")
def get_version():
    return jsonify({"version": os.getenv("APP_VERSION", "dev")})