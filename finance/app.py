import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime


from helpers import (
    apology,
    login_required,
    lookup,
    usd,
    is_positive_integer,
    is_only_alphabet,
)

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")
current_date = datetime.now().strftime("%Y-%m-%d")
timestamp = datetime.now().strftime("%H:%M:%S")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    current_user = session.get("user_id")
    current_cash = db.execute("SELECT cash FROM users WHERE id = ?", current_user)
    fcurrent_cash = usd(current_cash[0]["cash"])
    # Get the share name, quantity, price and total of each transaction
    try:
        # current_table = db.execute(
        #     "SELECT r.share, r.price, u.quantity, (r.price * u.quantity) AS total FROM share_purchases u JOIN share_prices r ON u.share_id = r.id WHERE u.user_id = ? AND u.date = ?", current_user, current_date)
        db.execute("DELETE FROM share_totals")
        db.execute(
            "INSERT INTO share_totals (share, number, price, totals) SELECT r.share, SUM(u.quantity) AS number, r.price, SUM((r.price * u.quantity)) AS totals FROM share_purchases u JOIN share_prices r ON u.share_id = r.id WHERE u.user_id= ? AND u.date = ? GROUP BY r.share",
            current_user,
            current_date,
        )
        current_table = db.execute("SELECT * FROM share_totals")
        for row in current_table:
            row["price"] = usd(row["price"])
            row["totals"] = usd(row["totals"])
        grand_total = db.execute(
            "SELECT SUM((r.price * u.quantity)) AS grand_total FROM share_purchases u JOIN share_prices r ON u.share_id = r.id WHERE u.user_id= ? AND u.date = ?",
            current_user,
            current_date,
        )
        fgrand_total = usd(grand_total[0]["grand_total"])
        print(current_table, fcurrent_cash, fgrand_total)
        return render_template(
            "index.html",
            current_table=current_table,
            current_cash=fcurrent_cash,
            grand_total=fgrand_total,
        )
    except TypeError:
        return render_template("index.html", current_cash=fcurrent_cash)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        symbol = (request.form.get("symbol")).rstrip()
        try:
            num_shares = int(request.form.get("shares"))
        except ValueError:
            return apology("invalid input!", 400)
        if not symbol or not num_shares:
            return apology("fill in the fields!", 400)
        if not is_positive_integer(num_shares):
            return apology("invalid input!", 400)
        int_num_shares = int(num_shares)
        shares = lookup(symbol)
        current_user = session.get("user_id")
        if shares == None:
            return apology("share not found in stock!", 400)
        try:
            write_new_symbol = db.execute(
                "INSERT INTO share_prices (share, price) VALUES (?, ?)",
                shares["symbol"],
                shares["price"],
            )
        except ValueError:
            print(f"the stock record already exists")
        # Get share id and price per unit
        share_id_price = db.execute(
            "SELECT id, price FROM share_prices WHERE share = ?", shares["symbol"]
        )
        # Get transaction total
        purchase_total = int_num_shares * share_id_price[0]["price"]
        # Get user's current cash
        current_cash = db.execute("SELECT cash FROM users WHERE id = ?", current_user)
        # Validate transaction
        print(f"AQUÍ: {purchase_total}, {current_cash}")
        if purchase_total <= current_cash[0]["cash"]:
            # Insert transaction data
            db.execute(
                "INSERT INTO share_purchases (user_id, share_id, quantity, grand_total, date, type, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?)",
                current_user,
                share_id_price[0]["id"],
                num_shares,
                purchase_total,
                current_date,
                "purchase",
                timestamp,
            )
            # Update the user cash
            db.execute(
                "UPDATE users SET cash = (cash - ?) WHERE id = ?",
                purchase_total,
                current_user,
            )
            return redirect("/")
        else:
            return apology("insufficient funds!", 403)
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    # Get the current user
    current_user = session.get("user_id")
    # Get the share name, quantity, price and total of each transaction
    history_table = db.execute(
        "SELECT u.type, r.share, r.price, u.quantity, u.date, u.timestamp FROM share_purchases u JOIN share_prices r ON u.share_id = r.id WHERE u.user_id = ?",
        current_user,
    )
    for rows in history_table:
        rows["price"] = usd(rows["price"])
        rows["quantity"] = abs(rows["quantity"])
    print(history_table)
    return render_template("history.html", history_table=history_table)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""
    # Forget any user_id
    session.clear()
    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        if not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    if request.method == "GET":
        return render_template("quote.html")
    else:
        symbol = (request.form.get("symbol")).rstrip()
        if not symbol or not is_only_alphabet(symbol):
            return apology("must provide a valid symbol!", 400)
        stock = lookup(symbol.upper())
        if stock == None or not stock:
            return apology("must provide a valid symbol!", 400)
        stock["price"] = usd(stock["price"])
        # TODO Implement a search in the database
        try:
            write_new_symbol = db.execute(
                "INSERT INTO share_prices (share, price) VALUES (?, ?)",
                stock["symbol"],
                stock["price"],
            )
        except ValueError:
            print("the stock record already exists")
        return render_template(
            "quoted.html",
            name=stock["name"],
            price=stock["price"],
            symbol=stock["symbol"],
        )


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    # Clean any user_id
    session.clear()
    # Ensure username and password submitted
    if request.method == "POST":
        user = (request.form.get("username")).rstrip()
        password = (request.form.get("password")).rstrip()
        if not user or not password:
            return apology("must provide username and/or password", 400)
        password_confirmation = request.form.get("confirmation")
        if password != password_confirmation:
            return apology("passwords are not the same!", 400)
        # Query database for register a new user and validations
        hash_password = generate_password_hash(
            password, method="pbkdf2:sha256", salt_length=8
        )
        # Insert data
        try:
            db.execute(
                "INSERT INTO users(username, hash) VALUES (?, ?)", user, hash_password
            )
            return render_template("login.html")
        except ValueError:
            return apology("user already exists!", 400)
    else:
        return render_template("register.html")


@app.route("/profile", methods=["GET", "POST"])
@login_required
def profile():
    """Register user"""
    user_id = session.get("user_id")
    username = db.execute("SELECT username FROM users WHERE id = ?", user_id)
    # Ensure username and password submitted
    if request.method == "POST":
        if not user_id:
            return apology("something went wrong with the session!", 500)
        # user_id = db.execute("SELECT id FROM users WHERE username = ")
        old_password = request.form.get("old_password")
        # Query database for username
        current_hash = db.execute("SELECT hash FROM users WHERE id = ?", user_id)
        # Ensure username exists and password is correct
        if not check_password_hash(current_hash[0]["hash"], old_password):
            return apology("incorrect current password!", 403)
        new_password = request.form.get("new_password")
        new_password_confirmation = request.form.get("new_password_confirmation")
        if not old_password:
            return apology("must provide the old password!", 403)
        if new_password != new_password_confirmation:
            return apology("passwords are not the same!", 403)
        # Query database for change password
        new_hash_password = generate_password_hash(
            new_password, method="pbkdf2:sha256", salt_length=8
        )
        db.execute("UPDATE users SET hash = ? WHERE id = ?", new_hash_password, user_id)
        return redirect("/profile", user=username[0]["username"])
    else:
        return render_template("profile.html", user=username[0]["username"])


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    current_user = session.get("user_id")
    if request.method == "POST":
        # render_template("sell.html", user_symbols=user_symbols)
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")
        if not symbol or not shares:
            return apology("must provide a number of shares!", 400)
        try:
            int_shares = int(shares)
        except ValueError:
            return apology("must provide a valid number of shares!", 400)
        # if is_positive_integer(int_shares):
        negative_sell_num_shares = -1 * (int_shares)
        # Get id share and price
        sell_share_id_price = db.execute(
            "SELECT id, price FROM share_prices WHERE share = ?", symbol
        )
        # Available number of shares
        available_num_shares = db.execute(
            "SELECT SUM(quantity) AS availability FROM share_purchases WHERE user_id = ? AND share_id = ?",
            current_user,
            sell_share_id_price[0]["id"],
        )
        print(int_shares)
        if int_shares <= available_num_shares[0]["availability"]:
            # Get transaction total
            sell_total = -1 * (
                negative_sell_num_shares * sell_share_id_price[0]["price"]
            )
            # Insert transaction data
            db.execute(
                "INSERT INTO share_purchases (user_id, share_id, quantity, grand_total, date, type, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?)",
                current_user,
                sell_share_id_price[0]["id"],
                negative_sell_num_shares,
                sell_total,
                current_date,
                "sale",
                timestamp,
            )
            db.execute(
                "UPDATE users SET cash = (cash + ?) WHERE id = ?",
                sell_total,
                current_user,
            )
            return redirect("/")
        else:
            return apology("insufficient number of shares!", 400)
    # Show stock available for sale
    else:
        # Get the shares of the user
        try:
            user_symbols = db.execute(
                "SELECT share FROM share_prices AS r JOIN share_purchases AS u ON r.id = u.share_id WHERE u.user_id = ? GROUP BY r.share",
                current_user,
            )
            return render_template("sell.html", user_symbols=user_symbols)
        except ValueError:
            print("no records!")
            return redirect("/quote")
