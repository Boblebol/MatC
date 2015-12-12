%{
#include <stdio.h>
#include <stdlib.h>
#include "quad.h"
#include "symbol.h"

extern FILE *yyin;
int yyerror();
int yylex();

struct symbol* tds = NULL;
struct quad* code = NULL;

%}

%union {
    int integer;
    char* string;
    char* mot_cle;
    float flo;
    char character;
	struct {
        struct symbol* result;
        struct quad* code;
    } codegen;
}

%token 	<integer> CSTINT
%token 	<flo> CSTFLO
%token 	<string> ID
%token	<codegen> INT FLOAT MATRIX STRING
%token 	<codegen> PLUS MINUS MULT DIV
%token	<codegen> PRINTF PRINTMAT RETURN
%token 	<codegen> STARTEXTR ENDEXTR MAIN 
%token 	<codegen> ENDINST AFFECT STARTEXPR ENDEXPR STARTBLCK ENDBLCK
%type 	<codegen> listinst inst decl affect
%type 	<codegen> cst expr

%right AFFECT
%left PLUS MINUS
%left MULT DIV
%left INCR DECR
%left UNARY

%%

axiom	:	INT MAIN STARTEXPR ENDEXPR STARTBLCK listinst ENDBLCK  		
				{ 	
					printf("\nProgramme CORRECT !!!\n");
					printf("\n\nTable des symboles\n");
					symbol_print(tds);
					printf("\n\nListe des Quads\n");
					quad_print(code);
				}
	   	;


listinst	:   inst ENDINST
        	|   inst ENDINST listinst
        	;


inst    :   decl	
        |   affect
        |   RETURN expr
        ;


decl    :   INT ID	
				{ 
					printf("Match : declaration %s!!\n",$2);	
					if 	(symbol_lookup(tds,$2) == NULL) {				
						$$.result = symbol_add(&tds,$2);
            			$$.result->stype = SYMBOL_INT;
            			$$.code = NULL;
					} 				
				}
		|	FLOAT ID
				{ 
					if 	(symbol_lookup(tds,$2) == NULL) {				
						$$.result = symbol_add(&tds,$2);
            			$$.result->stype = SYMBOL_FLOAT;
            			$$.code = NULL;
					} 						
				}
        ;


affect  :   ID AFFECT expr	
				{ 
					printf("Match : affectation !!\n");
					if 	(symbol_lookup(tds,$1) != NULL) {
						$$.result = symbol_lookup(tds,$1);
						struct symbol* scan = $$.result;
						while (scan->next != NULL) {
           					scan = scan->next;
        				}
						if (scan->stype == $$.result->stype) {
							if ($$.result->stype == SYMBOL_INT ) {						
								$$.result->v.int_val = scan->v.int_val;
							}
							if ($$.result->stype == SYMBOL_FLOAT ) {						
								$$.result->v.float_val = scan->v.float_val;
							}
						}
					}
					$$.code = NULL;
				}
        ;


expr    :   expr PLUS expr	
				{ 
					printf("Match : addition !!\n");
					$$.result = symbol_newtemp(&tds);
					if ($1.result->stype == $3.result->stype) {
						if ($1.result->stype == SYMBOL_INT ) {						
							$$.result->v.int_val = $1.result->v.int_val + $3.result->v.int_val;
						}
						if ($1.result->stype == SYMBOL_FLOAT ) {						
							$$.result->v.float_val = $2.result->v.float_val + $3.result->v.int_val;
						}
					}
                    $$.code = $1.code;
                    quad_add(&code, $3.code);
                    quad_add(&code, quad_gen("+", $1.result, $3.result, $$.result));
				}
        |   expr MINUS expr	
				{ 
					printf("Match : soustraction !!\n");
					$$.result = symbol_newtemp(&tds);
					if ($1.result->stype == $3.result->stype) {
						if ($1.result->stype == SYMBOL_INT ) {						
							$$.result->v.int_val = $1.result->v.int_val - $3.result->v.int_val;
						}
						if ($1.result->stype == SYMBOL_FLOAT ) {						
							$$.result->v.float_val = $2.result->v.float_val - $3.result->v.int_val;
						}
					}
                    $$.code = $1.code;
                    quad_add(&code, $3.code);
                    quad_add(&code, quad_gen("-", $1.result, $3.result, $$.result));
				}
        |   expr MULT expr	
				{ 
					printf("Match : multiplication !!\n");
					$$.result = symbol_newtemp(&tds);
					if ($1.result->stype == $3.result->stype) {
						if ($1.result->stype == SYMBOL_INT ) {						
							$$.result->v.int_val = $1.result->v.int_val * $3.result->v.int_val;
						}
						if ($1.result->stype == SYMBOL_FLOAT ) {						
							$$.result->v.float_val = $2.result->v.float_val * $3.result->v.int_val;
						}
					}
                    $$.code = $1.code;
                    quad_add(&code, $3.code);
                    quad_add(&code, quad_gen("*", $1.result, $3.result, $$.result));
				}
        |   expr DIV expr	
				{ 
					printf("Match : multiplication !!\n");
					$$.result = symbol_newtemp(&tds);
					if ($1.result->stype == $3.result->stype) {
						if ($1.result->stype == SYMBOL_INT ) {						
							$$.result->v.int_val = $1.result->v.int_val / $3.result->v.int_val;
						}
						if ($1.result->stype == SYMBOL_FLOAT ) {						
							$$.result->v.float_val = $2.result->v.float_val / $3.result->v.int_val;
						}
					}
                    $$.code = $1.code;
                    quad_add(&code, $3.code);
                    quad_add(&code, quad_gen("/", $1.result, $3.result, $$.result));				
				}
        |   STARTEXPR expr ENDEXPR	
				{ 
					printf("Match : () expression !!\n");
					$$.result = $2.result;
                    $$.code = $2.code;
				}
        |   MINUS expr                  %prec UNARY	
				{ 
					printf("Match : - unaire !!\n");
					$$.result = symbol_newtemp(&tds);
					if ($2.result->stype == SYMBOL_INT ) {						
						$$.result->v.int_val = 0 - $2.result->v.int_val;
					}
					if ($2.result->stype == SYMBOL_FLOAT ) {						
						$$.result->v.float_val = 0 - $2.result->v.int_val;
					}
				}
        |   ID	
				{
					if 	(symbol_lookup(tds,$1) != NULL) {				
						$$.result = symbol_lookup(tds,$1);
					} 
					$$.code = NULL;
				}
        |   cst
        ;


cst     :   CSTINT 
				{
					printf ("Match : constante entiere %d",$1);
            		$$.result = symbol_newtemp(&tds);
            		$$.result->v.int_val = $1;
            		$$.result->stype = SYMBOL_INT;
            		$$.code = NULL;
					printf ("	:	ajoutée dans la TDS\n");
					
        		}
        |   CSTFLO 
				{
					printf ("Match constante flottante %f",$1);
            		$$.result = symbol_newtemp(&tds);
            		$$.result->v.float_val = $1;
            		$$.result->stype = SYMBOL_FLOAT;
            		$$.code = NULL;
					printf ("	:	ajoutée dans la TDS\n");
		        }
        ;


%%
int main(int argc, char *argv[]) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }
  return 0;
}
