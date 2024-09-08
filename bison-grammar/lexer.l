%{
#include "bisonNEW.tab.h" // Bison-generated header file
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern YYSTYPE yylval;

extern int yylinecount;

char *temp_str;
int temp_str_len;
%}


%s COMMENT

%%

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


"{"                     {return T_BRACKET_OPEN;}
"}"                     {return T_BRACKET_CLOSE;}
"("                     {return T_LPAREN;}
")"                     {return T_LPAREN;}
"+"                     {return T_PLUS;}
"-"                     {return T_MINUS;}
"*"                     {return T_MULT;}
"/"                     {return T_DIV;}
"="                     {return T_ASSIGNMENT;}

"<"                     {return T_OP_LT;}           /*LESS THAN*/
">"                     {return T_OP_GT;}           /*GREATER THAN*/
"<="                    {return T_OP_LTE;}          /*LESS THAN OR EQUAL*/
">="                    {return T_OP_GTE;}          /*GREATER THAN OR EQUAL*/
"!="                    {return T_OP_NE;}           /*NOT EQUAL*/
"=="                    {return T_OP_EQ;}           /*EQUAL*/
"||"                    {return T_OP_OR;}           /*LOGIC OR*/
"&&"                    {return T_OP_AND;}          /*LOGIC AND*/

";"                     {return T_SEMICOLON;}
"."                     {return T_DOT;}
","                     {return T_COMMA;}
":"                     {return T_COLON;}
"\'"                    {return T_S_QUOTE;}
"\""                    {return T_QUOTE;}



"//".*\n                            { yylinecount++ }

"/*"                                { BEGIN(COMMENT); }
<COMMENT>"*/"                       { BEGIN(INITIAL); } /*should there be a sequence for closing comment without opening OR just let is appear as a syntax error by bison?*/
<COMMENT>\n                         { yylinecount++; }
<COMMENT>.                          ;
<COMMENT><<EOF>>                    { fprintf(stderr, "Unfinished comment at EOF\n"); exit(1); }

[a-zA-Z][a-zA-Z0-9_]*               { yylval.sval=strdup(yytext); return T_IDENTIFIER; }
[A-Z][a-zA-Z0-9_]*                  { yylval.sval=strdup(yytext); return T_CIDENTIFIER; }
[0-9]+                              { yylval.ival=atoi(yytext); return T_INT_V; }
[0-9]+\.[0-9]+d                     { temp_str=strdup(yytext);
                                      strncopy(temp_str,temp_str,(strlen(temp_str)-1));
                                      yylval.fval=atof(temp_str);
                                      return T_DOUBLE_V;
                                    }
\"([^\\\"]|\\.)*\"                  { temp_str=strdup(yytext); 
                                      strncopy(temp_str,temp_str+1,(strlen(temp_str)-2)); 
                                      yylval.sval=strdup(temp_str);
                                      return T_STRING_V;
                                    }


[ \t]+                              ;
[\n\r]                              {yylinecount++;}
.                                   ;

%%

int yywrap() {
    return 1;
}
