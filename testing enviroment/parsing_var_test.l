%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parsing_var_test.tab.h"


extern YYSTYPE yylval;

extern int yylinecount;

%}


%%
<<EOF>>                             { return 0; }

[0-9]+\.[0-9]                       { yylval.fval=atof(yytext); return T_FLOAT;}
[0-9]+                              { yylval.ival=atoi(yytext); return T_INT; }

EXIT                                {return T_EXIT; }

[ \t]+                              ;
[\n\r]                              {yylinecount++;}
.                                   ;

%%

int yywrap() {
    return 1;  // Indicate end of input
}   