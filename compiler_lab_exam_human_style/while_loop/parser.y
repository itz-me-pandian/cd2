%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

int tempno = 1;
int labelno = 1;

char *newtemp(void)
{
    char name[20];

    sprintf(name, "t%d", tempno++);
    return strdup(name);
}

char *newlabel(void)
{
    char name[20];

    sprintf(name, "L%d", labelno++);
    return strdup(name);
}

char *startlabel;
char *endlabel;
%}

%union
{
    char *str;
}

%token WHILE IF ELSE ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE
%token <str> ID NUM RELOP
%type <str> expr

%left '+' '-'
%left '*' '/'

%%

program
    : while_statement
    {
        fprintf(stderr, "Syntax correct.\n");
    }
    ;

while_statement
    : WHILE LPAREN
    {
        startlabel = newlabel();
        endlabel = newlabel();

        printf("%s:\n", startlabel);
    }
    expr RELOP expr RPAREN
    {
        printf("ifFalse %s %s %s goto %s\n",
               $4, $5, $6, endlabel);
    }
    LBRACE statement_list RBRACE
    {
        printf("goto %s\n", startlabel);
        printf("%s:\n", endlabel);
    }
    ;

statement_list
    : /* empty */
    | statement_list statement
    ;

statement
    : ID ASSIGN expr SEMI
    {
        printf("%s = %s\n", $1, $3);
    }
    ;

expr
    : expr '+' expr
    {
        $$ = newtemp();
        printf("%s = %s + %s\n", $$, $1, $3);
    }
    | expr '-' expr
    {
        $$ = newtemp();
        printf("%s = %s - %s\n", $$, $1, $3);
    }
    | expr '*' expr
    {
        $$ = newtemp();
        printf("%s = %s * %s\n", $$, $1, $3);
    }
    | expr '/' expr
    {
        $$ = newtemp();
        printf("%s = %s / %s\n", $$, $1, $3);
    }
    | LPAREN expr RPAREN
    {
        $$ = $2;
    }
    | ID
    {
        $$ = $1;
    }
    | NUM
    {
        $$ = $1;
    }
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(void)
{
    freopen("tac.txt", "w", stdout);

    if (yyparse() == 0)
    {
        return 0;
    }

    return 1;
}
