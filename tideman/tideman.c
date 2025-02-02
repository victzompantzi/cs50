#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX] = {{0}};

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
} pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
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
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}

// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{
    // TODO
    for (int k = 0; k < candidate_count; k++)
    {
        if (strcmp(name, candidates[k]) == 0)
        {
            ranks[rank] = k; // ranks is an array of integers. In ranks, the candidates are oredered by the index of the position in the candidates[]. Ex. If candidate A have the index 3 in the 1st iteration, then the first number in the array ranks[] will be: ranks[3,...]
            return true;
        }
    }
    return false;
}

// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    // TODO
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = i + 1; j < candidate_count; j++)
        {
            /*Indica las veces que cada uno de los candidatos es preferido sobre los otros.
            3 candidatos y 2 votantes.
            Ej. rank[A(0) B(1) C(2)] | rank[C(2) B(1) A(0)]
            Compara:
            A vs B = +1; A vs C = +1; B vs C = +1
            C vs B = +1; C vs A = +1; B vs A = +1
            preferences[a,b,c][a=0,b=1,c=1; a=1,b=0,c=1; a=1,b=1,c=0]
            Empate entre los tres.*/
            preferences[ranks[i]][ranks[j]]++;
        }
    }
    return;
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    // TODO
    // Se itera sobre cada preferencia con for-loops anidados
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = i + 1; j < candidate_count; j++)
        {

            if (preferences[i][j] > preferences[j][i])
            {
                //pairs son todas las combinaciones de pares posibles y pair_count es un contador que irá aumentando el índice del array pairs, mientras haya un ganador.
                pairs[pair_count].winner = i;
                pairs[pair_count].loser = j;
                pair_count++;
            }
            else if (preferences[i][j] < preferences[j][i])
            {
                pairs[pair_count].winner = j;
                pairs[pair_count].loser = i;
                pair_count++;
            }
        }
    }
    return;
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    // TODO
            // La primera iteración se establece en pair_count - 1, porque como va en retroceso y termina en 0, el índice se establece en la cantidad necesaria de iteraciones; con cada una habrá 1 elemento menos y se detendrá hasta que sea mayor o igual a 0. La segunda iteración aumenta normalmente y se detiene hasta que se iteren todos los pares, comenzando desde 0.
    for (int i = pair_count - 1; i >= 0; i--)
    {
        for (int j = 0; j <= i; j++)
        {
            // El valor de winner y loser dentro de los pares, que corresponden a los índices de los candidatos (A, B, C), determinara que preferencia es más fuerte dentro del array bidimensional preferences. En el ejemplo utilizado, si es más fuerte la preferencia de B sobre A o la de C sobre A.
            if ((preferences[pairs[j].winner][pairs[j].loser]) <
                (preferences[pairs[j + 1].winner][pairs[j + 1].loser]))
            {
                // Si la condición es cierta, se hace un intercambio de valores con un algoritmo tipo bubble-sort. Se guarda el índice con el menor valor en una variable temporal, se asigna  el índice con el mayor valor de los pares al menor (j); y al menor (j+1), se le asigna el valor original de (j) guardado en la variable temporal.
                pair temp = pairs[j];
                pairs[j] = pairs[j + 1];
                pairs[j + 1] = temp;
            }
        }
    }
    return;
}

// Cycle function will check arrow coming into each candidate
// Con el ejemplo dado, los argumentos de la función son end = 0(loser) y cycle_start = 2 (winner) del pair[0] (ya ordenado).
bool cycle(int end, int cycle_start)
{
    // Return true if there is a cycle created (Recursion base case)
    if (end == cycle_start)
    {
        return true;
    }

    // Loop through candidates (Recursive case)
    for (int i = 0; i < candidate_count; i++)
    {
        // Inicialmente, todos los valores del array 2d locked son falsos. Ver   bloque que inicia en línea 58. Según el ejemplo, la primera iteración es si(locked[0][0] = false). Por lo tanto, devuelve 'false' otra vez.
        if (locked[end][i])
        {
            if (cycle(i, cycle_start))
            {
                return true;
            }
        }
    }
    return false;
}

// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    // Loop through pairs
    for (int i = 0; i < pair_count; i++)
    {
        // If cycle function returns false, lock the pair
        if (!cycle(pairs[i].loser, pairs[i].winner))
        {
            locked[pairs[i].winner][pairs[i].loser] = true;
        }
    }
    return;
}

// Print the winner of the election
void print_winner(void)
{
    // TODO
    // Winner is the candidate with no arrows pointing to them
    for (int i = 0; i < candidate_count; i++)
    {
        int false_count = 0;

        for (int j = 0; j < candidate_count; j++)
        {
            if (locked[j][i] == false)
            {
                false_count++;
                if (false_count == candidate_count)
                {
                    printf("%s\n", candidates[i]);
                }
            }
        }
    }
    return;
}
