%{
#include <stdio.h>
#include <string>
#include <map>
#include <math.h>
#include "noname-parse.h"
#include "noname-types.h"

extern int yylex(void);
extern void yyerror(const char *error_msg);
extern void division_by_zero(YYLTYPE &yylloc);


std::map<std::string, symrec*> symbol_table;
std::map<std::string, symrec*>::iterator symbol_table_it;
%}

//////////////////////////////////////////////////
///////////* Bison declarations.  *///////////////
//////////////////////////////////////////////////

%union {

  char* id_v;
  double double_v;
  long long_v;
  
  symrecv symrecv;
  char* error_msg;
};

%{

  bool symbol_exist(const char* key) {
    std::string skey = key;
    symbol_table_it = symbol_table.find(skey);
    return  (symbol_table_it != symbol_table.end());
  }

  void symbol_insert(const char* key, symrecv symrecv) {
    std::string skey = key;
    symbol_table[skey] = symrecv;
  }

  symrecv symbol_retrieve(const char* key) {
    std::string skey = key;
    return symbol_table[skey];
  }

  void assign_symrecv_value(symrecv from, symrecv to) {
    if (from->type == TYPE_DOUBLE) {
      to->value.doublev = from->value.doublev;
    } else if (from->type == TYPE_LONG) {
      to->value.longv = from->value.longv;
    } else if (from->type == TYPE_CHAR) {
      to->value.charv = from->value.charv;
    } else {
      fprintf(stderr, "assign_symrecv_value not implemented for %d" , from->type);
    }
  }

  void print_symrecv_value(symrecv sym) {

    if (sym->type == TYPE_LONG) {
      printf("%d", sym->value.intv);

    } else if (sym->type == TYPE_DOUBLE) {
      printf("%lf", sym->value.doublev);

    } else {
      printf("print not implemented for type %d", sym->type);
    }
  }
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
%token ERROR                 "error"

%token <id_v> ID             "identifier"
%token <double_v> DOUBLE     "double"
%token <long_v> LONG         "long"
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

%start prog

%% 

//////////////////////////////////////////////////
///////////* The grammar follows. *///////////////
//////////////////////////////////////////////////

prog:
  %empty
  | prog stmt
;

stmt:
  declaration STMT_SEP      { printf("\n[stmt] 2: "); print_symrecv_value($1); $$ = $1;}
  | assignment STMT_SEP     { printf("\n[stmt] 3: "); print_symrecv_value($1); $$ = $1;}
  | exp STMT_SEP            { printf("\n[stmt] 1: "); print_symrecv_value($1); $$ = $1;}
  | error                   { printf("%d:%d", @1.first_column, @1.last_column); }
;

assignment:
  ID ASSIGN exp {

    $$ = (symrec *) malloc (sizeof (symrec));

    if (!symbol_exist($1)) {

      char buf[1024];
      sprintf(buf, "No such ID %s found", $1);
      yyerror(buf);

    } else {
      
      $$->name = $1;
      $$->type = $3->type;
      assign_symrecv_value($3, $$);
      symbol_insert($1, $$);
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
      printf("\n[assignment]");
    }
  }
  | LET ID ASSIGN exp {

    $$ = (symrec *) malloc (sizeof (symrec));

    if (symbol_exist($2)) {

      char buf[1024];
      sprintf(buf, "Cannot redefine ID %s", $2);
      yyerror(buf);

    } else {
      
      $$->name = $2;
      $$->type = $4->type;
      assign_symrecv_value($4, $$);
      symbol_insert($2, $$);
      printf("\n[assignment]");
    }
  }
;

declaration:
  LET ID {

    $$ = (symrec *) malloc (sizeof (symrec));

    if (symbol_exist($2)) {

      char buf[1024];
      sprintf(buf, "Cannot redefine ID %s", $2);
      yyerror(buf);

    } else {
      
      $$->name = $2;
      // $$->type = $1->type == TYPE_DOUBLE || $3->type == TYPE_DOUBLE ? TYPE_DOUBLE : $1->type;
      symbol_insert($2, $$);
      // $$->value.doublev = symbol_table_it->second->value.doublev;
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
      printf("\n[declaration]");
    }
  }
;

exp:
  ID {
     
    $$ = (symrec *) malloc (sizeof (symrec));

    if (!symbol_exist($1)) {

      char buf[1024];
      sprintf(buf, "No such ID %s found", $1);
      yyerror(buf);

    } else {
      
      symrecv sym = symbol_retrieve($1);

      $$->name = $1;
      $$->type = sym->type;
      assign_symrecv_value(sym, $$);
      // $$->value.doublev = symbol_retrieve($1)->value.doublev;
      // printf("\nID %s -> %lf", $1, $$->value.doublev);
    }
  }
  | LONG {
    $$ = (symrec *) malloc (sizeof (symrec));
    $$->name = (char*) "__annon";
    $$->type = TYPE_LONG;
    $$->value.intv = $1;
    printf("\nexp %ld", $1);
  }
  | DOUBLE {
    $$ = (symrec *) malloc (sizeof (symrec));
    $$->name = (char*) "__annon";
    $$->type = TYPE_DOUBLE;
    $$->value.doublev = $1;
    printf("\nexp %lf", $1);
  }
  | exp '+' exp        {
      // $$ = $1 + $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $1->type == TYPE_DOUBLE || $3->type == TYPE_DOUBLE ? TYPE_DOUBLE : $1->type;
      $$->value.doublev = $1->value.doublev + $3->value.doublev;
      printf("\nexp + exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '-' exp        {
      // $$ = $1 - $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $1->type == TYPE_DOUBLE || $3->type == TYPE_DOUBLE ? TYPE_DOUBLE : $1->type;
      $$->value.doublev = $1->value.doublev - $3->value.doublev;
      printf("\nexp - exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '*' exp        {
      // $$ = $1 * $3;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $1->type == TYPE_DOUBLE || $3->type == TYPE_DOUBLE ? TYPE_DOUBLE : $1->type;
      $$->value.doublev = $1->value.doublev * $3->value.doublev;
      printf("\nexp * exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | exp '/' exp {
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $1->type == TYPE_DOUBLE || $3->type == TYPE_DOUBLE ? TYPE_DOUBLE : $1->type;
    
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
      $$->type = $2->type;
      $$->value.doublev = -$2->value.doublev;
      printf("\nexp ^ exp %lf", $2->value.doublev);
    }
  | exp '^' exp        {
      //$$ = pow($1->value.doublev, $3->value.doublev);
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $1->type;
      $$->value.doublev = pow($1->value.doublev, $3->value.doublev);
      printf("\nexp ^ exp %lf %lf", $1->value.doublev, $3->value.doublev);
    }
  | '(' exp ')'        {
      // $$ = $2->value.doublev;
      $$ = (symrec *) malloc (sizeof (symrec));
      $$->name = (char*) "__annon";
      $$->type = $2->type;
      $$->value.doublev = $2->value.doublev;
      printf("\n(exp) %lf", $2->value.doublev);
    }
  | error                 { printf("\nERROR on exp rule"); }
  ;
%%