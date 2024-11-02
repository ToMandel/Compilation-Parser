%{
#include "recursive_descent.h"
extern int atoi (const char *);
union my_yylval yylval;
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */
%x COMMENT

%%

\<courses\> { strcpy(yylval.str, yytext); return COURSES; }

[1-9][0-9][0-9][0-9][0-9]   { yylval.ival = atoi (yytext); return NUM; }

\"([^\\"\n]|.)*\"   { strcpy(yylval.str, yytext); return NAME; }

0\.[0-9]*|[1-5](\.[0-9]*)?|6|6\.0  { yylval.dval = atof (yytext); return CREDITS; }

[BM]\.Sc\.  { strcpy(yylval.str, yytext); return DEGREE; }

Software|Electrical|Mechanical|Management|Biomedical  { strcpy(yylval.str, yytext); return SCHOOL; }

[eE]lective { strcpy(yylval.str, yytext);return ELECT; }

[ \n\t\r]+   /* skip white space */

"//"       { BEGIN (COMMENT); }

<COMMENT>.+ /* skip comment */
<COMMENT>\n {  /* end of comment --> resume normal processing */
BEGIN (0); }

.          { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%
