#include "lexer-utilities.h"
#include "noname-parse.h"
#include "noname-types.h"
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <string>

// void yyerror(const char *);

// #define YY_NO_UNPUT /* keep g++ happy */
// extern FILE *fin;   /* we read from this file */

// // /* define YY_INPUT so we read from the FILE fin:
// // * This change makes it possible to use this scanner in
// // * the Cool compiler.
// // */
// #undef YY_INPUT
// #define YY_INPUT(buf, result, max_size)                                        \
//   if ((result = fread((char *)buf, sizeof(char), max_size, fin)) < 0)          \
//     YY_FATAL_ERROR("read() in flex scanner failed");

// extern int curr_lineno;
// extern int verbose_flag;

std::map<int, std::string> map;
extern YYSTYPE yylval;
// extern int yylex(void);
extern int noname_yylex(void);
extern int yyparse();
void yyerror(char const *s);

//
//  The lexer keeps this global variable up to date with the line number
//  of the current line read from the input.
//
int curr_lineno = 1;
char *curr_filename = "<stdin>"; // this name is arbitrary
// FILE *fin; // This is the file pointer from which the lexer reads its input.

//
//  noname_yylex() is the function produced by flex. It returns the next
//  token each time it is called.
//
// #define YY_DECL extern int noname_yylex()

// #define YY_DECL int yylex()
// #define YY_DECL int noname_yylex(YYSTYPE * yylval_param , yyscan_t yyscanner)
// extern int noname_yylex(YYSTYPE * yylval_param , yyscan_t yyscanner);
// YYSTYPE noname_yylval; // Not compiled with parser, so must define this.

// extern int optind; // used for option processing (man 3 getopt for more info)

//
//  Option -v sets the lex_verbose flag. The main() function prints out tokens
//  if the program is invoked with option -v.  Option -l sets yy_flex_debug.
//
// extern int yy_flex_debug; // Flex debugging; see flex documentation.
// extern int lex_verbose;   // Controls printing of tokens.
// void handle_flags(int argc, char *argv[]);

//
//  The full Cool compiler contains several debugging flags, all of which
//  are handled and set by the routine handle_flags.  Here we declare
//  noname_yydebug, which is not used by the lexer but is needed to link
//  with handle_flags.
//
// int noname_yydebug;

// defined in utilities.cc
// extern void dump_noname_token(ostream &out, int lineno, int token, YYSTYPE
// yylval);

/* Called by yyparse on error.  */

int yylex(void) {

  int token = noname_yylex();

  if (token == LONG) {
    fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %ld\n", token, map[token].c_str(), yylval.long_v);
  } else if (token == DOUBLE) {
    fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %lf\n", token, map[token].c_str(), yylval.double_v);
  } else if (token == ID) {
    fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %s\n", token, map[token].c_str(), yylval.id_v);
  } else {
    fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %c\n", token, map[token].c_str(), (char) token);
  }

  return token;
}

void division_by_zero(YYLTYPE &yylloc) {
  fprintf(stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
          yylloc.first_line, yylloc.first_column, yylloc.last_line,
          yylloc.last_column);
}

void yyerror(char const *s) { fprintf(stderr, "\nERROR: %s\n", s); }


int main(int argc, char **argv) {
  int token;

  // fin = fopen(argv[optind], "r");
  // if (fin == NULL) {
  //   cerr << "Could not open input file " << endl;
  //   exit(1);
  // }

  map[258] = "LINE_BREAK";
  map[259] = "STMT_SEP";
  map[260] = "LETTER";
  map[261] = "DIGIT";
  map[262] = "DIGITS";
  map[263] = "DARROW";
  map[264] = "ELSE";
  map[265] = "FALSE";
  map[266] = "IF";
  map[267] = "IN";
  map[268] = "LET";
  map[269] = "LOOP";
  map[270] = "THEN";
  map[271] = "WHILE";
  map[272] = "BREAK";
  map[273] = "CASE";
  map[274] = "NEW";
  map[275] = "NOT";
  map[276] = "TRUE";
  map[277] = "NEWLINE";
  map[278] = "NOTNEWLINE";
  map[279] = "WHITESPACE";
  map[280] = "LE";
  map[281] = "ASSIGN";
  map[282] = "NULLCH";
  map[283] = "BACKSLASH";
  map[284] = "STAR";
  map[285] = "NOTSTAR";
  map[286] = "LEFTPAREN";
  map[287] = "NOTLEFTPAREN";
  map[288] = "RIGHTPAREN";
  map[289] = "NOTRIGHTPAREN";
  map[290] = "LINE_COMMENT";
  map[291] = "START_COMMENT";
  map[292] = "END_COMMENT";
  map[293] = "QUOTES";
  map[294] = "ERROR";
  map[295] = "ID";
  map[296] = "DOUBLE";
  map[297] = "LONG";
  map[302] = "NEG";
  
  

  yydebug = 5;

  return yyparse();
}