/* noname language.  */
%define api.pure
%define parse.error verbose
%{
  struct pcdata {};
%}
%parse-param { struct pcdata *pp }
%lex-param { struct pcdata *pp }

%{
#define YYLEX_PARAM pp->scaninfo
#include <stdio.h>
#include <stdlib.h> /* malloc. */
#include <string.h> /* strlen. */
#include <string> 
#include <ctype.h>
#include <stdio.h>
#include <math.h>
#include <math.h>
#include <map>
#include "noname-tree.h"
// #include "noname-parse.h"

#define YYLTYPE YYLTYPE
typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
  } YYLTYPE;

// struct ast {
//   int nodetype;
//   struct ast *l;
//   struct ast *r;
// };

// struct symbol { /* a variable name */
//   char *name;
//   double value;
//   struct ast *func; /* stmt for the function */
//   struct symlist *syms; /* list of dummy args */
// };

/* per-parse data */
// struct pcdata {
//  void* scaninfo; /* scanner context */
//  struct symbol *symtab; /* symbols for this parse */
//  struct ast *ast; /* most recently parsed AST */
// };

YYLTYPE yylloc;

/* Function type.  */
// typedef double (*func_t) (double);

// YYLTYPE yylloc;

int line_number;
char buf[1024 * 8];
std::map<std::string, symrec*> symbol_table;
std::map<std::string, symrec*>::iterator symbol_table_it;

%}

//////////////////////////////////////////////////
///////////* Bison declarations.  *///////////////
//////////////////////////////////////////////////

%union {
    char* idv;
    char charv;
    double doublev;
    int intv;
    symrec* symrecv;
    char* error_msg;
};

%{

int main (const int args, const char** argv);

// int yylex (void);
void noname_yyerror(YYLTYPE *yylloc, void *pp, char const * message);
// void noname_yyerror(YYLTYPE * yylloc, char const *);

// stuff from flex that bison needs to know about:
extern int noname_yylex(YYSTYPE *yylval, YYLTYPE* llocp, void* yyscanner);
// extern int noname_yyparse(void* yyscanner);
// extern FILE *yyin;

// void division_by_zero();
void division_by_zero(YYLTYPE yylloc);

%}

%token LINE_BREAK            "line_break"             
%token STMT_SEP              "stmt_sep"           
%token LETTER                "letter"         
%token DIGIT                 "digit"         
%token DIGITS                "digits"         
%token DARROW                "darrow"         
%token ELSE                  "else"       
%token FALSE                 "false"         
%token IF                    "if"     
%token IN                    "in"     
%token LET                   "let"       
%token LOOP                  "loop"       
%token THEN                  "then"       
%token WHILE                 "while"         
%token BREAK                 "break"         
%token CASE                  "case"       
%token NEW                   "new"       
%token NOT                   "not"       
%token TRUE                  "true"       
%token NEWLINE               "newline"           
%token NOTNEWLINE            "notnewline"             
%token WHITESPACE            "whitespace"             
%token LE                    "le"     
%token ASSIGN                "assign"         
%token NULLCH                "nullch"         
%token BACKSLASH             "backslash"             
%token STAR                  "star"       
%token NOTSTAR               "notstar"           
%token LEFTPAREN             "leftparen"             
%token NOTLEFTPAREN          "notleftparen"               
%token RIGHTPAREN            "rightparen"             
%token NOTRIGHTPAREN         "notrightparen"                 
%token LINE_COMMENT          "line_comment"               
%token START_COMMENT         "start_comment"                 
%token END_COMMENT           "end_comment"               
%token QUOTES                "quotes"         

%token <idv> ID              "identifier"
%token <doublev> NUM         "number"
%token <charv> '+'           "operator +"
%token <charv> '-'           "operator -"
%token <charv> '/'           "operator /"
%token <charv> '*'           "operator *"
%token <charv> '^'           "operator ^"
%type  <symrecv> assignment  "assignment"
%type  <symrecv> declaration "declaration"
%type  <symrecv> exp         "expression"
%type  <symrecv> stmt        "statement"

%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */
%precedence NEG   /* negation--unary minus */

%% 

//////////////////////////////////////////////////
///////////* The grammar follows. *///////////////
//////////////////////////////////////////////////

prog:
  %empty
  | prog stmt 
  | prog STMT_SEP
;

stmt:
  exp STMT_SEP               { printf("\n[stmt] %lf\n", $1->value.doublev); }
  | declaration STMT_SEP     { printf("\n[stmt] %lf\n", $1->value.doublev); }
  | assignment STMT_SEP      { printf("\n[stmt] %lf\n", $1->value.doublev); }
  | error STMT_SEP           { printf("%d:%d", @1.first_column, @1.last_column); }
;

assignment:
  ID '=' exp {

    $$ = (symrec *) malloc (sizeof (symrec));
    symbol_table_it = symbol_table.find($1);

    if (symbol_table_it == symbol_table.end()) {

      char buf[1024];
      sprintf(buf, "No such ID %s found", $1);
      yyerror(&yylloc, pp, buf);

    } else {
      
      $$->name = $1;
      $$->value.doublev = $3->value.doublev;
      symbol_table[$1] = $$;
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
      printf("\n[assignment]");
    }
  }
  | LET ID '=' exp {

    $$ = (symrec *) malloc (sizeof (symrec));
    symbol_table_it = symbol_table.find($2);

    if (symbol_table_it != symbol_table.end()) {

      char buf[1024];
      sprintf(buf, "Cannot redefine ID %s", $2);
      yyerror(&yylloc, pp, buf);

    } else {
      
      $$->name = $2;
      $$->value.doublev = $4->value.doublev;
      symbol_table[$2] = $$;
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
      printf("\n[assignment]");
    }
  }
;

declaration:
  LET ID {

    $$ = (symrec *) malloc (sizeof (symrec));
    symbol_table_it = symbol_table.find($2);

    if (symbol_table_it != symbol_table.end()) {

      char buf[1024];
      sprintf(buf, "Cannot redefine ID %s", $2);
      yyerror(&yylloc, pp, buf);

    } else {
      
      $$->name = $2;
      symbol_table[$2] = $$;
      // $$->value.doublev = symbol_table_it->second->value.doublev;
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
      printf("\n[declaration]");
    }
  }
;

exp:
  ID {
     
    $$ = (symrec *) malloc (sizeof (symrec));
    symbol_table_it = symbol_table.find($1);

    if (symbol_table_it == symbol_table.end()) {

      char buf[1024];
      sprintf(buf, "No such ID %s found", $1);
      yyerror(&yylloc, pp, buf);

    } else {
      
      $$->name = $1;
      $$->value.doublev = symbol_table_it->second->value.doublev;
      printf("\nID %s -> %lf", $1, $$->value.doublev);
    }
  }
  | NUM {
    $$ = (symrec *) malloc (sizeof (symrec));
    $$->name = (char*) "__annon";
    $$->value.doublev = $1;
    printf("\nexp %lf", $1);
  }
  | exp '+' exp        {
      // $$ = $1 + $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = $1->value.doublev + $3->value.doublev;
      printf("\nexp + exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '-' exp        {
      // $$ = $1 - $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = $1->value.doublev - $3->value.doublev;
      printf("\nexp - exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '*' exp        {
      // $$ = $1 * $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = $1->value.doublev * $3->value.doublev;
      printf("\nexp * exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '/' exp {
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
    
      if ($3->value.doublev) {
        // $$ = $1 / $3;
        $$->value.doublev = $1->value.doublev / $3->value.doublev;
      } else {
        // $$ = $1;
        $$->value.doublev = $1->value.doublev;
        division_by_zero(@3);
      }
      printf("\nexp / exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | '-' exp  %prec NEG {
      /**
        * The %prec simply instructs Bison that the rule ‘| '-' exp’ 
        * has the same precedence as NEG—in this case the next-to-highest
        */
      // $$ = -($2->value.doublev);
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = -$2->value.doublev;
      printf("\nexp ^ exp %lf", $2->value.doublev);
    }
  | exp '^' exp        {
      //$$ = pow($1->value.doublev, $3->value.doublev);
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = pow($1->value.doublev, $3->value.doublev);
      printf("\nexp ^ exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | '(' exp ')'        {
      // $$ = $2->value.doublev;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->value.doublev = $2->value.doublev;
      printf("\n(exp) %lf", $2->value.doublev);
    }
  // | error                 { printf("ERROR3"); }
  ;
%%

//////////////////////////////////////////////////
///////////* Code definitions. *//////////////////
//////////////////////////////////////////////////

int main (const int args, const char** argv) {

  puts("aaa");

  line_number = 1;

  yylloc.first_line = yylloc.last_line = 1;
  yylloc.first_column = yylloc.last_column = 0;

  puts("bbb");

  struct pcdata p;

  puts("ccc");
  // // /* set up scanner */
  // // if(yylex_init_extra(&p, &p.scaninfo)) {
  // //   perror("init alloc failed");
  // //   return 1;
  // // }

  // // /* allocate and zero out the symbol table */
  // // if(!(p.symtab = calloc(NHASH, sizeof(struct symbol)))) {
  // //   perror("sym alloc failed");
  // //   return 1;
  // // }
  
  return yyparse(&p);
}

/* Called by yyparse on error.  */
void yyerror(YYLTYPE *yylloc, void *pp, char const *s) {
  fprintf (stderr, "ERROR: %s\n", s);
}

void division_by_zero(YYLTYPE yylloc) {
  fprintf (stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
                   yylloc.first_line, yylloc.first_column,
                   yylloc.last_line, yylloc.last_column);
}