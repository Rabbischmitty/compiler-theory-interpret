// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>
#include <vector>
#include <numeric>
#include <iostream>
#include <algorithm>
#include <bits/stdc++.h>

using namespace std;

#include "values.h"
#include "listing.h"

int hexToInt(char *hex_string){
	hex_string = hex_string + 1; // removes first character
	char *end;
	long int number = strtol(hex_string, &end, 16); // 16 base for hexadecimal
	if (*end != '\0')
		{ // error checking
		printf("\nError: invalid hexadecimal number.\n");
		return -1;
		}
	return (int)number;
}

double evaluateArithmetic(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case ADD:
			result = left + right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			if(right != 0){
			result = left / right;
			} else {
				appendError(GENERAL_SEMANTIC, "Division By Zero");
				result = 0;
			}
			break;
		case EXPO:
			result = pow(left, right);
			break;
	}
	return result;
}

double evaluateIntArithmetic(int left, Operators operator_, int right) {
	int result;
	switch (operator_) {
		case MOD:
			result = left % right;
			break;
	}
	return (double)result;
}

double evaluateUnary(Operators operator_, double value){
	double result;
	switch(operator_){
		case NEG:
			result = -value;
			break;
		case NOT:
			result = !value;
			break;
	}
	return result;
}

double subFromRight(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values.back();

    for (int i = values.size() - 2; i >= 0; i--) {
        result = values[i] - result;
    }

    return result;
}

double addFromRight(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values.back();

    for (int i = values.size() - 2; i >= 0; i--) {
        result = values[i] + result;
    }

    return result;
}

double divFromRight(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values.back();

    for (int i = values.size() - 2; i >= 0; i--) {
        result = values[i] / result;
    }

    return result;
}

double mulFromRight(const std::vector<double>& values) {
    if (values.empty()) return 0; 
    double result = values.back();

    for (int i = values.size() - 2; i >= 0; i--) {
        result = values[i] * result;
    }

    return result;
}

double evaluateRFold(Operators action, vector<double>* values){
	double result;
	switch(action){
		case SUBTRACT:
			result = subFromRight(*values);
			break;
		case ADD:
			result = addFromRight(*values);
			break;
		case DIVIDE:
			result = divFromRight(*values);
			break;
		case MULTIPLY:
			result = mulFromRight(*values);
			break;
	}		
	return result;
}

double subFromLeft(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values[0];

    for (size_t i = 1; i < values.size(); i++) {
        result -= values[i];
    }

    return result;
}

double addFromLeft(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values[0];

    for (size_t i = 1; i < values.size(); i++) {
        result += values[i];
    }

    return result;
}

double divFromLeft(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values[0];

    for (size_t i = 1; i < values.size(); i++) {
        result /= values[i];
    }

    return result;
}

double mulFromLeft(const std::vector<double>& values) {
    if (values.empty()) return 0;
    double result = values[0];

    for (size_t i = 1; i < values.size(); i++) {
        result *= values[i];
    }

    return result;
}

double evaluateLFold(Operators action, vector<double>* values){
	double result;

	switch(action){
		case SUBTRACT:
			result = subFromLeft(*values);
			break;
		case ADD:
			result = addFromLeft(*values);
			break;
		case DIVIDE:
			result = divFromLeft(*values);
			break;
		case MULTIPLY:
			result = mulFromLeft(*values);
			break;
	}		
	return result;
}


double evaluateRelational(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case LESS:
			result = left < right;
			break;
		case GREAT:
			result = left > right;
			break;
		case EQUAL:
			result = left == right;
			break;
		case LOREQ:
			result = left <= right;
			break;
		case GOREQ:
			result = left >= right;
			break;
		case INEQ:
			result = left != right;
			break;
	}
	return result;
}