#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "recursive_descent.h"

extern enum token yylex(void);

int lookahead;
int electCounter = 0;
double electiveCredits = 0;
double currentCredits;
char name[50];
char school[50];

struct Course {
    char name[50];
    char school[50];
};

int main(int argc, char** argv) {
    extern FILE* yyin;
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input file name>\n", argv[0]);
        exit(1);
    }
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "failed to open %s\n", argv[1]);
        exit(2);
    }

    parse();
    fclose(yyin);
    exit(0);
}

void parse() {
    lookahead = yylex(); // first element from lex file
    start();
}

void course(struct Course* courseArr) {
    match(NUM);
    strcpy(name, yylval.str);
    match(NAME);
    match(CREDITS);
    currentCredits = yylval.dval;
    match(DEGREE);
    strcpy(school, yylval.str);
    match(SCHOOL);
    if (lookahead == ELECT) {
        match(ELECT);
        electCounter++;
        electiveCredits += currentCredits;
        if (currentCredits >= 3)
        {
            strcpy(courseArr->school, school);
            strcpy(courseArr->name, name);
        }
    }
}

void start() {
    int size = 0;
    int courseSize = 1000;
    struct Course* courseArr = (struct Course*)malloc(courseSize * sizeof(struct Course));
    if (courseArr == NULL) {
        fprintf(stderr, "allocation failed\n");
        exit(1);
    }
    match(COURSES);
    while (lookahead != 0) {
        course(&courseArr[size]);
        size++;
    }
    if (electCounter > 0)
        printf("There are %d elective courses\n", electCounter);
    if (electiveCredits > 0)
        printf("The total number of credits of the elective courses is %.2f\n", electiveCredits);
    if (size > 0) {
        printf("The elective courses with 3 credits or more are:\nCOURSE\t\tSCHOOL\n-----------------------------\n");
        for (int i = 0; i < size; i++)
            if (strcmp(courseArr[i].name, ""))
                printf("%s\t%s\n", courseArr[i].name, courseArr[i].school);
    }
    free(courseArr);
}

void match(int expectedToken) {
    if (lookahead == expectedToken)
        lookahead = yylex();
    else {
        char e[100];
        sprintf(e, "error in match %d and expected %d", lookahead, expectedToken);
        errorMsg(e);
        exit(1);
    }
}

void errorMsg(const char* msg) {
    extern int yylineno;
    fprintf(stderr, "line %d: %s\n", yylineno, msg);
}