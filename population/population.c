#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int startSize;
    do
    {
        // TODO: Prompt for start size
        startSize = get_int("Starting Size: ");
    }
    while (startSize < 9);

    int endSize;
    do
    {
        // TODO: Prompt for end size
        endSize = get_int("End Size: ");
    }
    while (endSize < startSize);

    // TODO: Calculate number of years until we reach threshold
    int growthPerYear;
    int currentPopulation = startSize;
    int yearsElapsed = 0;

    while (currentPopulation < endSize)
    {
        growthPerYear = currentPopulation / 3 - currentPopulation / 4; //
        currentPopulation += growthPerYear;
        yearsElapsed++;
    }
    // TODO: Print number of years
    printf("Years: %i\n", yearsElapsed);
}
