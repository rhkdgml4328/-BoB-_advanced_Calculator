/* fb3-2.h - Declarations for a calculator */

/* Interface to the lexer */
extern int yylineno; /* from lexer */
void yyerror(char *s, ...);

/* Symbol table */
struct symbol { /* a variable name */
    char *name;
    double value;
    struct ast *func; /* stmt for the function */
    struct symlist *syms; /* list of dummy args */
};

/* Simple symtab of fixed size */
#define NHASH 9997
struct symbol *lookup(char*);

/* List of symbols, for an argument list */
struct symlist {
    struct symbol *sym;
    struct symlist *next;
};

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);
void symlistfree(struct symlist *sl);

/* Node types */
enum bifs { /* built-in functions */
    B_sqrt = 1,
    B_exp,
    B_log,
    B_print
};

/* Nodes in the abstract syntax tree */
/* All have common initial nodetype */
struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct fncall { /* Built-in function */
    int nodetype; /* type F */
    struct ast *l;
    enum bifs functype;
};

struct ufncall { /* User function */
    int nodetype; /* type C */
    struct ast *l; /* list of arguments */
    struct symbol *s;
};

struct flow {
    int nodetype; /* type I or W */
    struct ast *cond; /* condition */
    struct ast *tl; /* then branch or do list */
    struct ast *el; /* optional else branch */
};

struct numval {
    int nodetype; /* type K */
    double number;
};

struct symref {
    int nodetype; /* type N */
    struct symbol *s;
};

struct symasgn {
    int nodetype; /* type = */
    struct symbol *s;
    struct ast *v; /* value */
};

/* Build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct ast *l, struct ast *r);
struct ast *newfunc(int functype, struct ast *l);
struct ast *newcall(struct symbol *s, struct ast *l);
struct ast *newref(struct symbol *s);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newnum(double d);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *tr);

/* Define a function */
void dodef(struct symbol *name, struct symlist *syms, struct ast *stmts);

/* Evaluate an AST */
double eval(struct ast *);

/* Delete and free an AST */
void treefree(struct ast *);

