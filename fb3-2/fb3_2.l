/* fb3_2.l - Lexer for the calculator */

%option noyywrap nodefault yylineno

%{
#include "fb3_2.h"
#include "fb3_2.tab.h"
%}

/* Float exponent */
EXP ([Ee][-+]?[0-9]+)

%%

"+"       { return '+'; }
"-"       { return '-'; }
"*"       { return '*'; }
"/"       { return '/'; }
"="       { return '='; }
"|"       { return '|'; }
","       { return ','; }
";"       { return ';'; }
"("       { return '('; }
")"       { return ')'; }

">"       { yylval.fn = 1; return CMP; }
"<"       { yylval.fn = 2; return CMP; }
"<>"      { yylval.fn = 3; return CMP; }
"=="      { yylval.fn = 4; return CMP; }
">="      { yylval.fn = 5; return CMP; }
"<="      { yylval.fn = 6; return CMP; }

"if"      { return IF; }
"then"    { return THEN; }
"else"    { return ELSE; }
"while"   { return WHILE; }
"do"      { return DO; }
"let"     { return LET; }

"sqrt"    { yylval.fn = B_sqrt; return FUNC; }
"exp"     { yylval.fn = B_exp; return FUNC; }
"log"     { yylval.fn = B_log; return FUNC; }
"print"   { yylval.fn = B_print; return FUNC; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.s = lookup(yytext); return NAME; }
[0-9]+"."[0-9]*{EXP}?   { yylval.d = atof(yytext); return NUMBER; }
[0-9]+                  { yylval.d = atof(yytext); return NUMBER; }
{EXP}                   { yylval.d = atof(yytext); return NUMBER; }

\n                      { return EOL; }  // EOL token

"//".*                  { /* ignore comments */ }
[ \t]                   { /* ignore whitespace */ }
.                       { yyerror("Mystery character %c\n", *yytext); }

%%

/* Helper function */struct symbol *lookup(char *sym);
