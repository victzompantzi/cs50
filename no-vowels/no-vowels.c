// Write a function to replace vowels with numbers
// Get practice with strings
// Get practice with command line
// Get practice with switch

#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

string replace(string input);

int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("One parameter please!\n");
        return 1;
    }
    string word = argv[1];
    string result = replace(word);
    printf("%s\n", result);
}

string replace(string input)
{
    string output = input;

    for (int i = 0; i < strlen(input); i++)
    {
        char c = tolower(input[i]);
        switch (c)
        {
            case 'a':
                output[i] = '6';
                break;
            case 'e':
                output[i] = '3';
                break;
            case 'i':
                output[i] = '1';
                break;
            case 'o':
                output[i] = '0';
                break;
            case 'u':
                output[i] = 'u';
                break;
        }
    }
    return output;
}
