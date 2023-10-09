.arch armv7-a
.fpu vfpv3-d16

.data
.align 1
pi:
    .float 3.14
D:
    .float 2.5
four:
    .float 4.0
three:
    .float 3.0
two:
    .float 2.0

volume_format:
    .asciz "volume: %.2f\n"

.text
.align 1
.global main
.type main, %function

main:
    @ 保存返回地址
    push {fp, lr}
    
    @ 加载pi和D的值
    ldr r0, =pi
    ldr r1, =D
    vldr.32 s0, [r0]   @ 将pi加载到s0
    vldr.32 s1, [r1]   @ 将D加载到s1
    
    @ 计算 r = D/2
    ldr r0, =two
    vldr.32 s2, [r0]
    vdiv.f32 s3, s1, s2
    
    @ 计算球体体积
    vmul.f32 s4, s3, s3   @ 计算 r*r
    vmul.f32 s4, s4, s3   @ 计算 r*r*r
    vmul.f32 s4, s4, s0   @ 计算 pi*r*r*r
    ldr r0, =four
    vldr.32 s5, [r0]
    vdiv.f32 s4, s4, s5   @ 计算 (pi*r*r*r)/4
    ldr r0, =three
    vldr.32 s6, [r0]
    vmul.f32 s4, s4, s6   @ 计算 (4/3)*(pi*r*r*r)
    
    @ 输出球体体积
    ldr r0, =volume_format   @ 准备printf的参数r0
    vcvt.f64.f32 d7, s4
    vmov r2, r3, d7
    bl printf

    mov r0, #0   @ 设置返回值为0
    
    @ 恢复堆栈并返回
    pop {fp, pc}

@ 函数原型
.extern printf

.section .note.GNU-stack,"",%progbits
