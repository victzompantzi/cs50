import csv
import sys
import os
import re


def main():
    # * Check for command-line usage
    if len(sys.argv) != 3:
        print("Usage: dna <path/to/database.csv> <path/to/sequence.txt>")
        sys.exit(1)
    # * Assign arguments to variables
    database = sys.argv[1]
    sequence = sys.argv[2]

    # * Check paths
    if not os.path.exists(database):
        print("Path files does not exist!")
        sys.exit(2)
    if not os.path.exists(sequence):
        print("Path files does not exist")
        sys.exit(2)

    # * Read database file into a variable
    with open(database, newline="") as file:
        reader = csv.reader(file)
        data = [row[1:] for row in reader] # * Start to read CSV file from the 1st row
        names = extract_first_column(database)
    if data and data[0][0].isalpha(): # * Ensures that the header is removed
        data.pop(0)

    # * Read DNA sequence file into a variable
    with open(sequence, mode="r") as file:
        string = file.read()

    # * Find longest match of each STR in DNA sequence
    # * Check database for matching profiles
    subsequence = ['AGATC','TTTTTTCT','AATG','TCTAG','GATA','TATC','GAAA','TCTG']

    # ! Small DB
    if database == "databases/small.csv":
        AGATC    = max(max_consecutive_repetitions(string, subsequence[0]))
        AATG     = max(max_consecutive_repetitions(string, subsequence[2]))
        TATC     = max(max_consecutive_repetitions(string, subsequence[5]))
        strs = [str(AGATC), "0", str(AATG), "0", "0", str(TATC), "0", "0"]
        indexes_to_remove = [1,3,4,6,7]
        dataSmall = [element for i, element in enumerate(strs) if i not in indexes_to_remove] # * Format datasets
        try:
            index = data.index(dataSmall)
            print(names[index])
        except ValueError:
            print("No match")

    # ! Large DB
    elif database == "databases/large.csv":
        AGATC    = max(max_consecutive_repetitions(string, subsequence[0]))
        TTTTTTCT = max(max_consecutive_repetitions(string, subsequence[1]))
        AATG     = max(max_consecutive_repetitions(string, subsequence[2]))
        TCTAG    = max(max_consecutive_repetitions(string, subsequence[3]))
        GATA     = max(max_consecutive_repetitions(string, subsequence[4]))
        TATC     = max(max_consecutive_repetitions(string, subsequence[5]))
        GAAA     = max(max_consecutive_repetitions(string, subsequence[6]))
        TCTG     = max(max_consecutive_repetitions(string, subsequence[7]))
        strs = [str(AGATC), str(TTTTTTCT), str(AATG), str(TCTAG), str(GATA), str(TATC), str(GAAA), str(TCTG)]
        try:
            index = data.index(strs)
            print(names[index])
        except ValueError:
            print("No match")

def max_consecutive_repetitions(string, pattern):
    n = len(pattern)
    matches = re.compile(f'((?:{pattern})+)')
    # TODO: Analyce next:
    res = [len(occ) // n for occ in matches.findall(string)]
    if res:
        return res
    else:
        return '0'

def extract_first_column(file_path):
    first_column = []
    with open(file_path, 'r', newline='') as file:
        reader = csv.reader(file)
        next(reader)
        for row in reader:
            if row:  # Skip empty rows
                first_column.append(row[0])
    return first_column

if __name__ == "__main__":
    main()
