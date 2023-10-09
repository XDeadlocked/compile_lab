.arch armv7-a
.arm

.text
.global main
.type main, %function
main:
    push {fp, lr}
    sub sp, sp, #4
    ldr r0, =_cin
    mov r1, sp
    bl scanf
    ldr r6, [sp]
    add sp, sp, #4

    mov r4, #0
    mov r5, #1
    mov r7, #1

Loop:
    cmp r6, r7
    ble RETURN
    mov r8, r5
    add r5, r5, r4
    ldr r0, =_bridge2
    mov r1, r4
    bl printf
    mov r4, r8
    add r7, r7, #1
    b Loop

RETURN:
    pop {fp, lr}
    bx lr

.data
_cin:
    .asciz "%d"

_bridge2:
    .asciz "Res:%d\n"
