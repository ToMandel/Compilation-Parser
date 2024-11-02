#ifndef TOPDOWN_RECURSIVE_DESCENT_H
#define TOPDOWN_RECURSIVE_DESCENT_H
#include <string.h>
enum token {
    COURSES,
    NUM,
    NAME,
    CREDITS,
    DEGREE,
    SCHOOL,
    ELECT
};

union my_yylval {
    int ival;
    double dval;
    char str[50];
};

extern union my_yylval yylval;

void parse(); // parser
void start();
void match(int expectedToken);
void courseCase();
void errorMsg(const char* s);
#endif //TOPDOWN_RECURSIVE_DESCENT_H
