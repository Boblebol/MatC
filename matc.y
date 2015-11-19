%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"
#include "quad.h"
  
  int yylex();
  int yyerror(char *);
  
  struct symbol* tds = NULL;
  struct quad* code = NULL;
%}

%union {
  int value;
  char op;
  char* string;
  struct {
    struct symbol *result;
    struct quad* code;
  } codegen;
}

%token <string>  INCR DECR 
%token <op> ADD SUB MUL DIV OPE CLO
%token <string> ID
%token <value> NUMBER
%type <codegen> expr

%left INCR DECR
%left ADD SUB
%left MUL DIV

%%

axiom :
expr '\n'       { printf("Match !!!\n"); code = $1.code;}
;

expr :
expr ADD expr   
  {   
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, $3.code);
    quad_add(&$$.code, quad_gen('+',$1.result, $3.result, $$.result));
  }
| expr SUB expr   
  {   
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, $3.code);
    quad_add(&$$.code, quad_gen('-',$1.result, $3.result, $$.result));
  }
| expr MUL expr   
  {   
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, $3.code);
    quad_add(&$$.code, quad_gen('*',$1.result, $3.result, $$.result));
  }
| expr DIV expr   
  {   
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, $3.code);
    quad_add(&$$.code, quad_gen('/',$1.result, $3.result, $$.result));
  }
| expr INCR  
  {   
    struct symbol* un = symbol_newtemp(&tds);
    un->value = 1;
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, quad_gen('+',$1.result, un, $$.result));
  }
| expr DECR 
  {   
    struct symbol* un = symbol_newtemp(&tds);
    un->value = 1;
    $$.result = symbol_newtemp(&tds);
    $$.code = $1.code;
    quad_add(&$$.code, quad_gen('-',$1.result, un, $$.result));
  }
| OPE expr CLO    
  {   
    $$.result = $2.result;
    $$.code = $2.code;
  }
| ID              
  {   
    $$.result = symbol_add(&tds, $1);
    $$.code = NULL;
  }
| NUMBER          
  {   
    $$.result = symbol_newtemp(&tds);
    $$.result->value = $1;
    $$.code = NULL;
  }
;
%%

int main(){
  printf("Entrez une expression\n");
  yyparse();
  printf("Table des symboles\n");
  symbol_print(tds);
  printf("\nCode\n");
  quad_print(code);
  return 0;
}
