#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[])
{
    FILE *input;
    FILE *output;
    char line[256];
    char left[50], a[50], b[50], op;

    if (argc != 3)
    {
        printf("Usage: %s input.tac output.asm\n", argv[0]);
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

    fprintf(output, "; Simple target code\n");

    while (fgets(line, sizeof(line), input) != NULL)
    {
        if (line[0] == 'L' && strchr(line, ':') != NULL)
        {
            fprintf(output, "%s", line);
        }
        else if (strncmp(line, "goto ", 5) == 0)
        {
            fprintf(output, "JMP %s", line + 5);
        }
        else if (strncmp(line, "ifFalse ", 8) == 0)
        {
            fprintf(output, "; conditional branch: %s", line);
        }
        else if (sscanf(line, "%49s = %49s %c %49s",
                        left, a, &op, b) == 4)
        {
            fprintf(output, "LOAD R0, %s\n", a);

            if (op == '+')
            {
                fprintf(output, "ADD R0, %s\n", b);
            }
            else if (op == '-')
            {
                fprintf(output, "SUB R0, %s\n", b);
            }
            else if (op == '*')
            {
                fprintf(output, "MUL R0, %s\n", b);
            }
            else if (op == '/')
            {
                fprintf(output, "DIV R0, %s\n", b);
            }

            fprintf(output, "STORE %s, R0\n", left);
        }
        else if (sscanf(line, "%49s = %49s", left, a) == 2)
        {
            fprintf(output, "MOV %s, %s\n", left, a);
        }
        else
        {
            fprintf(output, "; %s", line);
        }
    }

    fclose(input);
    fclose(output);

    printf("Target code generated.\n");
    return 0;
}
