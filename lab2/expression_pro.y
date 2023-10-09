%{
/*********************************************
可识别变量并计算表达式的值
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#define NSYMS 30//符号表的大小
struct symtab{
    char* name;
    double value;
}symtab[NSYMS];//定义符号表

//作为词法分析程序的接口
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

%}
//yylval可能的类型
%union{
    double dval;//数字所用的类型
    struct symtab* sym;//标识符所用的类型
}
//定义终结符
%token <dval> NUMBER//数字
%token ADD MINUS
%token MUL DIV
%token left_paren right_paren
%token EQUAL
%token <sym> ID//标识符

%right EQUAL
%left ADD MINUS
%left MUL DIV
%right UMINUS

//定义非终结符
%type <dval> expr
%%

//以分号为分隔符
lines   :       lines expr ';' { printf("%f\n",$2);}
        |       lines ';'
        |
        ;

expr    :       expr ADD expr {$$=$1+$3;}
        |       expr MINUS expr {$$=$1-$3;}
        |       expr MUL expr {$$=$1*$3;}
        |       expr DIV expr {$$=$1/$3;}
        |       left_paren expr right_paren {$$=$2;} 
        |       MINUS expr %prec UMINUS {$$=-$2;}//提升优先级
        |       NUMBER {$$=$1;}
        |       ID {$$=$1->value;}//当标识符的name被识别时，读取符号表中的value
        |       ID EQUAL expr {$1->value=$3;$$=$3;}//出现赋值语句时，先将标识符的value赋值存入符号表，再将value返回给expr

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
            //do noting
        }else if(t>='0' && t<='9'){//识别数字
            tokenval=t-'0';
            while((t=getchar())>='0' && t<='9'){
                tokenval=tokenval*10+t-'0';
            }
            ungetc(t,stdin);
            yylval.dval=tokenval;//将识别到的数字存入yylval
            return NUMBER;
            
        }else if ((t>='a'&& t<='z')||(t>='A'&& t<='Z')||t=='_'){//识别标识符
            char* p=malloc(sizeof(char)*21);//限制最长标识符长度为20
            int i=0;
            p[i++]=t;
            //标识符后续可以包含数字
            while((t=getchar())>='a'&& t<='z'||(t>='A'&& t<='Z')||t=='_'||(t>='0' && t<='9')){
                p[i++]=t;
            }
            ungetc(t,stdin);
            p[i]='\0';
            //遍历符号表，若符号表中已有该标识符，则返回该标识符的地址，否则将该标识符存入符号表
            for(int j=0;j<NSYMS;j++){
                if(symtab[j].name==NULL){
                    symtab[j].name=p;//将识别到的标识符存入符号表
                    yylval.sym=&symtab[j];//将符号表该项的地址存入yylval
                    return ID;
                }else if(strcmp(symtab[j].name,p)==0){//如果已经存在该标识符
                    yylval.sym=&symtab[j];//将符号表该项的地址存入yylval
                    return ID;
                }
            }
            //若走出循环，则表示符号表已满
            fprintf(stderr,"too many variables\n");
            exit(1);
        }else if(t=='='){
            return EQUAL;
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