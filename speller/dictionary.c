// Implements a dictionary's functionality
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

// TODO: Choose number of buckets in hash table
const unsigned int N = 52;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    unsigned int index = hash(word); // Set the correct index
    node *cursor = table[index];
    for (node *tmp = cursor; tmp != NULL; tmp = tmp->next) // The iteration starts with the struct 'tmp' which receives the struct 'table' previously loaded in 'cursor'. It iterates until the value is NULL and advances through the 'next' pointer in the struct.
    {
        if (strcasecmp(tmp->word, word) == 0)
        {
            return true;
        }
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO: Improve this hash function
    int length = strlen(word); // Inicializa la cadena vacía
    unsigned int totalSqrt = 0;
    for (int i = 0; i < length; i++)
    {
        unsigned int sqrt = (tolower(word[i])) ^ 6;
        totalSqrt += sqrt;
    }
    return totalSqrt % 52;
}

// Loads dictionary into memory, returning true if successful, else false
int counter = 0;
bool load(const char *dictionary)
{
    // TODO
    FILE *dict = fopen(dictionary, "r"); // Loads, checks for NULL and reads the dictionary.
    if (dict == NULL)
    {
        fprintf(stderr, "There has been an error");
        return false;
    }
    char wordlist[LENGTH + 1] = "";
    while (fscanf(dict, "%s", wordlist) != EOF)
    {
        counter += 1;
        node *word = malloc(sizeof(node)); // Allocate memory for the words
        if (word == NULL)
        {
            return 1;
        }
        strcpy(word->word, wordlist); // Assign current word to node
        word->next = NULL;            // Each new word added will be the tail of the linked list
        int index = hash(wordlist);   // Sets the correct index
        if (table[index] == NULL)     // If the array is empty, store the word at the beginning of the array
        {
            table[index] = word;
        }
        else
        {
            word->next = table[index]; // Adds one node in a new direction
            table[index] = word; // Correctly positioned, copy the 'word' struct in a new node table
        }
    }
    fclose(dict);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return counter;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    node *tmp = NULL;
    node *cursor = NULL;
    for (int i = 0; i < N; ++i)
    {
        cursor = table[i]; // At the top of the list
        while (cursor != NULL)
        {
            tmp = cursor; // 'tmp' will follow 'cursor'
            cursor = cursor->next;
            free(tmp); // Realising one by one of the nodes
        }
    }
    return true;
}
