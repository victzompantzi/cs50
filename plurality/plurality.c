#include <cs50.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// Candidates have name and vote count
typedef struct
{
    string name;
    int votes;
} candidate;

// Array of candidates
candidate candidates[MAX];

// Number of candidates
int candidate_count;

// Number of voters
int voter_count;

// Function prototypes
bool vote(string name);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: plurality [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
    }

    do
    {
        voter_count = get_int("Number of voters: ");
    }
    while (voter_count <= 0);

    int countValidVote = 0;
    int countInvalidVote = 0;
    // Loop over all voters
    // Check for invalid vote
    do
    {
        string name = get_string("Vote: ");
        if (vote(name) == true)
        {
            countValidVote++;
        }
        else
        {
            printf("Invalid vote!\n");
            countInvalidVote++;
        }
    }
    while (countInvalidVote >= 0 && countValidVote < voter_count);
    // Display winner of election
    print_winner();
}

// Update vote totals given a new vote
bool vote(string name)
{
    // TODO
    // Iterate over each candidate
    int checkCandidate = 0;
    for (int i = 0; i < candidate_count; i++)
    {
        // Check if candidate's name matches given name
        if (strcmp(candidates[i].name, name) == 0)
        {
            checkCandidate += 1;
            // If yes, increment candidate's votes and return true
            candidates[i].votes += 1;
        }
    }
    if (checkCandidate == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

// Print the winner (or winners) of the election
void print_winner(void)
{
    // TODO
    // Create a variable for the maximum number of votes
    int maxVotes = 0;
    // Iterate over list of candidates
    for (int i = 0; i < candidate_count; i++)
    {
        // Check for candidate votes that are greater than maximum number of votes an set
        if (candidates[i].votes > maxVotes)
        {
            maxVotes = candidates[i].votes;
        }
    }

    // Iterate over list of candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // Check for candidate votes that are equal to maximum vote and print them as you go
        if (candidates[i].votes == maxVotes)
        {
            printf("%s\n", candidates[i].name);
        }
    }
}
