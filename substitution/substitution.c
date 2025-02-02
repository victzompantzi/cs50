#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

// string cipher_plaintext(string plaintext);

int main(int argc, string argv[])
{
    // Get and validate the arguments
    // One command line argument
    if (argc != 2)
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }

    // Only alphabet characters
    string key = argv[1];
    for (int i = 0; i < strlen(key); i++)
    {
        if (!isalpha(key[i]))
        {
            printf("Usage: ./substitution key (Only alphabet characters!)\n");
            return 1;
        }
    }

    // Validate that the length of the key is 26 characters, no more and no less
    if (strlen(key) != 26)
    {
        printf("The length of the key must be 26 unique characters!\n");
        return 1;
    }

    // Validate that each character of alphabet is unique
    for (int i = 0; i < strlen(key); i++)
    {
        for (int j = i + 1; j < strlen(key); j++)
        {
            if (toupper(key[i]) == toupper(key[j]))
            {
                printf("The key characters aren't unique!\n");
                return 1;
            }
        }
    }
    string plaintext = get_string("plaintext: ");

    // Convert the characters of the key to upper case letters
    for (int i = 0; i < strlen(key); i++)
    {
        if (islower(key[i]))
        {
            key[i] = key[i] - 32;
        }
    }
    printf("ciphertext: ");

    for (int i = 0; i < strlen(plaintext); i++)
    {
        if (isupper(plaintext[i]))
        {
            int letter = plaintext[i] - 65; // Get the position in the key string
            printf("%c", key[letter]);
        }
        else if (islower(plaintext[i]))
        {
            int letter = plaintext[i] - 97; // Get the position in the key string
            printf("%c", key[letter] + 32);
        }
        else
        {
            printf("%c", plaintext[i]);
        }
    }
    printf("\n");
}
