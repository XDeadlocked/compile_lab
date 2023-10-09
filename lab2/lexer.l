%{
#include "y.tab.h"
%}

%%

[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[-+*/()]    { return yytext[0]; }
[ \t\n]     ;  // 忽略空白字符

.           { fprintf(stderr, "无法识别的字符: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
