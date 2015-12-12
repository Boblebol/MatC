%{
    #include <stdio.h>
	#include "y.tab.h"
%}

array       \[[1-9][0-9]*\]
id          [a-zA-Z_][a-zA-Z0-9_]*
cstint      [0-9]+
cstflo      [0-9]+"."[0-9]+(E[+-][0-9]+)?
string      \"(\\.|[^\\\"])*\"
com         (\/\*+([^*](\*[^\/])?)*\*+\/)|(\/\/.*\n)
endl        [\n]
blank       [[:blank:]]

%%
"main"                  { return MAIN; }
"int"                   { return INT; }
"float"                 { return FLOAT; }
"if"                    { return IF; }
"while"                 { return WHILE; }
"return"                { return RETURN; }
"++"                    { return INCR; }
"--"                    { return DECR; }
"<="                    { return LEQ; }
">="                    { return GEQ; }
"=="                    { return EQ; }
"!="                    { return NEQ; }
"&&"                    { return AND; }
"||"                    { return OR; }
".."                    { return PTPT; }
"<"                     { return LT; }
">"                     { return GT;}
","                     { return LISTSEP; }
";"                     { return ENDINST; }
"="                     { return AFFECT; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MULT; }
"/"                     { return DIV; }
"("                     { return STARTEXPR; }
")"                     { return ENDEXPR; }
"{"                     { return STARTBLCK; }
"}"                     { return ENDBLCK; }
"["                     { return STARTEXTR; }
"]"                     { return ENDEXTR; }
{string}                { yylval.string = strdup(yytext); return STRING; }
{id}                    { yylval.string = strdup(yytext); return ID; }
{cstint}                { yylval.integer = atoi(yytext); return CSTINT; }
{cstflo}                { yylval.flo = atof(yytext); return CSTFLO; }
{com}|{blank}|{endl}    {}
.                       { printf("FAUX: %s", yytext); }

%%
