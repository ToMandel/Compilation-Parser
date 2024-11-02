%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bison_bottom_up.tab.h"

struct Course {
    char* name;
    char* school;
    double credits;
};

extern int yylex();
extern int yyerror(const char*);
int electiveCounter = 0;
double electiveCredits = 0;
int electiveFlag = 0;
struct Course electiveArr[100];
%}

%union {
    int ival;
    double dval;
    char str[50];
}

%token NUM NAME CREDITS DEGREE SCHOOL ELECT COURSES

%type <ival> NUM
%type <str> NAME
%type <dval> CREDITS
%type <str> DEGREE
%type <str> SCHOOL
%type <str> elective

%start input

%%

input: COURSES course_list;

course_list: course_list course
course_list: %empty;

course: NUM NAME CREDITS DEGREE SCHOOL elective {
    if (electiveFlag) {
        electiveCredits += $3;
        electiveCounter++;
        if ($3 >= 3.0) {
            electiveArr[electiveCounter-1].name = strdup($2);
            electiveArr[electiveCounter-1].school = strdup($5);
            electiveArr[electiveCounter-1].credits = $3;
        }
        electiveFlag = 0;
    }
};
elective: ELECT {
    electiveFlag = 1;
		}
        | %empty{
        };

%%

int main(int argc, char* argv[]) {
    extern FILE* yyin;
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input-file-name>\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "failed to open %s\n", argv[1]);
        return 2;
    }

    yyparse();
    printf("There are %d elective courses\nThe total number of credits of the elective courses is %.2f\nThe elective courses with 3 credits or more are:\nCOURSE\t\tSCHOOL\n--------------------------\n", electiveCounter,electiveCredits);
    for (int i = 0; i < electiveCounter; i++) {
        if (electiveArr[i].credits >= 3.0) {
            printf("%s\t%s\n", electiveArr[i].name, electiveArr[i].school);
        }
	}
	fclose(yyin);
    return 0;
}
int yyerror(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 1;
}