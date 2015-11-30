prefixe=matc

all: $(prefixe).y $(prefixe).l
	yacc -d $(prefixe).y
	flex $(prefixe).l
	gcc y.tab.c lex.yy.c -ly -lfl -o matc.o

clean:
	rm *.o y.tab.c lex.yy.c y.tab.h matc.o
