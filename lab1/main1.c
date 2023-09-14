#include <stdio.h>

// 宏定义
#define INITIAL_A 0
#define INITIAL_B 1

// 全局变量
int a = INITIAL_A;
int b = INITIAL_B;

// 函数原型声明
void print_fibonacci_sequence(int n);

int main(){
    int n, i = 1;
    
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
    }
}
