/*
 *  The scanner definition for COOL.
 *
 *  IMPORTANT!
 *  To test this LEXER run the following command:
 *  $ watchfiles -qq 'make lexer && make dotest' cool.flex test.cl
 *
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
char OPEN_BRACKET_CHAR = '{';
char CLOSE_BRACKET_CHAR = '}';

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

char str_buf[MAX_STR_CONST]; /* to assemble string constants */
char *str_buf_ptr;

bool debugEnabled = 0; 
void debug(const char*);
void print_strlen();
void print_str();
void print_input();
bool max_strlen_check();
bool max_strlen_check(int);
int max_strlen_err();

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */

%x STRING
%x COMMENT
%s CLASS_DEF
%s OBJECT_DEF
%s METHOD_PARAMETERS
%s METHOD_PARAM_DEF
%s PARAMS_DEFINED

DARROW          =>
LE              <=
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
OPEN_BRACKET    "{"
CLOSE_BRACKET   "}"
OPEN_PAREN      "("
CLOSE_PAREN      ")"
OPT_FRAC         (\.{DIGIT}+)?
INTEGER          {DIGIT}+
DECIMAL          {DIGIT}+{OPT_FRAC}
ID              {IDCHAR}({IDCHAR}|{DIGIT})*
OBJECTID        {ID}
TYPEID          {ID}
SELF            self
INHERITS        (?i:inherits)
LET             (?i:let)
LOOP            (?i:loop)
POOL            (?i:pool)
THEN            (?i:then)
WHILE           (?i:while)
CASE            (?i:case)
NEW             (?i:new)
ISVOID          (?i:isvoid)
OF              (?i:of)
NOT             (?i:not)
IF              if
FI              fi
ELSE            else
FOR             for
ELSIF           elsif
DONE            done
DO              do
BREAK           break

%%

{END_COMMENT} {
    cool_yylval.error_msg = "Unmatched *)";
    return ERROR;
}
{START_COMMENT} {
  debug("BEGIN COMMENT");
  BEGIN(COMMENT); 
}

\" {
    BEGIN(STRING);
    str_buf_ptr = str_buf;
}
<STRING>\" {
    BEGIN(INITIAL);
    if (max_strlen_check()) return max_strlen_err();
    str_buf_ptr = 0;
    cool_yylval.symbol = stringtable.add_string(str_buf);
    return STR_CONST;
}
<STRING><<EOF>> {
    cool_yylval.error_msg = "EOF in string constant";
    return ERROR;
}
<STRING>\\\n { curr_lineno++; }
<STRING>\n {
    curr_lineno++;
    BEGIN(INITIAL);
    cool_yylval.error_msg = "Unterminated string constant";
    return ERROR;
}
<STRING>\0 {
    cool_yylval.error_msg = "String contains null character";
    return ERROR;
}
<STRING>\\[^ntbf] {
    if (max_strlen_check()) return max_strlen_check();
    *str_buf_ptr++ = yytext[1];
}
<STRING>\\[n] {
    if (max_strlen_check()) return max_strlen_check();
    *str_buf_ptr++ = '\n';
}
<STRING>\\[t] {
    if (max_strlen_check()) return max_strlen_check();
    *str_buf_ptr++ = '\t';
}
<STRING>\\[b] {
    if (max_strlen_check()) return max_strlen_check();
    *str_buf_ptr++ = '\b';
}
<STRING>\\[f] {
    if (max_strlen_check()) return max_strlen_check();
    *str_buf_ptr++ = '\f';
}
<STRING>. {
    if (max_strlen_check()) return max_strlen_err();
    *str_buf_ptr++ = *yytext;
}

<COMMENT>{NEWLINE} { curr_lineno++; }
<COMMENT>. { }
<COMMENT>{END_COMMENT} { 
  debug("END COMMENT");
  BEGIN(INITIAL); 
}
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
{LE}		      { return (LE); }
<CLASS_DEF>{OPEN_BRACKET} {
  debug("END CLASS_DEF");
  BEGIN INITIAL;
  return OPEN_BRACKET_CHAR;
}
<METHOD_PARAMETERS>{OBJECTID} {
  debug("BEGIN METHOD_PARAM_DEF");
  BEGIN METHOD_PARAM_DEF;
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}
<METHOD_PARAM_DEF>(:) {
  return ':';
}
<METHOD_PARAM_DEF>{TYPEID} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}
<METHOD_PARAM_DEF>, {
  BEGIN METHOD_PARAMETERS;
  return ',';
}
<METHOD_PARAM_DEF>{CLOSE_PAREN} {
  debug("BEGIN PARAMS_DEFINED");
  BEGIN PARAMS_DEFINED;
  return ')';
}
<PARAMS_DEFINED>(:) {
  return ':';
}
<PARAMS_DEFINED>{TYPEID} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}
<PARAMS_DEFINED>{OPEN_BRACKET} {
  debug("BEGIN INITIAL");
  BEGIN INITIAL;
  return OPEN_BRACKET_CHAR;
}
<OBJECT_DEF,CLASS_DEF>{TYPEID} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return TYPEID;
}
<OBJECT_DEF>{OPEN_PAREN} {
  debug("BEGIN METHOD_PARAMETERS");
  BEGIN METHOD_PARAMETERS;
  return '(';
}
<OBJECT_DEF>(;|{OPEN_BRACKET}) {
  debug("END OBJECT_DEF");
  BEGIN INITIAL;
  return (char) yytext[0];
}

{IF}          { return IF; }
{FI}          { return FI; }
{ELSE}        { return ELSE; }
{LOOP}      { return LOOP; }    
{POOL}      { return POOL; }
{THEN}      { return THEN; }
{WHILE}     { return WHILE; }
{CASE}      { return CASE; }
{NEW}       { return NEW; }
{OF}        { return OF; }
{ASSIGN}    { return ASSIGN; }
{INHERITS}  { return INHERITS; }    
{LET}       { return LET; } 
{NOT}       { return NOT; }

{CLOSE_BRACKET}        { return '}'; }
{OPEN_BRACKET}         { return '{'; }
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
"("         { return '('; }
")"         { return ')'; }
":"         { return ':'; }
";"         { return ';'; }
\n          { curr_lineno++; }
{WS}        {}

<INITIAL>{CLASS} {
  debug("BEGIN CLASS");
  BEGIN(CLASS_DEF);
  return CLASS;
}
<INITIAL>{OBJECTID} { 
  debug("BEGIN OBJECT_DEF");
  BEGIN OBJECT_DEF;
  cool_yylval.symbol = idtable.add_string(yytext);
  return OBJECTID;
}

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

void print_strlen () { 
    printf("String length:%d\n", str_buf_ptr - str_buf); 
}

void print_str () {
    printf("String:'%s'\n", str_buf);
}

void print_input () {
    printf("Scan:'%s'\n", yytext);
}

bool max_strlen_check () { 
    return (str_buf_ptr - str_buf) + 1 > MAX_STR_CONST; 
}

bool max_strlen_check (int size) {
    return (str_buf_ptr - str_buf) + size > MAX_STR_CONST;
}

int max_strlen_err() { 
    BEGIN(INITIAL);
    cool_yylval.error_msg = "String constant too long";
    return ERROR;
}