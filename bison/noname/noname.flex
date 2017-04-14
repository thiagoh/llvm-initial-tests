%{
  #include "stdio.h"
  #include "stdlib.h"
  #include <iostream>
  #include <string>
  #include "noname-parse.h"

  /* The compiler assumes these identifiers. */
  // #define yylval noname_yylval
  // #ifdef yylex
  //   #undef yylex
  // #endif
  // #define yylex noname_yylex

  using namespace std;
  // int yylex(void);
  void yyerror(const char *);
  int main(const int len, char** argv);
  int num_lines = 0, num_chars = 0;
  string buffer = "";
  const char* newline = "\n";
  const char* getLogin();

  /* Max size of string constants */
  #define MAX_STR_CONST 1025
  #define YY_NO_UNPUT   /* keep g++ happy */

  // extern FILE *fin; /* we read from this file */

  // /* define YY_INPUT so we read from the FILE fin:
  // * This change makes it possible to use this scanner in
  // * the Cool compiler.
  // */
  // #undef YY_INPUT
  // #define YY_INPUT(buf,result,max_size) \
  //   if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
  //     YY_FATAL_ERROR( "read() in flex scanner failed");

  char string_buf[MAX_STR_CONST]; /* to assemble string constants */
  char *string_buf_ptr;

  extern int curr_lineno;
  extern int verbose_flag;

  extern YYSTYPE noname_yylval;

%}

  //%option noyywrap nounput batch debug

  void print(const char* v) {
    buffer += v;
    buffer += newline;
  }
  void exec_identifier() {
    num_chars += strlen(yytext);
    print("[IDENTIFIER]");
  }
  void exec_if() {
    num_chars += strlen(yytext);
    print("[IF]");
  }
  void exec_then() {
    num_chars += strlen(yytext);
    print("[THEN]");
  }
  void exec_elsif() {
    num_chars += strlen(yytext);
    print("[ELSIF]");
  }
  void exec_else() {
    num_chars += strlen(yytext);
    print("[ELSE]");
  }
  void exec_lb() {
    ++num_chars;
    ++num_lines;
    print("[LINE_BREAK]");
  }

%START COMMENT

LINE_BREAK      \n
STMT_SEP        (\n|;)
LETTER          [a-zA-Z]
DIGIT           [0-9]
DIGITS          DIGIT+
ID              {LETTER}({LETTER}|{DIGIT})*


DARROW          =>
ELSE            [eE][lL][sS][eE]
FALSE           f[aA][lL][sS][eE]
IF              [iI][fF]
IN              [iI][nN]
LET             [lL][eE][tT]
LOOP            [lL][oO][oO][pP]
THEN            [tT][hH][eE][nN]
WHILE           [wW][hH][iI][lL][eE]
BREAK           [bB][rR][eE][aA][kK]
CASE            [cC][aA][sS][eE]
NEW             [nN][eE][wW]
NOT             [nN][oO][tT]
TRUE            t[rR][uU][eE]
NEWLINE         [\n]
NOTNEWLINE      [^\n]
WHITESPACE      [ \t\r\f\v]+
LE              <=
ASSIGN          =
NULLCH          [\0]
BACKSLASH       [\\]
STAR            [*]
NOTSTAR         [^*]
LEFTPAREN       [(]
NOTLEFTPAREN    [^(]
RIGHTPAREN      [)]
NOTRIGHTPAREN   [^)]

LINE_COMMENT    "--"
START_COMMENT   "/*"
END_COMMENT     "*/"

QUOTES          \"


%%

{LINE_BREAK}                    {
                                        ++num_chars;
                                        ++num_lines;
                                }
<COMMENT>.*                     {
                                        num_chars += yyleng;
                                        // print(yytext);
                                }
<INITIAL>{ELSE}                  { return (ELSE); }
<INITIAL>{IF}                    { return (IF); }
<INITIAL>{IN}                    { return (IN); }
<INITIAL>{LET}                   { return (LET); }
<INITIAL>{THEN}                  { return (THEN); }
<INITIAL>{WHILE}                 { return (WHILE); }
<INITIAL>{CASE}                  { return (CASE); }
<INITIAL>{NEW}                   { return (NEW); }
<INITIAL>{NOT}                   { return (NOT); }
<INITIAL>{DARROW}           		 { return (DARROW); }
<INITIAL>{ASSIGN}                { return (ASSIGN); }
<INITIAL>{LE}                    { return (LE); }
<INITIAL>{STMT_SEP}              { return (STMT_SEP); }

<INITIAL>","                     { return int(','); }
<INITIAL>":"                     { return int(':'); }
<INITIAL>"{"                     { return int('{'); }
<INITIAL>"}"                     { return int('}'); }
<INITIAL>"+"                     { return int('+'); }
<INITIAL>"-"                     { return int('-'); }
<INITIAL>"*"                     { return int('*'); }
<INITIAL>"/"                     { return int('/'); }
<INITIAL>"<"                     { return int('<'); }
<INITIAL>"~"                     { return int('~'); }
<INITIAL>"."                     { return int('.'); }
<INITIAL>"@"                     { return int('@'); }
<INITIAL>"("                     { return int('('); }
<INITIAL>")"                     { return int(')'); }

[ \t]                            ++num_chars;

<INITIAL>.                       { yylval.error_msg = yytext; return 0; }

%%

// int main(const int len, char** argv) {
//   yylex();
//   printf("%s", buffer.c_str());
//   printf( "# of lines = %d, # of chars = %d\n", num_lines, num_chars );
//   return 0;
// }