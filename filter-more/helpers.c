#include "helpers.h"
#include "math.h"
#include "string.h"

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float avgRGB =
                (float) (image[i][j].rgbtBlue + image[i][j].rgbtGreen + image[i][j].rgbtRed) / 3;
            image[i][j].rgbtBlue = round(avgRGB);
            image[i][j].rgbtGreen = round(avgRGB);
            image[i][j].rgbtRed = round(avgRGB);
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < floor(width / 2); j++)
        {
            RGBTRIPLE tmp = image[i][j];
            memcpy(&image[i][j], &image[i][(width - 1) - j], sizeof(RGBTRIPLE));
            memcpy(&image[i][(width - 1) - j], &tmp, sizeof(RGBTRIPLE));
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    // Create a temporary image to implement blurred algorithm on it.
    RGBTRIPLE temp[height][width];

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int totalRed, totalBlue, totalGreen;
            totalRed = totalBlue = totalGreen = 0;
            float counter = 0.00;
            // Get the neighboring pixels
            for (int x = -1; x < 2; x++)
            {
                for (int y = -1; y < 2; y++)
                {
                    int currentX = i + x;
                    int currentY = j + y;

                    // Check for valid neighboring pixels
                    if (currentX < 0 || currentX > (height - 1) || currentY < 0 ||
                        currentY > (width - 1))
                    {
                        continue;
                    }
                    // Get the image value
                    totalRed += image[currentX][currentY].rgbtRed;
                    totalGreen += image[currentX][currentY].rgbtGreen;
                    totalBlue += image[currentX][currentY].rgbtBlue;

                    counter++;
                }
                // Obtain the average of neighboring pixels
                temp[i][j].rgbtRed = round(totalRed / counter);
                temp[i][j].rgbtGreen = round(totalGreen / counter);
                temp[i][j].rgbtBlue = round(totalBlue / counter);
            }
        }
    }
    // Copy the blurr image to the original image
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j].rgbtRed = temp[i][j].rgbtRed;
            image[i][j].rgbtGreen = temp[i][j].rgbtGreen;
            image[i][j].rgbtBlue = temp[i][j].rgbtBlue;
        }
    }
    return;
}

// Detect edges
double findSQRT(double N)
{
    return sqrt(N);
}
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    // Create a temporary image to implement blurred algorithm on it.
    RGBTRIPLE temp[height][width];
    // Define every condition you may encounter with pixels
    int GxR, GyR, GxG, GyG, GxB, GyB;
    // Initialize Gx and Gy matrix.
    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    // Iterate over the entire matrix.
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            GxR = GyR = GxG = GyG = GxB = GyB = 0;

            for (int h = -1; h < 2; h++)
            {
                for (int w = -1; w < 2; w++)
                {
                    // Check for valid neighboring pixels
                    if (i + h < 0 || i + h > height - 1)
                    {
                        continue;
                    }
                    if (j + w < 0 || j + w > width - 1)
                    {
                        continue;
                    }

                    // sum each channel value
                    // X
                    GxR += image[i + h][j + w].rgbtRed * Gx[h + 1][w + 1];
                    GxG += image[i + h][j + w].rgbtGreen * Gx[h + 1][w + 1];
                    GxB += image[i + h][j + w].rgbtBlue * Gx[h + 1][w + 1];
                    // Y
                    GyR += image[i + h][j + w].rgbtRed * Gy[h + 1][w + 1];
                    GyG += image[i + h][j + w].rgbtGreen * Gy[h + 1][w + 1];
                    GyB += image[i + h][j + w].rgbtBlue * Gy[h + 1][w + 1];
                }
            }
            // Calculate every Gx and Gy value and store in temp
            temp[i][j].rgbtRed = fmin(round(sqrt(GxR * GxR + GyR * GyR)), 255);
            temp[i][j].rgbtGreen = fmin(round(sqrt(GxG * GxG + GyG * GyG)), 255);
            temp[i][j].rgbtBlue = fmin(round(sqrt(GxB * GxB + GyB * GyB)), 255);
        }
    }

    // Copy the filter image to the original.
    // Ready to iterate whole image from temp to image[i][j]
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j] = temp[i][j];
        }
    }
    return;
}
