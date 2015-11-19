prefixe=matc

all: $(prefixe).y $(prefixe).l
	yacc -d $(prefixe).y
	flex $(prefixe).l
	gcc -ly y.tab.c lex.yy.c 

clean:
	rm *.o y.tab.c lex.yy.c y.tab.h *~
