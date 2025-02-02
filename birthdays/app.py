import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")


def parse_to_int(value):
    try:
        # Attempt to convert the value to an integer
        result = int(value)
        return result
    except ValueError:
        # Handle the case where the value is not a valid integer
        print(f"Invalid input: '{value}' is not an integer.")
        return None\



@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        # TODO: Add the user's entry into the database
        # TODO: The hurricane is approaching and we have nowhere to hide.
        id = request.form.get("id")
        if id:
            db.execute("DELETE FROM birthdays WHERE id = ?", id)
            return redirect("/")
        name = request.form.get("name")
        if not name:
            return redirect("/")

        month = request.form.get("month")
        if not month:
            redirect("/")
        int_month = parse_to_int(month)
        print(int_month)
        if int_month < 1 or int_month > 12:
            print("Out-of-range month")
            return redirect("/")

        days_in_month = {1: 31, 2: 29, 3: 31, 4: 30, 5: 31,
                         6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31}
        day = request.form.get("day")
        if not day:
            return redirect("/")
        int_day = parse_to_int(day)
        print(int_day)
        if int_day < 1 or int_day > days_in_month[int_month]:
            return redirect("/")

        db.execute(
            "INSERT INTO birthdays (name, month, day) VALUES (?, ?, ?)", name, int_month, int_day)

        return redirect("/")

    else:

        # TODO: Display the entries in the database on index.html
        rows = db.execute("SELECT * FROM birthdays")
        # print(rows)
        return render_template("index.html", birthdays=rows)

    # id = request.form.get("id")
    # db.execute("DELETE FROM birthdays WHERE id = ?", id)
    # return redirect("/")
