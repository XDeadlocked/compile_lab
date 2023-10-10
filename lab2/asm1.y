%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
int reg = 0;  // 使用一个简单的寄存器分配策略
%}

%token NUMBER
%token ADD MINUS
%token MUL DIV
%token left_paren right_paren

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%

lines   : lines expr ';' { printf("MOV r%d, r%d\n", reg-1, reg-1); }
        | lines ';'
        | 
        ;

expr    : expr ADD expr { 
            printf("ADD r%d, r%d, r%d\n", reg-2, reg-2, reg-1);
            reg--;
        }
        | expr MINUS expr { 
            printf("SUB r%d, r%d, r%d\n", reg-2, reg-2, reg-1);
            reg--;
        }
        | expr MUL expr { 
            printf("MUL r%d, r%d, r%d\n", reg-2, reg-2, reg-1);
            reg--;
        }
        | expr DIV expr { 
            printf("SDIV r%d, r%d, r%d\n", reg-2, reg-2, reg-1);
            reg--;
        }
        | left_paren expr right_paren
        | MINUS expr %prec UMINUS { 
            printf("NEG r%d, r%d\n", reg-1, reg-1);
        }
        | NUMBER { 
            printf("MOV r%d, #%d\n", reg, (int)yylval);
            reg++;
        }
        ;

%%

int yylex() {
        int t;
    double tokenval = 0.0;
    while(1){
        t=getchar();
        if(t==' ' || t=='\t' || t=='\n'){
            // do nothing
        } else if(isdigit(t)){
            tokenval = t - '0';
            while(isdigit(t=getchar())){
                tokenval = tokenval*10 + t - '0';
            }
            // 将多读取出的一个字符放回输入流
            ungetc(t, stdin);
            yylval = tokenval;
            return NUMBER;
            
        } else if(t == '+'){
            return ADD;
        } else if(t == '-'){
            return MINUS;
        } else if(t == '*'){
            return MUL;
        } else if(t == '/'){   
            return DIV;
        } else if(t == '('){   
            return left_paren; 
        } else if(t == ')'){
            return right_paren;
        } else{
            return t;
        }
    }
}

int main(void) {
    yyin = stdin;
    printf("@ Start of ARMv7 assembly code\n");
    do{
        yyparse();
    } while(!feof(yyin));
    printf("@ End of ARMv7 assembly code\n");
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

