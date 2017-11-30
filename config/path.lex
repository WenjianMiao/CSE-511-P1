%{

#include <stdio.h>
#include <string.h>
#include "global.h"
#include "path.yacc.h"


%}

delim	[ \t]
ws	{delim}+
op	[a-zA-Z_][a-zA-Z_]*

%%
{ws}	{}
path	{global_count_lex++; return(PATH);}
end	{return(END);}
{op}	{strcpy(yylval.name, yytext); return(OP);}
"{"	{return(LBRACE);}
"}"	{return(RBRACE);}
"("	{return(LPAREN);}
")"	{return(RPAREN);}
"+"	{return(PLUS);}
";"	{return(SEMICOLON);}
<<EOF>>	{yyterminate();}
.	{printf("Illegal Input Path Expression!\n");}

%%

int yywrap(){
	return 1;
}

