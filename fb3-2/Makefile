all: fb3_2

fb3_2: fb3_2.l fb3_2.y fb3_2func.c
	bison -d fb3_2.y
	flex fb3_2.l
	gcc -o fb3_2 fb3_2.tab.c lex.yy.c fb3_2func.c -lm

clean:
	rm -f fb3_2 fb3_2.tab.c fb3_2.tab.h lex.yy.c

.PHONY: all clean
