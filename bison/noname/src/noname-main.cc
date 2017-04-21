#include "lexer-utilities.h"
#include "noname-parse.h"
#include "noname-types.h"
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <string>

std::map<int, std::string> map;
extern YYSTYPE yylval;
extern int noname_yylex(void);
extern int yyparse();
void yyerror(char const *s);

//
//  The lexer keeps this global variable up to date with the line number
//  of the current line read from the input.
//
int curr_lineno = 1;
char *curr_filename = "<stdin>";  // this name is arbitrary
// FILE *fin; // This is the file pointer from which the lexer reads its input.

int yylex(void) {
  int token = noname_yylex();

  if (yydebug) {
    if (token == LONG) {
      fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %ld\n", token,
              map[token].c_str(), yylval.long_v);
    } else if (token == DOUBLE) {
      fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %lf\n", token,
              map[token].c_str(), yylval.double_v);
    } else if (token == ID) {
      fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %s\n", token,
              map[token].c_str(), yylval.id_v);
    } else {
      fprintf(stderr, "\n#TOKEN %d[%s] yytext -> %c\n", token,
              map[token].c_str(), (char)token);
    }
  }

  return token;
}

void division_by_zero(YYLTYPE &yylloc) {
  fprintf(stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
          yylloc.first_line, yylloc.first_column, yylloc.last_line,
          yylloc.last_column);
}

void yyerror(char const *s) {
  fprintf(stderr, "\nERROR: %s\n", s); 
}

void eval(ASTNode* node) {
  fprintf(stderr, "\neval: %s\n", ""); 
}

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
  map[296] = "STR_CONST";
  map[297] = "DOUBLE";
  map[298] = "LONG";
  map[304] = "NEG";
  
  yydebug = 1;

  return yyparse();
}