%{
#include "bisonNEWNEW.tab.h" // Bison-generated header file
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern YYSTYPE yylval;

extern int yylinecount;

char convert_to_char(const char* yytext) {
    // Check if it's an escape sequence (starts with a backslash)
    if (yytext[1] == '\\') {
        switch (yytext[2]) {
            case 'a': return '\a';  // Bell
            case 'b': return '\b';  // Backspace
            case 'f': return '\f';  // Formfeed
            case 'n': return '\n';  // Newline
            case 'r': return '\r';  // Carriage return
            case 't': return '\t';  // Tab
            case 'v': return '\v';  // Vertical tab
            case '\\': return '\\'; // Backslash
            case '\'': return '\''; // Single quote
            case '\"': return '\"'; // Double quote
            case '?': return '\?';  // Question mark
            default: return yytext[2]; // If it's not a known escape, return the second char
        }
    }
    // If it's a single regular character, just return it
    return yytext[1];
}

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
"true"                  {yylval.bval=1; return T_TRUE;}
"false"                 {yylval.bval=0;return T_FALSE;}
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



"//".*\n                            { yylinecount++; }

"/*"                                { BEGIN(COMMENT); }
<COMMENT>"*/"                       { BEGIN(INITIAL); } /*should there be a sequence for closing comment without opening OR just let is appear as a syntax error by bison?*/
<COMMENT>\n                         { yylinecount++; }
<COMMENT>.                          ;
<COMMENT><<EOF>>                    { fprintf(stderr, "Unfinished comment at EOF\n"); exit(1); }


[A-Z][a-zA-Z0-9_]*                  { yylval.sval=strdup(yytext); return T_CIDENTIFIER; }
[a-zA-Z][a-zA-Z0-9_]*               { yylval.sval=strdup(yytext); return T_IDENTIFIER; }
[0-9]+                              { yylval.ival=atoi(yytext); return T_INT_V; }
[0-9]+\.[0-9]+d                     { temp_str=strdup(yytext);
                                      strncpy(temp_str,temp_str,(strlen(temp_str)-1));
                                      yylval.fval=atof(temp_str);
                                      return T_DOUBLE_V;
                                    }
\"([^\\\"]|\\.)*\"                  { temp_str=strdup(yytext); 
                                      strncpy(temp_str,temp_str+1,(strlen(temp_str)-2)); 
                                      yylval.sval=strdup(temp_str);
                                      return T_STRING_V;
                                    }
\'(\\[abfnrtv\\\'\"?]|\n|.)\'       { yylval.cval=convert_to_char(yytext);
                                     return T_CHAR_V;                                 
                                    }


[ \t]+                              ;
[\n\r]                              {yylinecount++;}
.                                   ;

%%

int yywrap() {
    return 1;
}
