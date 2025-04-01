/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <numeric>
#include <map>
#include <algorithm>
#include <bits/stdc++.h>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

double* params;
int param_count;

Symbols<double> scalars;
Symbols<vector<double>*> lists;

double result;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL HEX_LITERAL 

%token <oper> ADDOP MULOP ANDOP RELOP OROP MODOP EXPOP NEGOP NOTOP LEFT RIGHT 

%token ARROW

%token LPAREN RPAREN SEMICOLON COLON COMMA 

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ENDFOLD ENDIF FOLD IF THEN REAL

%type <value> body statement cases case expression term primary
	 condition factor base statements elsif_clauses
	 elsif_clause error expressions_opt

%type <list> list expressions list_choice

%left ADDOP
%left MULOP MODOP 
%right EXPOP
%left ANDOP OROP 
%left NOTOP NEGOP 

%%

function: function_header variables body {result = $3;} ;

variables: /* empty */
	| variables variable

function_header: 
	FUNCTION IDENTIFIER parameters_opt RETURNS type SEMICOLON
	| error SEMICOLON 
	;

parameters_opt: 
	/* empty */
	| parameters
	;

variable: 
	IDENTIFIER COLON type IS statement {scalars.insert($1, $5);}
	| IDENTIFIER COLON LIST OF type IS list SEMICOLON {lists.insert($1, $7);}
	| error SEMICOLON 
	;

list: 
	LPAREN expressions RPAREN {$$ = $2;}
	;

expressions: 
	expressions COMMA expression {$1->push_back($3); $$ = $1;}
	| expression {$$ = new vector<double>(); $$->push_back($1);}
	;

parameters: 
	parameter 
	| parameters COMMA parameter
	;

parameter: IDENTIFIER COLON type {
    static int param_index = 0;
    scalars.insert($1, params[param_index++]);
}

type: INTEGER | REAL | CHARACTER

body: BEGIN_ statements END SEMICOLON {$$ = $2;}
	| error SEMICOLON ; 

statements: statement | statements statement

statement: expression SEMICOLON {$$ = $1;}
    | WHEN condition COMMA expression COLON expression SEMICOLON {$$ = $2 ? $4 : $6;}
    | SWITCH expressions IS cases OTHERS ARROW statements ENDSWITCH SEMICOLON {$$ = !isnan($4) ? $4 : $7;}
    | IF condition THEN statement elsif_clauses ELSE statement ENDIF SEMICOLON {$$ = $2 ? $4 : !isnan($5) ? $5 : $7;}
    | FOLD LEFT ADDOP list_choice ENDFOLD SEMICOLON {$$ = evaluateLFold($3, $4);}
	| FOLD RIGHT ADDOP list_choice ENDFOLD SEMICOLON {$$ = evaluateRFold($3, $4);}
	| FOLD LEFT MULOP list_choice ENDFOLD SEMICOLON {$$ = evaluateLFold($3, $4);}
	| FOLD RIGHT MULOP list_choice ENDFOLD SEMICOLON {$$ = evaluateRFold($3, $4);}
	;

elsif_clauses:
	elsif_clauses elsif_clause {$$ = !isnan($1) ? $1 : $2;}
	| /* empty */ {$$ = NAN;}
	; 

elsif_clause:
	ELSIF condition THEN statement {$$ = $2 ? $4 : NAN;}

cases: 
	cases case {$$ = !isnan($1) ? $1 : $2;}
	| /* empty */ {$$ = NAN;}
	;

case: CASE INT_LITERAL ARROW statement {$$ = $<value>-2 == $2 ? $4 : NAN;}
	| error SEMICOLON 
	;

list_choice: list | IDENTIFIER

condition: 
	expression RELOP expression {$$ = evaluateRelational($1, $2, $3);}
	| condition ANDOP condition {$$ = $1 && $3;}  
	| condition OROP condition {$$ = $1 || $3;} 
    | LPAREN condition RPAREN {$$ = $2;}
    | NOTOP condition {$$ = evaluateUnary($1, $2);}
	;

expression:  
	term
	| expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);}
	;

term: 
	factor
	| term MODOP factor {$$ = evaluateIntArithmetic($1, $2, $3);} 
	| term MULOP factor {$$ = evaluateArithmetic($1, $2, $3);}	
	;

factor:
	base EXPOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	base ;

base: 
	primary
	| NEGOP base {$$ = evaluateUnary($1, $2);}
	;

primary: 
	INT_LITERAL 
    | REAL_LITERAL 
    | CHAR_LITERAL
    | HEX_LITERAL 
    | IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);}
    | IDENTIFIER LPAREN expressions_opt RPAREN {$$ = extract_element($1, $3);}
    | LPAREN expression RPAREN {$$ = $2;}
	;

expressions_opt: 
	expressions
	| /* empty */ {$$ = NAN;}

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	param_count = argc - 1;
    params = new double[param_count];

    for (int i = 1; i < argc; ++i) {
        params[i - 1] = atof(argv[i]);
    }
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	
	delete[] params;
	return 0;
} 