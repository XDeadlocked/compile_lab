%option noyywrap
%option nounput
%option noinput
%top{
    #include <stdarg.h>
    #include<stack>
    #include <iostream>
    #include "common.h"
    using namespace std;
    #define MMAX 200
    struct Table{
        int index;
        char* name;
    };
    int qqq=0;
    int flag_if=0;
    int flag_while=0;
    void init_hashTable(Table* hT);
    int chk=1;
    int line = 0;
    int column = 0;
    int isdigit(char s);
    int wasdigit(const char* s1);
    int SW(const char* y,const char* str);
    int plusplus(const char* y,const char* str);
    
    struct SymbolTable {
        int offset;
        struct Table hT[MMAX];
    };
    int cnt=0;
    struct SymbolTable ALL;
    std::stack<SymbolTable> scopeStack;
    void enterNewScope() {
        SymbolTable newTable;
        newTable.offset = cnt;
        cnt++;
        init_hashTable(newTable.hT);
        scopeStack.push(newTable);
        cout<<111111<<endl;
    }
    void leaveScope() {
        if(!scopeStack.empty()) {
            scopeStack.pop();
        }
    }
    int init();
    int get_index(char* text,int length);
    int a = init();
    void j(char* text);
}
%{
    extern dump_type_t dump_type;
    
    inline void dump_tokens(const char* format, ...){
        va_list args;
        va_start(args, format);
        if (dump_type == TOKENS)
            vfprintf(yyout, format, args);
        va_end(args);
    }

    /* Your code here, if desired (lab3). */
%}

/* definitions section */
C //.*
HEX 0x([0-9a-fA-F]+)
OCT 0([0-7])|([1-7][0-7]*)
DECIMAL ([1-9][0-9]*|0)
FRACTION {DECIMAL}"."{DECIMAL}
DEFINE #define[^\n]*
PLUS {DECIMAL}|{ID}{WHITE}?\+
MINUS {DECIMAL}|{ID}{WHITE}?\-
MULT {DECIMAL}|{ID}{WHITE}?\*
Cbegin "/*"
Celement .|\n
Cend   "*/"
ID [[:alpha:]_][[:alpha:][:digit:]_]*
WHITE [\t ]
%x COMMENT
/*  Your code here (lab3). */

%%
    /* rules section */
\n {
    line++;
    column = 0;
}

{C} {

}
{Cbegin}   {
    dump_tokens("CBEGIN\t%d",line);
    BEGIN COMMENT;
}
<COMMENT>{Celement} {

}
<COMMENT>{Cend} {
    BEGIN INITIAL;
}
{DEFINE} {
    dump_tokens("DEFINE\t%s\t%d",yytext,line);
}
{PLUS} {SW(yytext,"PLUS");}
{MINUS} {SW(yytext,"MINUS");}
{MULT} {SW(yytext,"MULT");}
{BITAND} {SW(yytext,"BITAND");}
"int" {
    dump_tokens("INT\t%s\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
    qqq = 1;
}

"double" {
    dump_tokens("DOUBLE\t%s\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
    qqq = 1;
}

"float" {
    dump_tokens("FLOAT\t%s\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
    qqq = 1;
}

"void" {
    dump_tokens("VOID\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
    qqq =  1;
}

"if" {
    dump_tokens("IF\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;

}

"else" {
    dump_tokens("ELSE\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}

"return" {
    dump_tokens("RETURN\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}
"+" {
    dump_tokens("ADD\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}
"=" {
    dump_tokens("ASSIGN\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}

"<" {
    dump_tokens("LESS\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}

";" {
    dump_tokens("SEMICOLON\t%s\t%d\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
    qqq=0;
}

"(" {
    dump_tokens("LPAREN\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}

")" {
    dump_tokens("RPAREN\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}

"{" {
    SymbolTable newTable;
    newTable.offset = cnt;
    cnt++;
    //cout<<111111111111111<<endl;
    init_hashTable(newTable.hT);
    scopeStack.push(newTable);
    //cout<<"curr_size"<<scopeStack.size()<<endl;
    dump_tokens("LBRACE\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}

"}" {
    leaveScope();
    dump_tokens("RBRACE\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}
{HEX} {
    dump_tokens("HEX\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}
{OCT} {
    dump_tokens("OCT\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}
{DECIMAL} {
    dump_tokens("DECIMAL\t%s\t%d\t%d\n", yytext, line, column);
    column+=yyleng;
}

{FRACTION} {
    dump_tokens("FRACTION\t%s\t%d\t%d\t%d\n", yytext, line, column, 0);
    column+=yyleng;
}

{ID} {
    int p = get_index(yytext,yyleng);
    dump_tokens("ID\t%s\t%d\t%d\t0x%d\n", yytext, line, column, p);
    column+=yyleng;
    //cout<<cnt<<endl;
}

{WHITE} column++;

    /*  Your code here (lab3). */
%%
/* user code section */
/* user code section */
void init_hashTable(Table* hT){
    for(int i = 0;i<MMAX;i++){
        hT[i].name = new char[20];
        strcpy(hT[i].name,"0");
        hT[i].index = 0;
    }
};
int init(){
    init_hashTable(ALL.hT);
    ALL.offset = 0;
    scopeStack.push(ALL);
    return 1;
}
void j(char* str){
    if(str[0]=='\n'){
        ++line;
    }
};
int isdigit(char s){
    if('0'<=s&&s<='9') return 1;
    return 0;
}
int get_index(char* text,int length){
    std::stack<SymbolTable> tmp = scopeStack;
    SymbolTable h = scopeStack.top();
    int hash = 0;
    for(int i = 0;i<length;i++){
        hash += (text[i] - 'A' + 1) * (i + 1);
    }
    hash %= MMAX;
    while(!tmp.empty()){
        if(qqq==1){
            break;
        }
        SymbolTable& hashTable = tmp.top();
        for(int i=0;i<MMAX;i++){
            if(strcmp(hashTable.hT[i].name,text)==0) 
            return i + tmp.size()*200;
        }
        tmp.pop();
    }
    cout<<"size"<<scopeStack.size()<<endl;
    while(1){
        if(strcmp(h.hT[hash].name,"0")==0){
            strcpy(h.hT[hash].name,text);
            cout<<"offset"<<h.offset<<endl;
            return hash+tmp.size()*200;
        }
        else{
            if(strcmp(h.hT[hash].name,text)==0){
                return hash+tmp.size()*200;
            }
            else{
                hash=(hash+1)%200;
            }
        }
    }
};
int wasdigit(const char* s1) {
    int len=strlen(s1);
    int t=0;
    for(int i=0;i<len;++i) { 
        if(!isdigit(*(s1+i))&&*(s1+i)!='.')
            return 0;
        if(*(s1+i)=='.')
            ++t;
        if(*(s1+i+1)=='.') {
            ++t;
            ++i;
            if(t>1)
              return 0;
        }
    }
    return 1;
}

