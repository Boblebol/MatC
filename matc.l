%option nounput
%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

%}

identifier  [a-zA-Z_]+[0-9a-zA-Z_]*
number      [0-9]+

%%

{identifier}  	{ yylval.string = strdup(yytext); return ID; }
{number}      	{ yylval.value = atoi(yytext); return NUMBER; }

'\+'			{return ADD;}
'-'				{return SUB;}
'*'				{return MUL;}
'\/'			{return DIV;}

'\÷\+'			{return INCR;}
'\-\-'			{return DECR;}

'\)'			{return CLO;}
'\('			{return OPE;}

[()+*]        	{return yytext[0] ;}
[\n]          	{return yytext[0] ;}
.             	{printf("caractère inconnu %s",yytext) ;}

%%
