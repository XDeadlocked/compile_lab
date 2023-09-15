%{
#include <stdio.h>
%}

%option noyywrap

%%

"//"[^"\n"]*    { printf("Single Line Comment: %s\n", yytext); }
"/*"[^"*/"]*"*/" { printf("Multi-line Comment: %s\n", yytext); }
"#include"      { printf("Preprocessor Directive: %s\n", yytext); }
"<"[^">"]*">"   { printf("Header File: %s\n", yytext); }
"void"|"int"|"return" { printf("Keyword: %s\n", yytext); }
[a-zA-Z_][a-zA-Z_0-9]* { printf("Identifier: %s\n", yytext); }
[0-9]+          { printf("Number: %s\n", yytext); }
"\""([^"\\"]|\\(.|\n))*"\"" { printf("String: %s\n", yytext); }
"="|"+"|"-"|"*"|"/"|"("|")"|";"|","|"{"|"}" { printf("Operator or Punctuation: %s\n", yytext); }
[ \t\n]         { /* Ignore whitespace */ }
.               { printf("Unknown Character: %c\n", yytext[0]); }

%%

int main(void) {
    yylex();
    return 0;
}
