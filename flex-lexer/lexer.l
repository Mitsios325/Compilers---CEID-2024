%{
#include "y.tab.h" // Bison-generated header file
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *temp_str;
int temp_str_len;
%}

%option noyywrap

%s COMMENT

%%

/*-------BOUND WORDS-------*/

"class"                 {return T_CLASS;}
"public"                {return T_PUBLIC;}
"private"               {return T_PRIVATE;}
"void"                  {return T_VOID;}
"int"                   {return T_INT;}
"double"                {return T_DOUBLE;}
"char"                  {return T_CHAR;}
"string"                {return T_STRING;}
"boolean"               {return T_BOOL;}
"do"                    {return T_DO;}
"while"                 {return T_WHILE;}
"for"                   {return T_FOR;}
"if"                    {return T_IF;}
"else if"               {return T_ELSE_IF;}
"else"                  {return T_ELSE;}
"switch"                {return T_SWITCH;}
"case"                  {return T_CASE;}
"default"               {return T_DEFAULT;}
"return"                {return T_RETURN;}
"break"                 {return T_BREAK;}
"new"                   {return T_NEW;}
"true"                  {return T_TRUE;}
"false"                 {return T_FALSE;}
"out.print"             {return T_OUT;}

/*---------SYMBOLS---------*/

"{"                     {return T_BRACKET_OPEN;}
"}"                     {return T_BRACKET_CLOSE;}
"+"                     {return T_PLUS;}
"-"                     {return T_MINUS;}
"*"                     {return T_MULT;}
"/"                     {return T_DIV;}
"="                     {return T_ASSIGNMENT;}

/*-----LOGIC OPERATORS-----*/
"<"                     {return T_OP_LT;}           /*LESS THAN*/
">"                     {return T_OP_GT;}           /*GREATER THAN*/
"<="                    {return T_OP_LTE;}          /*LESS THAN OR EQUAL*/
">="                    {return T_OP_GTE;}          /*GREATER THAN OR EQUAL*/
"!="                    {return T_OP_NE;}           /*NOT EQUAL*/
"=="                    {return T_OP_EQ;}           /*EQUAL*/
"||"                    {return T_OP_OR;}           /*LOGIC OR*/
"&&"                    {return T_OP_AND;}          /*LOGIC AND*/

/*----SPECIAL CHARACTERS---*/
";"                     {return T_SEMICOLON;}
"."                     {return T_DOT;}
","                     {return T_COMMA;}
":"                     {return T_COLON;}
"\'"                    {return T_S_QUOTE;}
"\""                    {return T_QUOTE;}



/*-----COMMENTS-----*/
"//".*\n                            { yycolumn = 1; /* yylineno++; */ }

"/*"                                { BEGIN(COMMENT); }
<COMMENT>"*/"                       { BEGIN(INITIAL); } /*should there be a sequence for closing comment without opening OR just let is appear as a syntax error by bison?*/
<COMMENT>\n                         { yycolumn = 1; /* yylineno++; */ }
<COMMENT>[(|*]                      ;
<COMMENT>[^(*\n]+                   ;
<COMMENT>.                          ;
<COMMENT><<EOF>>                    { fprintf(stderr, "Unfinished comment at EOF\n"); exit(1); }

/*----VARIABLES----*/
[0-9]+                              { printf("Integer: %d\n",atoi(yytext)); }
[0-9]+\.[0-9]+d                     { temp_str_len=strlen(yytext);
                                      temp_str=(char *)malloc((temp_str_len-1)*sizeof(char)); 
                                      strncopy(temp_str,yytext,(temp_str_len-1));
                                      printf("Double: %f\n",atof(temp_str));
                                    }
\"([^\\\"]|\\.)*\"                  { temp_str_len=strlen(yytext);
                                      temp_str=(char *)malloc((temp_str_len-2)*sizeof(char)); 
                                      strncopy(temp_str,yytext+1,(temp_str_len-2)); 
                                      printf("String %s",temp_str);
                                    }


[ \t\n]+    ;
.           ;

%%

int yywrap() {
    return 1;
}
