from cs50 import get_string
import re

# Adds all digits of a string
def sum_digits(s):
    sum_of_digits = 0
    for char in s:
        if char.isdigit():
            sum_of_digits += int(char)
    return sum_of_digits

# Create a new number from the index list
def new_num(indices_to_print, number, mult):
    newNum = []
    for i, digits in enumerate(number):
        if i in indices_to_print:
            newNum.append(int(digits)*mult)
    joined_string = "".join(str(num) for num in newNum)
    return joined_string

#
def format_number_string(number, width):
    # Convert the number to a string
    number_str = str(number)

    # Use zfill to pad with zeros
    return number_str.zfill(width)

# Validates the first digits of the card number and the length of the string
def valid_card(number):
    bank = str()
    if re.findall(r"^37.*|^34.*", number) and len(number) == 15:
        bank = "AMEX"
    elif re.findall(r"^4.*", number) and (len(number) >= 13) and (len(number) <= 16):
        bank = "VISA"
    elif re.findall(r"^51.*|^55.*", number):
        bank = "MASTERCARD"
    else:
        bank = "INVALID"
    return bank


def main():
    # while True:
    number = get_string("Number: ")
    bank = valid_card(number)
    if (bank == "AMEX" or bank == "MASTERCARD" or bank == "VISA"):
        number = format_number_string(number, 16)
        indices_to_print = [0, 2, 4, 6, 8, 10, 12, 14]
        joined_string = new_num(indices_to_print, number, 2)
        suma = sum_digits(joined_string)
        new_indices_to_print = [1, 3, 5, 7, 9, 11, 13, 15]
        new_joined_string = new_num(new_indices_to_print, number, 1)
        suma += sum_digits(new_joined_string)
        if (suma % 10 == 0):
            print(f"{bank}")
        else:
            print("INVALID")
    if (bank == "INVALID"):
        print("INVALID")

main()
