// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// definitions for the evaluation functions

typedef char* CharPtr;

enum Operators {ADD, SUBTRACT, MULTIPLY, DIVIDE, EXPO, MOD, LESS, AND, OR,
NOT, GREAT, GOREQ, LOREQ, EQUAL, INEQ, NEG, LFOLD, RFOLD};

int hexToInt(char *hex_string);
double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateIntArithmetic(int left, Operators operator_, int right);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateLFold(Operators action, vector<double>* values);
double evaluateRFold(Operators action, vector<double>* values);
double evaluateUnary(Operators operator_, double value);
