#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int height;
    do
    {
        height = get_int("Indicate the number of steps in the pyramid: ");
    }
    while (height <= 0 || height > 8);

    // la pirámide se forma de arriba hacia abajo
    for (int i = 0; i < height; i++) // son las filas o el alto de la pirámide
    {
        for (int j = 0; j < height;
             j++) // completa esta iteración, la de las columnas, antes de repetirse con la siguiente iteración de las filas (i)
        {
            if (i + j < height - 1) // con cada iteración de (j) evalúa la siguiente expresión:
            {
                printf(" ");
            }
            else
            {
                printf("#");
            }
        }
        printf("\n"); // va fuera del loop de rellenar las columnas (j) de las filas (i), para ir generando los escalones de las
                      // pirámide
    }
}