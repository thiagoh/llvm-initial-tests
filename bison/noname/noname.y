%{
#include <stdio.h>
#include "noname-types.h"

extern int yylex(void);
extern void yyerror(const char *error_msg);
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
%token <doublev> DOUBLE      "double"
%token <intv> INT            "integer"
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
  ID '=' exp          {}
  | LET ID '=' exp    {}
;

declaration:
  LET ID               {}
;

exp:
  ID                   {}
  | INT DOUBLE         {}
  | exp '+' exp        {}
  | exp '-' exp        {}
  | exp '*' exp        {}
  | exp '/' exp        {}
  | '-' exp  %prec NEG {}
  | exp '^' exp        {}
  | '(' exp ')'        {}
  // | error                 { printf("ERROR3"); }
  ;
%%