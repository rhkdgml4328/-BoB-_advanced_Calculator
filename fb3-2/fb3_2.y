/* fb3_2.y - Parser for the calculator */

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "fb3_2.h"

int yylex(void);
void yyerror(char *s, ...);
%}

%union {
    struct ast *a;
    double d;
    struct symbol *s;
    struct symlist *sl;
    int fn;
}

/* Declare tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL
%token IF THEN ELSE WHILE DO LET
%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS
%type <a> exp stmt explist stmtlist
%type <sl> symlist
%start calclist

%%

calclist:
    /* nothing */
    | calclist stmt EOL {
        printf("= %4.4g\n> ", eval($2));
        treefree($2);
    }
    | calclist LET NAME '=' exp EOL {
        struct symbol *sym = $3;
        sym->value = eval($5);
        printf("Defined %s = %4.4g\n> ", sym->name, sym->value);
    }
    | calclist LET NAME '(' symlist ')' '=' stmtlist EOL {
        dodef($3, $5, $8);
        printf("Defined %s\n> ", $3->name);
    }
    | calclist error EOL { yyerrok; printf("> "); }
    ;

stmtlist:
    stmt { $$ = $1; }
    | stmt ';' stmtlist { $$ = newast('L', $1, $3); }
    ;

stmt:
    IF exp THEN stmtlist { $$ = newflow('I', $2, $4, NULL); }
    | IF exp THEN stmtlist ELSE stmtlist { $$ = newflow('I', $2, $4, $6); }
    | WHILE exp DO stmtlist { $$ = newflow('W', $2, $4, NULL); }
    | exp
    ;

exp:
    exp CMP exp { $$ = newcmp($2, $1, $3); }
    | exp '+' exp { $$ = newast('+', $1, $3); }
    | exp '-' exp { $$ = newast('-', $1, $3); }
    | exp '*' exp { $$ = newast('*', $1, $3); }
    | exp '/' exp { $$ = newast('/', $1, $3); }
    | '|' exp { $$ = newast('|', $2, NULL); }
    | '(' exp ')' { $$ = $2; }
    | '-' exp %prec UMINUS { $$ = newast('M', $2, NULL); }
    | NUMBER { $$ = newnum($1); }
    | NAME { $$ = newref($1); }
    | NAME '=' exp { $$ = newasgn($1, $3); }
    | FUNC '(' explist ')' { $$ = newfunc($1, $3); }
    | NAME '(' explist ')' { $$ = newcall($1, $3); }
    ;

explist:
    exp { $$ = $1; }
    | exp ',' explist { $$ = newast('L', $1, $3); }
    ;

symlist:
    NAME { $$ = newsymlist($1, NULL); }
    | NAME ',' symlist { $$ = newsymlist($1, $3); }
    ;

%%

/* Error handler */
void yyerror(char *s, ...) {
    va_list ap;
    va_start(ap, s);
    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
    va_end(ap);
}

/* Main function */
int main() {
    printf("> ");
    return yyparse();
}

