def blocks(height):
    iterator = 0
    spaces = height - 1
    hashes = height - spaces
    while iterator < height:
        print(" "*spaces, end="")
        print("#"*hashes, end="")
        print("  ", end="")
        print("#"*hashes)
        iterator += 1
        spaces -= 1
        hashes += 1

def get_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Not an integer")

def main():
    while True:
        try:
            height = get_int("Height: ")
            if height > 0 and height < 9:
                blocks(height)
                break
        except ValueError:
                print("Invalid value")

main()
# That’s kind of confusing, so let’s try an example with David’s Visa: 4003600000000014.

# For the sake of discussion, let’s first underline every other digit, starting with the number’s second-to-last digit:

# 4003600000000014
#
# Okay, let’s multiply each of the underlined digits by 2:
#
# 1•2 + 0•2 + 0•2 + 0•2 + 0•2 + 6•2 + 0•2 + 4•2
#
# That gives us:
#
# 2 + 0 + 0 + 0 + 0 + 12 + 0 + 8
#
# Now let’s add those products’ digits (i.e., not the products themselves) together:
#
# 2 + 0 + 0 + 0 + 0 + 1 + 2 + 0 + 8 = 13
#
# Now let’s add that sum (13) to the sum of the digits that weren’t multiplied by 2 (starting from the end):
#
# 13 + 4 + 0 + 0 + 0 + 0 + 0 + 3 + 0 = 20
#
# Yup, the last digit in that sum (20) is a 0, so David’s card is legit!
#
# So, validating credit card numbers isn’t hard, but it does get a bit tedious by hand. Let’s write a program.
