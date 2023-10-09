%{
/*********************************************
中缀转后缀表达式
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#ifndef YYSTYPE
//用于确定$$的类型:char*
#define YYSTYPE char*
#endif
//作为词法分析程序的接口
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

%}
//TODO:给每个符号定义一个单词类别
%token NUMBER
%token ADD MINUS
%token MUL DIV
%token left_paren right_paren

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%


//以分号为分隔符
lines   :       lines expr ';' { printf("%s\n", $2);free($2); }
        |       lines ';'
        |
        ;
//完善规则:先开辟空间，再拷贝字符串，最后加上运算符(后续表达式的顺序),
expr    :       expr ADD expr {$$ = (char*)malloc(strlen($1)+strlen($2)+strlen($3)+1);strcpy($$,$1),strcat($$,$3),strcat($$,"+");free($1),free($3);}
        |       expr MINUS expr {$$ = (char*)malloc(strlen($1)+strlen($2)+strlen($3)+1);strcpy($$,$1),strcat($$,$3),strcat($$,"-");free($1),free($3);}
        |       expr MUL expr {$$ = (char*)malloc(strlen($1)+strlen($2)+strlen($3)+1);strcpy($$,$1),strcat($$,$3),strcat($$,"*");free($1),free($3);}
        |       expr DIV expr {$$ = (char*)malloc(strlen($1)+strlen($2)+strlen($3)+1);strcpy($$,$1),strcat($$,$3),strcat($$,"/");free($1),free($3);}
        |       left_paren expr right_paren {$$=$2;} 
        |       MINUS expr %prec UMINUS {$$ = (char*)malloc(strlen($1)+strlen($2)+1);strcpy($$,"-"),strcat($$,$2);free($2);}
        |       NUMBER {$$ = (char*)malloc(strlen($1)+1);strcpy($$,$1);free($1);}
        ;

        
%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(t>='0' && t<='9'){
            char* num_str=(char*)malloc(100*sizeof(char));
            int count=0;
            num_str[count++]=t;
            while((t=getchar())>='0' && t<='9'){
            //完善多位整数的识别
                num_str[count++]=t;
            }
            //末尾加上空格与结束符
            num_str[count++]=' ';
            num_str[count]='\0';
            //将多读的字符退回到输入流中
            ungetc(t,stdin);
            //赋值给yylval,当NUMBER被识别时，yylval中保存了NUMBER的值
            yylval=num_str;
            return NUMBER;
            
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }else if(t=='*'){
            return MUL;
        }else if(t=='/'){   
            return DIV;
        }else if(t=='('){   
            return left_paren; 
        }else if(t==')'){
            return right_paren;
        }else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}