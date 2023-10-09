%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE

#define YYSTYPE double
#endif
//作为词法分析程序的接口
int yylex();
//依次获取token
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
lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
//下面完善表达式的规则 
expr    :       expr ADD expr {
                                printf("ADD\n");
                                $$=$1+$3;
                              }
        |       expr MINUS expr {
                                printf("SUB\n");
                                $$=$1-$3;
                              }
        |       expr MUL expr {
                                printf("MUL\n");
                                $$=$1*$3;
                              }
        |       expr DIV expr {
                                printf("DIV\n");
                                $$=$1/$3;
                              }
        |       left_paren expr right_paren {$$=$2;} 
        |       MINUS expr %prec UMINUS {
                                printf("NEG\n");
                                $$=-$2;
                              }
        |       NUMBER {
                                printf("PUSH %f\n", $1);
                                $$=$1;
                              }
        ;

        
%%

// programs section

int yylex()
{
    int t;
    double tokenval=0.0;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do nothing
        }else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            tokenval=t-'0';
            while(isdigit(t=getchar())){
                tokenval=tokenval*10+t-'0';
            }
            //将多读取出的一个字符放回输入流
            ungetc(t,stdin);
            //将值返回终结符NUMBER中
            yylval=tokenval;
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
