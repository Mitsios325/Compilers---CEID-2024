%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int total_int = 0;
double total_float = 0;
int yylinecount = 0;

bool f_exit = true;

void yyerror(const char *s);
void print_values();
int yylex(void);
%}

%union {
    int ival;
    float fval;
}

%token <ival> T_INT
%token <fval> T_FLOAT
%token T_EXIT

%%

root
    :value root
    |T_EXIT               {print_values(); f_exit=false; YYACCEPT; }
;

value
    : T_INT             { total_int += $1; }
    | T_FLOAT           { total_float += $1; }
;

%%



int main(int argc, char *argv[]) {

    while (f_exit)
    {
        yyparse();
    }
    printf("\n\n-------PROGRAM EXITED SUCCESSFULLY------\n\n");
    return 0;   
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

void print_values() {
    printf("\n\nTotal integer values: %d\n",total_int);
    printf("\n\nTotal float values: %f\n",total_float);
    printf("\n\nTotal number of lines: %d\n\n",yylinecount);   
}