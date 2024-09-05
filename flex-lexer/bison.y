%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char* s){
  syslog(LOG_ERR, "Syntax error: %s\n", s);
}
%}

/* Declare tokens from the lexer */
%token T_PUBLIC T_CLASS T_INT T_CHAR T_DOUBLE T_BOOL T_STRING T_VOID T_IF T_ELSE T_ELSE_IF T_FOR T_WHILE T_DO T_RETURN T_BREAK T_SWITCH T_CASE T_DEFAULT T_NEW T_OUT T_TRUE T_FALSE
%token T_ASSIGN T_OP_EQ T_OP_NE T_OP_LT T_OP_GT T_OP_AND T_OP_OR T_PLUS T_MINUS T_MULT T_DIV
%token T_LPAREN T_RPAREN T_LBRACE T_RBRACE T_SEMICOLON T_COMMA T_DOT
%token T_IDENTIFIER T_INT_LITERAL T_DOUBLE_LITERAL T_CHAR_LITERAL T_STRING_LITERAL

/* Define operator precedence and associativity if needed */
%token T_OR T_AND
%token T_EQUAL T_NOT_EQUAL T_LESS T_GREATER
%token T_PLUS T_MINUS
%token T_MULT T_DIV

/* Non-terminal symbols */
%start program

%%

/* Production rules based on the BNF */

program
    : comment class
    | comment program class
    ;

class
    : class_declaration comment
    ;

comment
    : "//" T_STRING_LITERAL
    | "/*" T_STRING_LITERAL "*/"
    | /* empty */
    ;

class_declaration
    : T_PUBLIC T_CLASS class_name T_LBRACE comment pro_variable_declaration pro_method_declaration comment T_RBRACE
    ;

class_name
    : T_IDENTIFIER
    ;

pro_variable_declaration
    : comment variable_declaration comment pro_variable_declaration
    | /* empty */
    ;

pro_method_declaration
    : comment method comment
    | /* empty */
    ;

method
    : method_declaration T_LBRACE expressions return_statement T_RBRACE
    | method_declaration T_LBRACE statement T_RBRACE
    ;

variable_declaration
    : modifier var_type T_IDENTIFIER T_SEMICOLON
    | var_type T_IDENTIFIER T_SEMICOLON
    ;

method_declaration
    : modifier return_type T_IDENTIFIER T_LPAREN parameters T_RPAREN
    ;

method_call
    : T_IDENTIFIER T_DOT T_IDENTIFIER T_LPAREN variables T_RPAREN T_SEMICOLON
    | T_IDENTIFIER T_DOT T_IDENTIFIER T_SEMICOLON
    ;

method_body
    : comment expressions comment
    | comment statement comment
    | comment expressions method_body
    | comment statement method_body
    ;

loop_statement
    : T_DO T_LBRACE method_body T_RBRACE T_WHILE T_LPAREN condition T_RPAREN T_SEMICOLON
    | T_FOR T_LPAREN expressions T_SEMICOLON condition T_SEMICOLON expressions T_RPAREN T_LBRACE method_body T_RBRACE
    ;

control_statement
    : T_IF T_LPAREN condition T_RPAREN T_LBRACE method_body T_RBRACE else_if_statement else_statement
    | T_SWITCH T_LPAREN expression T_RPAREN T_LBRACE case_statement default_statement T_RBRACE
    ;

else_if_statement
    : T_ELSE_IF T_LPAREN condition T_RPAREN T_LBRACE method_body T_RBRACE
    | /* empty */
    ;

else_statement
    : T_ELSE T_LBRACE method_body T_RBRACE
    | /* empty */
    ;

case_statement
    : T_CASE expression T_COLON method_body
    | T_CASE expression T_COLON method_body case_statement
    ;

default_statement
    : T_DEFAULT T_COLON method_body
    | /* empty */
    ;

print_statement
    : T_PRINT T_LPAREN T_STRING_LITERAL T_COMMA T_IDENTIFIER T_RPAREN T_SEMICOLON
    | T_PRINT T_LPAREN T_STRING_LITERAL T_RPAREN T_SEMICOLON
    ;

return_statement
    : T_RETURN expression T_SEMICOLON
    | T_RETURN T_SEMICOLON
    ;

break_statement
    : T_BREAK T_SEMICOLON
    ;

variables
    : T_IDENTIFIER
    | T_IDENTIFIER T_COMMA variables
    ;

expressions
    : comment variable_declaration comment
    | comment var_type set_val T_SEMICOLON comment
    | comment set_val T_SEMICOLON comment
    | comment set_val arethmetical_operation value T_SEMICOLON comment
    ;

expression
    : factor
    | expression arethmetical_operation factor
    ;

factor
    : T_IDENTIFIER
    | T_INT_LITERAL
    | T_CHAR_LITERAL
    | T_DOUBLE_LITERAL
    | T_BOOLEAN_LITERAL
    | T_STRING_LITERAL
    | T_LPAREN expression T_RPAREN
    | method_call
    | object_creation
    ;

set_val
    : T_IDENTIFIER T_ASSIGN value
    ;

arethmetical_operation
    : T_PLUS
    | T_MINUS
    | T_MULTIPLY
    | T_DIVIDE
    ;

object_creation
    : class T_IDENTIFIER T_ASSIGN T_NEW class T_LPAREN T_RPAREN T_SEMICOLON
    ;

parameters
    : var_type T_IDENTIFIER parameters
    | T_COMMA parameters
    | /* empty */
    ;

return_type
    : var_type
    | T_VOID
    ;

modifier
    : T_PRIVATE
    | T_PUBLIC
    ;

var_type
    : T_INT
    | T_CHAR
    | T_DOUBLE
    | T_BOOLEAN
    | T_STRING
    ;

statement
    : comment expressions comment
    | comment loop_statement comment
    | comment control_statement comment
    | comment print_statement comment
    | comment return_statement comment
    | comment break_statement comment
    ;

condition
    : expression relational_operator expression
    | condition logical_operator condition
    | T_LPAREN condition T_RPAREN
    ;

relational_operator
    : T_GREATER
    | T_LESS
    | T_EQUAL
    | T_NOT_EQUAL
    ;

logical_operator
    : T_AND
    | T_OR
    ;

value
    : T_INT_LITERAL
    | T_DOUBLE_LITERAL
    | T_STRING_LITERAL
    | T_CHAR_LITERAL
    | T_BOOLEAN_LITERAL
    ;

%%

/* C code for error handling and main function */

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    yyparse();
    return 0;
}
