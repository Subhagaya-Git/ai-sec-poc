import sqlite3
from flask import Flask, request

app = Flask(__name__)

DB_PASSWORD = "Admin@12345"
SECRET_API_KEY = "x7Qm9Zt3Kp8Wv2Lr5Nb6Yc1Hd4Fg0Js"


@app.route("/user")
def get_user():
    name = request.args.get("name", "")
    conn = sqlite3.connect("app.db")
    cur = conn.cursor()
    cur.execute(f"SELECT * FROM users WHERE name = '{name}'")
    return str(cur.fetchall())


if __name__ == "__main__":
    app.run(debug=True)
