#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int count_letters(string text);
int count_words(string text);
int count_sentences(string text);

int main(void)
{
    // Prompt the user for some text.
    string text = get_string("Text:\n");

    // Count the number of letters, words, and sentences in the text.
    if (!isspace(text[0]) && ispunct(text[strlen(text) - 1]))
    {
        int letters = count_letters(text);
        int words = count_words(text);
        int sentences = count_sentences(text);

        // Compute the Coleman-Liau index.
        printf("The number of letters is: %i \n", letters);
        printf("The number of words is: %i \n", words);
        printf("The number of sentences is: %i \n", sentences);
        // Print the grade index.
        float L = (float) letters / (float) words * 100;
        float S = (float) sentences / (float) words * 100;
        int index = round(0.0588 * L - 0.296 * S - 15.8);
        if (index < 1)
        {
            printf("Before Grade 1\n");
        }
        else if (index > 16)
        {
            printf("Grade 16+\n");
        }
        else
        {
            printf("Grade %i\n", index);
        }
    }
    else
    {
        printf("Please enter a paragraph that does not begin with one or more spaces, a tab, or a new line, and that ends with a "
               "period.\n");
    }
}

int count_letters(string text)
{
    int count = 0;
    for (int i = 0; i < strlen(text); i++)
    {
        if (isalpha(text[i]))
        {
            count += 1;
        }
    }
    return count;
}

int count_words(string text)
{
    int count = 1;
    for (int i = 0; i < strlen(text); i++)
    {
        if (isspace(text[i]))
        {
            count += 1;
        }
    }
    return count;
}

int count_sentences(string text)
{
    int count = 0;
    for (int i = 0, len = strlen(text); i < len; ++i)
    {
        if (text[i] == '.' || text[i] == '?' || text[i] == '!')
        {
            count += 1;
        }
    }
    return count;
}
