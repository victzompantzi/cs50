/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

struct student
{
    char name[50];
    float califs[3];
    float prom;
};

int main()
{
    struct student *ptr;
    int i, n;

    do{
    printf("Introduzca el número de estudiantes:\n");
    scanf("%d",&n);
    } while (n > 99);

    ptr = (struct student*)malloc(n*sizeof(struct student));
    if (ptr == NULL)
    {
        return 1;
    }

    for (i = 0; i < n; ++i)
    {
        printf("Introduzca el nombre y las tres calificaciones del estudiante %d:\n", i + 1);
        scanf("%s %f %f %f",(ptr+i)->name, &(ptr+i)->califs[0], &(ptr+i)->califs[1], &(ptr+i)->califs[2]);
    }

    for (i = 0; i < n; ++i)
    {
        (ptr+i)->prom = ((float)(ptr+i)->califs[0]+(float)(ptr+i)->califs[1]+(float)(ptr+i)->califs[2])/3.0;
        printf("Estudiante %s obtuvo un promedio de %.2f.\n",(ptr+i)->name, (ptr+i)->prom);
    }
    return 0;
}
