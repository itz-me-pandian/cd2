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
%}

%union
{
    char *str;
}

%token IF ELSE ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE
%token <str> ID NUM RELOP
%type <str> expr

%left '+' '-'
%left '*' '/'

%%

program
    : if_statement
    {
        fprintf(stderr, "Syntax correct.\n");
    }
    ;

if_statement
    : IF LPAREN expr RELOP expr RPAREN
    {
        $<str>$ = newlabel();
        printf("ifFalse %s %s %s goto %s\n",
               $3, $4, $5, $<str>$);
    }
    LBRACE statement_list RBRACE
    {
        $<str>$ = newlabel();
        printf("goto %s\n", $<str>$);
        printf("%s:\n", $<str>7);
    }
    ELSE LBRACE statement_list RBRACE
    {
        printf("%s:\n", $<str>11);
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
