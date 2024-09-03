%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *temp_str;
int temp_str_len;

int yylex(void);
%}

%%
<<EOF>> {
    return 0;
}



[0-9]+                              { printf("Integer: %d\n",atoi(yytext)); }
[0-9]+\.[0-9]+d                     { temp_str_len=strlen(yytext);
                                      temp_str=(char *)malloc((temp_str_len-1)*sizeof(char)); 
                                      strncopy(temp_str,yytext,(temp_str_len-1));
                                      printf("Double: %f\n",atof(temp_str));
                                    }
\"([^\\\"]|\\.)*\"                  { temp_str_len=strlen(yytext);
                                      temp_str=(char *)malloc((temp_str_len-2)*sizeof(char)); 
                                      strncopy(temp_str,yytext+1,(temp_str_len-2)); }

\" "        ;
[ \t\n]+    ;
.           ;

%%

int main(void) {
    /* Continuously call yylex() to process input until terminated by Ctrl+C */
    while (1) {
        yylex();
    }

    return 0;
}
