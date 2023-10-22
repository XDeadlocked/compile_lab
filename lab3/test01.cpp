#include  <stdio.h>
/*
    A-Z, 0-9, a-z   构成了部分模式的字符和数字。
    .               匹配任意字符，除了 \n。
    -               用来指定范围。例如：A-Z 指从 A 到 Z 之间的所有字符。
    [ ]             一个字符集合。匹配括号内的 任意 字符。如果第一个字符是 ^ 那么它表示否定模式。
                    例如: [abC] 匹配 a, b, 和 C中的任何一个。
    *               匹配 0个或者多个上述的模式。
    +               匹配 1个或者多个上述模式。
    ?               匹配 0个或1个上述模式。
    $               作为模式的最后一个字符匹配一行的结尾。
    { }             指出一个模式可能出现的次数。 例如: A{1,3} 表示 A 可能出现1次或3次。
    \               用来转义元字符。同样用来覆盖字符在此表中定义的特殊意义，只取字符的本意。
    ^               否定。
    |               表达式间的逻辑或。
    "<一些符号>"     字符的字面含义。元字符具有。
    /               向前匹配。如果在匹配的模版中的“/”后跟有后续表达式，只匹配模版中“/”前 面的部分。
                    如：如果输入 A01，那么在模版 A0/1 中的 A0 是匹配的。
    ( )             将一系列常规表达式分组。
*/

// 宏定义
#define INITIAL_A 0
#define INITIAL_B 1

// 全局变量
int a = INITIAL_A;
int b = INITIAL_B;
int i = 0;
// 函数原型声明
void print_fibonacci_sequence(int n);

int main(){
    double i;
    int n;
    i = 0.13;
    
    // 从用户处获取输入
    printf("请输入斐波那契数列的项数：");
    scanf("%d", &n);

    // 调用函数来打印斐波那契数列
    print_fibonacci_sequence(n);

    return 0;
}

// 函数定义
void print_fibonacci_sequence(int n){
    int t;

    // 打印斐波那契数列的前两项
    printf("%d\n%d\n", a, b);

    // 计算和打印斐波那契数列的其余项
    while(i < n){
        t = b;
        b = a + b;
        printf("%d\n", b);
        a = t;
        i += 1;
        i = i + 1;
    }
}
