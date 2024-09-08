%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <stdbool.h>

extern int yylex();
extern int yyparse();
extern int yylinecount;
extern FILE *yyin; 

void yyerror(const char* s){
  syslog(LOG_ERR, "Syntax error: %s\n", s);
}
%}

%union {
    int ival;
    float fval;
    char *sval;
    char cval;
    bool bval;
}  

%token T_PUBLIC T_PRIVATE T_CLASS T_CHAR T_DOUBLE T_BOOL T_VOID T_IF T_ELSE T_ELSE_IF T_FOR T_WHILE T_DO T_RETURN T_BREAK T_SWITCH T_CASE T_DEFAULT T_NEW T_OUT
%token T_ASSIGNMENT T_OP_EQ T_OP_NE T_OP_LT T_OP_GT T_OP_LTE T_OP_GTE T_OP_AND T_OP_OR T_PLUS T_MINUS T_MULT T_DIV
%token T_BRACKET_OPEN T_BRACKET_CLOSE T_SEMICOLON T_COMMA T_DOT T_COLON T_S_QUOTE T_QUOTE
%token T_INT T_LPAREN T_RPAREN T_STRING
%token <sval> T_IDENTIFIER
%token <sval> T_CIDENTIFIER
%token <sval> T_STRING_V
%token <ival> T_INT_V
%token <fval> T_DOUBLE_V
%token <bval> T_TRUE
%token <bval> T_FALSE
%token <cval> T_CHAR_V


%start program

%%

/* Production rules based on the BNF */

program
    :  program class 
    |   /* empty */
    ;

class
    : class_declaration class class_declaration
    | /* empty */
    ;

class_declaration
    : T_PUBLIC T_CLASS T_CIDENTIFIER T_BRACKET_OPEN pro_variable_declaration pro_method_declaration class T_BRACKET_CLOSE
    ;

pro_variable_declaration
    : pro_variable_declaration variable_declaration
    | /* empty */
    ;

pro_method_declaration
    : pro_method_declaration method
    | /* empty */

method
    : method_declaration T_BRACKET_OPEN expressions return_type T_IDENTIFIER T_BRACKET_CLOSE
    | method_declaration T_BRACKET_OPEN expressions T_BRACKET_CLOSE
    ;

method_declaration
    : modifier return_type T_IDENTIFIER T_LPAREN parameters T_RPAREN
    ;

variable_declaration
    : modifier var_type T_IDENTIFIER T_SEMICOLON
    | var_type T_IDENTIFIER T_SEMICOLON
    ;

var_type
    : T_INT
    | T_CHAR
    | T_DOUBLE
    | T_BOOL
    | T_STRING
    ;

expressions
    : variable_declaration
    | var_type set_val T_SEMICOLON
    | set_val T_SEMICOLON
    | set_val arethmetical_operation value T_SEMICOLON
    ;

parameters
    : var_type T_IDENTIFIER parameters
    | T_COMMA parameters
    | /* empty */
    ;

set_val
    : T_IDENTIFIER T_ASSIGNMENT value
    ;

arethmetical_operation
    : T_PLUS
    | T_MINUS
    | T_MULT
    | T_DIV
    ;

return_type
    : var_type
    | /* empty */
    ;

modifier
    : T_PRIVATE
    | T_PUBLIC
    ;

value
    : T_IDENTIFIER 
    | T_INT_V
    | T_DOUBLE_V
    | T_STRING_V { }
    | T_CHAR_V 
    | T_TRUE { $$=$1 }
    | T_FALSE { $$=$1 }
    ;