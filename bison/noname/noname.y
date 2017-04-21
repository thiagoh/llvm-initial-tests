%{
#include <string>
#include <map>
#include <vector>
#include <stdio.h>
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <memory>
#include <string>
#include <vector>
#include <math.h>
#include "noname-parse.h"
#include "noname-types.h"

extern int yylex(void);
extern int yydebug;
extern void yyerror(const char *error_msg);
extern void division_by_zero(YYLTYPE &yylloc);
extern void eval(ASTNode* node);

// std::map<std::string, symrec*> symbol_table;
// std::map<std::string, symrec*>::iterator symbol_table_it;
%}

//////////////////////////////////////////////////
///////////* Bison declarations.  *///////////////
//////////////////////////////////////////////////

%union {
  char* id_v;
  double double_v;
  long long_v;
  struct explist* exp_list;

  ASTNode* node;
  char* error_msg;
};

%{

  template<class Ret, class In>
  inline Ret _cast(void* v) {
    return (Ret) *(In*)v;
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
%token '+'                    "+"
%token '-'                    "-"
%token '/'                    "/"
%token '*'                    "*"
%token '^'                    "^"

%token <id_v> ID             "identifier"
%token <id_v> STR_CONST      "string_constant"
%token <double_v> DOUBLE     "double"
%token <long_v> LONG         "long"
%type  <node> assignment     "assignment"
%type  <node> declaration    "declaration"
%type  <node> exp            "expression"
%type  <exp_list> exp_list   "exp_list"
%type  <node> stmt           "statement"

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
  | prog stmt {
    eval($2);
  } 
  | error STMT_SEP         { yyerrok; fprintf(stderr, "Error at %d:%d", @1.first_column, @1.last_column); }
;

stmt:
  declaration STMT_SEP      { 
      if (yydebug) {
        fprintf(stderr, "\n[stmt - declaration]: ");
      }
      $$ = $1;
    }
  | assignment STMT_SEP     { 
      if (yydebug) {
        fprintf(stderr, "\n[stmt - assignment]: ");
      }
      $$ = $1;
    }
  | exp STMT_SEP            { 
      if (yydebug) {
        fprintf(stderr, "\n[stmt exp]: ");
      }
      $$ = $1;
    }
;

assignment:
  ID ASSIGN exp {
    // $$ = new AssignmentNode($1, $3);
    $$ = new AssignmentNode($ID, std::move($exp));
  }
  | LET ID ASSIGN exp {
    $$ = new AssignmentNode($ID, std::move($exp));
  }
;

declaration:
  LET ID {
    $$ = new DeclarationNode($ID);
  }
;

exp:
  ID {
    $$ = new VarNode($1);
  }
  | STR_CONST {
    $$ = new StringNode($STR_CONST);
  }
  | LONG {
    $$ = new NumberNode($1);
  }
  | DOUBLE {
    $$ = new NumberNode($1);
  }
  | exp '+' exp        {
      $$ = new BinaryExpNode('+', $1, $3);
    }
  | exp '-' exp        {
      $$ = new BinaryExpNode('-', $1, $3);
    }
  | exp '*' exp        {
      $$ = new BinaryExpNode('*', $1, $3);
    }
  | exp '/' exp {
      $$ = new BinaryExpNode('/', $1, $3);
    }
  | '-' exp  %prec NEG {
      $$ = new UnaryExpNode('-', $2);
    }
  | exp '^' exp        {
      $$ = new BinaryExpNode('^', $1, $3);
    }
  | '(' exp ')'        {
      $$ = new BinaryExpNode(0, $2, NULL);
    }
  | ID '(' exp_list ')'        {
      $$ = new CallExprNode($ID, $exp_list);
    }
  ;

exp_list:
  exp                   { $$ = newexplist(NULL, $1); }
  | exp_list ',' exp    { $$ = newexplist($1, $3); }
%%