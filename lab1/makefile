.PHONY: pre, lexer, ast-gcc, ast-llvm, cfg, ir-gcc, ir-llvm, asm, obj, exe, antiobj, antiexe
pre: 
	gcc main.c -E -o main.i

lexer: 
	clang -E -Xclang -dump-tokens main.c 2> lexer.txt

lexer1: 
	clang -E -Xclang -dump-tokens main1.c 2> lexer1.txt

ast-gcc: 
	gcc -fdump-tree-original-raw main1.c 

ast-llvm: 
	clang -E -Xclang -ast-dump main1.c

cfg: 
	gcc -O0 -fdump-tree-all-graph main1.c

cfg1: 
	gcc -O1 -fdump-tree-all-graph main1.c

ir-gcc: 
	gcc -O0 -fdump-rtl-all-graph main.c

ir-llvm: 
	clang -S -emit-llvm main.c

ir-llvm1: 
	clang -S -emit-llvm main1.c

pass-llvm:
	llc -print-before-all -print-after-all main.ll > main.log 2>&1

pass-llvm1:
	llc -print-before-all -print-after-all main1.ll > main1.log 2>&1

asm: 
	gcc -O0 -o main.S -S -masm=att main.i

obj: 
	gcc -O0 -c -o main.o main.S

antiobj: 
	objdump -d main.o > main-anti-obj.S
	nm main.o > main-nm-obj.txt

exe: 
	gcc -O0 -o main main.o

antiexe: 
	objdump -d main > main-anti-exe.S
	nm main > main-nm-exe.txt

clean: 
	rm -rf *.c.*

clean-all: 
	rm -rf *.c.* *.o *.S *.dot *.out *.txt *.ll *.i main  

stack-safety:
	opt -stack-safety-local main1.bc -o main1_anay.bc

cgp:
	opt -codegenprepare main1.bc -o main1_anay_cgp.bc

dal:
	opt -codegenprepare main1.bc -o main1_anay_dal.bc
