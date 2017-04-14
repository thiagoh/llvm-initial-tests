/* Infix notation calculator.  */
%{

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

#define YYLTYPE YYLTYPE
typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
  } YYLTYPE;

// YYLTYPE yylloc;

/* Function type.  */
// typedef double (*func_t) (double);

// YYLTYPE yylloc;

int line_number;
char buf[1024 * 8];
std::map<std::string, symrec*> symbol_table;
std::map<std::string, symrec*>::iterator symbol_table_it;
int yylex (void);
void yyerror (char const *);

symrec * putsym (char const *sym_name, int sym_type);
symrec * getsym (char const *sym_name);

// void division_by_zero();
void division_by_zero(YYLTYPE yylloc);

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

%define parse.error verbose
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
      yyerror(buf);

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
      yyerror(buf);

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
      yyerror(buf);

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
      yyerror(buf);

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

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */

int yylex (void) {
  int c;
  /* Skip white space.  */
  while ((c = getchar()) == ' ' || c == '\t')
    ++yylloc.last_column;
  printf("char -> %c\n", c); 
  /* Step.  */
  yylloc.first_line = yylloc.last_line;
  yylloc.first_column = yylloc.last_column;
  /* Process numbers.  */

  if (c == '.' || isdigit(c)) {
    // ungetc(c, stdin);
    char* doubleBuf = new char[64];
    char* doubleBufBegin = doubleBuf;
    int dix = 0;
    do {
      ++yylloc.last_column;
      *doubleBuf = c;
      doubleBuf++;
      dix++;
      c = getchar();
    } while(c == '.' || isdigit(c));
    *doubleBuf = '\0';
    double val = strtod(doubleBufBegin, 0);
    yylval.doublev = val;
    // sscanf(doubleBuf, "%lf", &val);
    // printf("\nhere %s %lf \nhere %s %lf", &doubleBuf[0], val, &doubleBuf[0], val);
    return NUM;
  }
  
  /* Return end-of-input.  */
  if (c == EOF)
    return 0;
  if (c == 'l') {
    ++yylloc.last_line;
    printf("LET\n");
    return LET;
  }
  if (isalpha(c)) {
    char* s = new char[1];
    *s = c;
    yylval.idv = s;
    ++yylloc.last_line;
    return ID;
  }
  if (c == ';') {
    ++yylloc.last_line;
    printf("STMT_SEP\n");
    return STMT_SEP;
  }
  /* Return a single char, and update location.  */
  if (c == '\n') {
    printf("STMT_SEP\n");
    ++line_number;
    ++yylloc.last_line;
    yylloc.last_column = 0;
    return STMT_SEP;
  } else
    ++yylloc.last_column;
  
  return c;
}

int main (void) {
  line_number = 1;
  yylloc.first_line = yylloc.last_line = 1;
  yylloc.first_column = yylloc.last_column = 0;
  
  return yyparse ();
}

symrec * putsym (char const *sym_name, int sym_type) {

  // symrec *ptr = (symrec *) malloc (sizeof (symrec));
  // ptr->name = (char *) malloc (strlen (sym_name) + 1);
  // strcpy (ptr->name,sym_name);
  // ptr->type = sym_type;
  // ptr->value.doublev = 0; /* Set value to 0 even if fctn.  */
  // ptr->next = (struct symrec *)sym_table;
  // sym_table = ptr;
  // return ptr;
  return 0;
}

symrec * getsym (char const *sym_name) {

  // symrec *ptr;

  // for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
  //   if (strcmp (ptr->name, sym_name) == 0)
  //     return ptr;
  return 0;
}

/* Called by yyparse on error.  */
void yyerror(char const *s) {
  fprintf (stderr, "ERROR: %s\n", s);
}

void division_by_zero(YYLTYPE yylloc) {
  fprintf (stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
                   yylloc.first_line, yylloc.first_column,
                   yylloc.last_line, yylloc.last_column);
}