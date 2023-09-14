
main.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	f3 0f 1e fa          	endbr64 
   4:	55                   	push   %rbp
   5:	48 89 e5             	mov    %rsp,%rbp
   8:	48 83 ec 20          	sub    $0x20,%rsp
   c:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
  13:	00 00 
  15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  19:	31 c0                	xor    %eax,%eax
  1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  22:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  29:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%rbp)
  30:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
  34:	48 89 c6             	mov    %rax,%rsi
  37:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 3e <main+0x3e>
  3e:	48 89 c7             	mov    %rax,%rdi
  41:	b8 00 00 00 00       	mov    $0x0,%eax
  46:	e8 00 00 00 00       	call   4b <main+0x4b>
  4b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  4e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  51:	89 c6                	mov    %eax,%esi
  53:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 5a <main+0x5a>
  5a:	48 89 c7             	mov    %rax,%rdi
  5d:	b8 00 00 00 00       	mov    $0x0,%eax
  62:	e8 00 00 00 00       	call   67 <main+0x67>
  67:	eb 2f                	jmp    98 <main+0x98>
  69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  6c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  6f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  72:	01 45 ec             	add    %eax,-0x14(%rbp)
  75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  78:	89 c6                	mov    %eax,%esi
  7a:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 81 <main+0x81>
  81:	48 89 c7             	mov    %rax,%rdi
  84:	b8 00 00 00 00       	mov    $0x0,%eax
  89:	e8 00 00 00 00       	call   8e <main+0x8e>
  8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  91:	89 45 e8             	mov    %eax,-0x18(%rbp)
  94:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  98:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  9b:	39 45 f0             	cmp    %eax,-0x10(%rbp)
  9e:	7c c9                	jl     69 <main+0x69>
  a0:	b8 00 00 00 00       	mov    $0x0,%eax
  a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  a9:	64 48 2b 14 25 28 00 	sub    %fs:0x28,%rdx
  b0:	00 00 
  b2:	74 05                	je     b9 <main+0xb9>
  b4:	e8 00 00 00 00       	call   b9 <main+0xb9>
  b9:	c9                   	leave  
  ba:	c3                   	ret    
