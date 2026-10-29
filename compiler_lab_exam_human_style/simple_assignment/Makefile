all: compiler optimizer backend

y.tab.c y.tab.h: parser.y
	yacc -d parser.y

lex.yy.c: lexer.l y.tab.h
	lex lexer.l

compiler: y.tab.c lex.yy.c
	gcc -w y.tab.c lex.yy.c -o compiler

optimizer: optimizer.c
	gcc optimizer.c -o optimizer

backend: backend.c
	gcc backend.c -o backend

clean:
	rm -f compiler optimizer backend y.tab.c y.tab.h lex.yy.c tac.txt optimized.txt target.txt

.PHONY: all clean
