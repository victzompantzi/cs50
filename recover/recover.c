// Este programa copia iterativamente los bloques de 512 bytes de la tarjeta de memoria, para generar los archivos de imágenes cada vez que se encuentra con el patrón de los archivos JPG.

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 512

int main(int argc, char *argv[])
{
    // Accept a single command-line argument
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }
    // Open the memory card
    FILE *card = fopen(argv[1], "r");
    if (card == NULL)
    {
        printf("Memory card is not readable!");
        return 1;
    }

    // Initialize variables.
    uint8_t buffer[BLOCK_SIZE]; // Create a buffer for a block of data. 512 bytes by buffer
    bool found_jpg = false;     // Flag to keep track of wether a JPEG has been found.
    int jpg_count = 0;          // Number of JPEGs.
    char filename[8];           // Array to store the filename of the current JPEG.
    FILE *img = NULL;           // Pointer to the current JPEG file.

    // While there's still data left to read from the memory card. Read the forensic image file
    // block by block.
    // Whitin this while loop all checks are made before writing data to the JPG image
    // createdfiles that have been
    while (fread(buffer, BLOCK_SIZE, 1, card) == 1)

    {
        // Create JPEGs from the data
        // Check if this block marks the start of a new JPEG
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff &&
            (buffer[3] & 0xf0) == 0xe0)
        {
            // Close the previous JPEG file, if one was open.
            if (found_jpg)
            {
                fclose(img);
            }
            else
            {
                found_jpg = true;
            }
            // Open a new JPEG file
            sprintf(filename, "%03d.jpg", jpg_count);   // Generate the filename for the new JPEG file
                                                        // based on the jpg_count variable
            img = fopen(filename, "w");                 // Open a new JPEG image file with the new
                                                        // generated filename
            if (img == NULL)
            {
                fclose(card);
                printf("Could not create %s.\n", filename); // Print an error if the new JPEG image file
                                                            // cannot be created, because de memory card cannot be read
                return 3;
            }
            jpg_count++; // Increment the jpg_count variable
        }
        // Write the currnet block to the current JPEG file, if one is open
        if (found_jpg)
        {
            fwrite(buffer, BLOCK_SIZE, 1, img);
        }
    }
    // Close the forensic image file and the last JPEG file, if one was open
    fclose(card);
    if (found_jpg)
    {
        fclose(img);
    }
    return 0;
}
