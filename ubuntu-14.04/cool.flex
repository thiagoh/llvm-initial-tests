/*
 *  The scanner definition for COOL.
 *  To test this LEXER run the following command:
 *  $ make lexer && make dotest
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Dont remove anything that was here initially
 */
%{

#include "stdio.h"
#include "stdlib.h"
#include <iostream>
#include <string>
  
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */ 

using namespace std;

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

bool debugEnabled = false; 

void debug(const char*);

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */

%x STRING
%x COMMENT
%s OBJECT_DEF

DARROW          =>
ASSIGN          <-
SEMICOL         ;
CLASS           class
NEWLINE         (\r\n|\n)+
TRUE_BOOL       true
FALSE_BOOL      false

WS              [ \t]*
LETTER          [a-zA-Z]
IDCHAR          ({LETTER}|[_])
DIGIT           [0-9]
DIGITS          {DIGIT}+

START_COMMENT   "(*"
END_COMMENT     "*)"

OPT_FRAC         (\.{DIGIT}+)?
INTEGER          {DIGIT}+
DECIMAL          {DIGIT}+{OPT_FRAC}

ID              {IDCHAR}({IDCHAR}|{DIGIT})*

OBJECTID        {ID}
TYPEID          {ID}

SELF            self
IF              if
FI              fi
ELSE            else
WHILE           while
FOR             for
ELSIF           elsif
THEN            then
DONE            done
DO              do
BREAK           break

%%

 /*
  *  Nested comments
  */

{END_COMMENT} {
    cool_yylval.error_msg = "Unmatched *)";
    return ERROR;
}
{START_COMMENT} {
  debug("BEGIN COMMENT");
  BEGIN(COMMENT); 
}
<COMMENT>{NEWLINE} { curr_lineno++; }
<COMMENT>\n { curr_lineno++; }
<COMMENT>. { }
<COMMENT>{END_COMMENT} { 
  BEGIN(INITIAL); 
}

{IF}          { return IF; }
{FI}          { return FI; }
{ELSE}        { return ELSE; }
{WHILE}       { return WHILE; }
{TRUE_BOOL} { 
  cool_yylval.boolean = 1;
  return BOOL_CONST;
}
{FALSE_BOOL} { 
  cool_yylval.boolean = 0;
  return BOOL_CONST; 
}
{INTEGER} { 
  cool_yylval.symbol = inttable.add_string(yytext);
  return INT_CONST;
}
{DARROW}		  { return (DARROW); }
{CLASS}       { return CLASS; }
"=>"        { return DARROW; }
"=<"        { return LE; }
{ASSIGN}    { return ASSIGN; }
"<"         { return '<'; }
"@"         { return '@'; }
"~"         { return '~'; }
"="         { return '='; }
"."         { return '.'; }
"-"         { return '-'; }
","         { return ','; }
"+"         { return '+'; }
"*"         { return '*'; }
"/"         { return '/'; }
"}"         { return '}'; }
"{"         { return '{'; }
"("         { return '('; }
")"         { return ')'; }
":"         { return ':'; }
";"         { return ';'; }

{OBJECTID} { 
  debug("begin OBJECT_DEF");
  BEGIN OBJECT_DEF;
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}
<OBJECT_DEF>{TYPEID} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}
<OBJECT_DEF>{ASSIGN} {
  return ASSIGN;
}
<OBJECT_DEF>; {
  debug("END OBJECT_DEF");
  BEGIN INITIAL;
  return ';';
}

\n          { curr_lineno++; }
{WS}        {}
. {
  cool_yylval.error_msg = strdup(yytext);
  return ERROR;
}

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
%%

void debug(const char* text) {

  if (debugEnabled) {
    printf("[%s]\n", text);
  }
}