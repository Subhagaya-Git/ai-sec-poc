import os
import sqlite3
from flask import Flask, request

app = Flask(__name__)

DB_PASSWORD = os.environ.get("DB_PASSWORD")
SECRET_API_KEY = os.environ.get("SECRET_API_KEY")


@app.route("/user")
def get_user():
    name = request.args.get("name", "")
    conn = sqlite3.connect("app.db")
    cur = conn.cursor()
    cur.execute("SELECT * FROM users WHERE name = ?", (name,))
    return str(cur.fetchall())


if __name__ == "__main__":
    app.run(debug=False)
