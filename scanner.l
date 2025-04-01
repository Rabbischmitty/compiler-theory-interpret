/* CMSC 430 Compiler Theory and Design
   Project 1 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		"//".*\n
line_comment	"--".*\n
line		[\n]
id		[A-Za-z]+("_"?"_"?[A-Za-z0-9]+)*
digit		[0-9]
dec		{digit}+
realit  	{digit}*("."{digit}*)?([eE][+-]?{digit}+)?
hex		\#[0-9A-Fa-f]+
escape      	\\[btnrf']
char        	\'([^'\\]|{escape})\'
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line_comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"&"		{ ECHO; yylval.oper = AND; return(ANDOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"<>"		{ ECHO; yylval.oper = INEQ; return(RELOP); }
">"		{ ECHO; yylval.oper = GREAT; return(RELOP); }
">="		{ ECHO; yylval.oper = GOREQ; return(RELOP); }
"<="		{ ECHO; yylval.oper = LOREQ; return(RELOP); }
"|"		{ ECHO; return(OROP); }
"!"		{ ECHO; yylval.oper = NOT; return(NOTOP); }
"%"		{ ECHO; yylval.oper = MOD; return(MODOP); }
"^"		{ ECHO; yylval.oper = EXPO; return(EXPOP); }
"~"		{ ECHO; yylval.oper = NEG; return(NEGOP); }
"=>"		{ ECHO; return(ARROW); }
"("		{ ECHO; return(LPAREN); }
")"		{ ECHO; return(RPAREN); }
":"		{ ECHO; return(COLON); }
";"		{ ECHO; return(SEMICOLON); }
","		{ ECHO; return(COMMA); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
endfold		{ ECHO; return(ENDFOLD); }
endif		{ ECHO; return(ENDIF); }
fold		{ ECHO; return(FOLD); }
if		{ ECHO; return(IF); }
left		{ ECHO; yylval.oper = LFOLD; return(LEFT); }
right		{ ECHO; yylval.oper = RFOLD; return(RIGHT); }
then		{ ECHO; return(THEN); }
real		{ ECHO; return(REAL); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER); }
{dec}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{hex}		{ ECHO; yylval.value = hexToInt(yytext); return(HEX_LITERAL); }
{realit}	{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{char}		{
   		char c = yytext[1];
   		int asciiValue;
   		switch (c) {
       			case '\\':
           			switch (yytext[2]) {
               				case 'b':
                   				asciiValue = '\b';
                   				break;
               				case 't':
                   				asciiValue = '\t';
                   				break;
               				case 'n':
                   				asciiValue = '\n';
                   				break;
               				case 'r':
                   				asciiValue = '\r';
                   				break;
               				case 'f':
                   				asciiValue = '\f';
                   				break;           
               				default:
                   				// Invalid escape sequence
                   				asciiValue = -1;
                   				break;
           				}
           			break;
			default:
           			asciiValue = c;
           			break;
   		}
   		  ECHO; yylval.value = asciiValue; return (CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%