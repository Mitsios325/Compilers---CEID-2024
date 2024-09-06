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

%token T_PUBLIC T_PRIVATE T_CLASS T_INT T_CHAR T_DOUBLE T_BOOLEAN T_STRING T_VOID T_IF T_ELSE T_ELSE_IF T_FOR T_WHILE T_DO T_RETURN T_BREAK T_SWITCH T_CASE T_DEFAULT T_NEW T_OUT T_TRUE T_FALSE
%token T_ASSIGNMENT T_OP_EQ T_OP_NE T_OP_LT T_OP_GT T_OP_LTE T_OP_GTE T_OP_AND T_OP_OR T_PLUS T_MINUS T_MULT T_DIV
%token T_BRACKET_OPEN T_BRACKET_CLOSE T_SEMICOLON T_COMMA T_DOT T_COLON T_S_QUOTE T_QUOTE
%token T_IDENTIFIER T_INTEGER T_DOUBLE_LITERAL T_CHAR_LITERAL T_STRING T_LPAREN T_RPAREN

%start program

%%

/* Production rules based on the BNF */

program
    :  class 
    |  program class 
    ;

class
    : class_declaration 
    ;

class_declaration
    : T_PUBLIC T_CLASS class_name T_BRACKET_OPEN pro_variable_declaration pro_method_declaration comment T_BRACKET_CLOSE
    ;

class_name
    : T_IDENTIFIER
    ;

pro_variable_declaration
    : variable_declaration pro_variable_declaration
    | /* empty */
    ;

pro_method_declaration
    : method 
    | /* empty */
    ;

method
    : method_declaration T_BRACKET_OPEN expressions return_statement T_BRACKET_CLOSE
    | method_declaration T_BRACKET_OPEN statement T_BRACKET_CLOSE
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
    : expressions 
    | statement 
    | expressions method_body
    | statement method_body
    ;

loop_statement
    : T_DO T_BRACKET_OPEN method_body T_BRACKET_CLOSE T_WHILE T_LPAREN condition T_RPAREN T_SEMICOLON
    | T_FOR T_LPAREN expressions T_SEMICOLON condition T_SEMICOLON expressions T_RPAREN T_BRACKET_OPEN method_body T_BRACKET_CLOSE
    ;

control_statement
    : T_IF T_LPAREN condition T_RPAREN T_BRACKET_OPEN method_body T_BRACKET_CLOSE else_if_statement else_statement
    | T_SWITCH T_LPAREN expression T_RPAREN T_BRACKET_OPEN case_statement default_statement T_BRACKET_CLOSE
    ;

else_if_statement
    : T_ELSE_IF T_LPAREN condition T_RPAREN T_BRACKET_OPEN method_body T_BRACKET_CLOSE
    | /* empty */
    ;

else_statement
    : T_ELSE T_BRACKET_OPEN method_body T_BRACKET_CLOSE
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
    : T_OUT T_LPAREN T_STRING T_COMMA T_IDENTIFIER T_RPAREN T_SEMICOLON
    | T_OUT T_LPAREN T_STRING T_RPAREN T_SEMICOLON
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
    : variable_declaration 
    | var_type set_val T_SEMICOLON 
    | set_val T_SEMICOLON 
    | set_val arethmetical_operation value T_SEMICOLON 
    ;

expression
    : factor
    | expression arethmetical_operation factor
    ;

factor
    : T_IDENTIFIER
    | T_INTEGER
    | T_CHAR_LITERAL
    | T_DOUBLE_LITERAL
    | T_STRING
    | T_LPAREN expression T_RPAREN
    | method_call
    | object_creation
    ;

set_val
    : T_IDENTIFIER T_ASSIGNMENT value
    ;

arethmetical_operation
    : T_PLUS
    | T_MINUS
    | T_MULT
    | T_DIV
    | T_ASSIGNMENT
    ;

object_creation
    : T_IDENTIFIER T_ASSIGNMENT T_NEW T_IDENTIFIER T_LPAREN T_RPAREN T_SEMICOLON
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
    :  expressions 
    |  loop_statement 
    |  control_statement 
    |  print_statement 
    |  return_statement 
    |  break_statement 
    ;

condition
    : expression relational_operator expression
    | condition logical_operator condition
    | T_LPAREN condition T_RPAREN
    ;

relational_operator
    : T_OP_GT
    | T_OP_LT
    | T_OP_EQ
    | T_OP_NE
    | T_OP_GTE
    | T_OP_LTE
    ;

logical_operator
    : T_OP_AND
    | T_OP_OR
    ;

value
    : T_INTEGER
    | T_DOUBLE_LITERAL
    | T_STRING
    | T_CHAR_LITERAL
    | T_TRUE
    | T_FALSE
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
