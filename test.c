#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"
#include "quad.h"
	
int main(){
 
  struct symbol* tds = NULL;	
  struct quad* code = NULL;
  
  struct symbol* un = symbol_newtemp(&tds);
  un->value = 1;

  printf("Table des symboles\n");
  symbol_print(tds);
  printf("\nCode\n");
  quad_print(code);
  return 0;
}
