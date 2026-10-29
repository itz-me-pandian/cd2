#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    FILE *input;
    FILE *output;
    char line[256];
    char left[50], a[50], b[50], op;
    int x, y, result;

    if (argc != 3)
    {
        printf("Usage: %s input.tac output.tac\n", argv[0]);
        return 1;
    }

    input = fopen(argv[1], "r");
    if (input == NULL)
    {
        perror("Input file");
        return 1;
    }

    output = fopen(argv[2], "w");
    if (output == NULL)
    {
        perror("Output file");
        fclose(input);
        return 1;
    }

    while (fgets(line, sizeof(line), input) != NULL)
    {
        if (sscanf(line, "%49s = %49s %c %49s", left, a, &op, b) == 4
            && sscanf(a, "%d", &x) == 1
            && sscanf(b, "%d", &y) == 1)
        {
            if (op == '+')
            {
                result = x + y;
            }
            else if (op == '-')
            {
                result = x - y;
            }
            else if (op == '*')
            {
                result = x * y;
            }
            else if (op == '/' && y != 0)
            {
                result = x / y;
            }
            else
            {
                fprintf(output, "%s", line);
                continue;
            }

            fprintf(output, "%s = %d\n", left, result);
        }
        else
        {
            fprintf(output, "%s", line);
        }
    }

    fclose(input);
    fclose(output);

    printf("Optimization complete.\n");
    return 0;
}
