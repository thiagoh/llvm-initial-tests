%{
  #include "stdio.h"
  #include "stdlib.h"
  #include <iostream>
  #include <string>
  #include "noname-parse.h"

  // struct pcdata {};

  /* The compiler assumes these identifiers. */
  // #define yylval noname_yylval
  // #define yylex noname_yylex

  // int yylex(void);
  // void yyerror(const char *);
  // int main(const int len, char** argv);
  int num_lines = 0, num_chars = 0;

  /* Max size of string constants */
  // #define MAX_STR_CONST 1025
  #define YY_NO_UNPUT   /* keep g++ happy */
  extern FILE *fin; /* we read from this file */

  // /* define YY_INPUT so we read from the FILE fin:
  // * This change makes it possible to use this scanner in
  // * the Cool compiler.
  // */
  #undef YY_INPUT
  #define YY_INPUT(buf,result,max_size) \
    if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
      YY_FATAL_ERROR( "read() in flex scanner failed");

  // char string_buf[MAX_STR_CONST]; /* to assemble string constants */
  // char *string_buf_ptr;

  // extern int curr_lineno;
  // extern int verbose_flag;

  // extern YYSTYPE noname_yylval;
  // extern int yylex(void);

  //
  //  The lexer keeps this global variable up to date with the line number
  //  of the current line read from the input.
  //
  int curr_lineno = 1;
  char *curr_filename = "<stdin>"; // this name is arbitrary
  FILE *fin; // This is the file pointer from which the lexer reads its input.

  //
  //  noname_yylex() is the function produced by flex. It returns the next
  //  token each time it is called.
  //
  // #define YY_DECL extern int noname_yylex()

  // #define YY_DECL int yylex()
  // #define YY_DECL int noname_yylex(YYSTYPE * yylval_param , yyscan_t yyscanner)
  // extern int noname_yylex(YYSTYPE * yylval_param , yyscan_t yyscanner);
  #define YY_DECL int noname_yylex(YYSTYPE * yylval_param, YYLTYPE* llocp, yyscan_t yyscanner)
  extern int noname_yylex(YYSTYPE * yylval_param, YYLTYPE* llocp, yyscan_t yyscanner);
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
  // extern void dump_noname_token(ostream &out, int lineno, int token, YYSTYPE yylval);


%}

  // %option noyywrap nounput batch debug yylineno
%option warn noyywrap nodefault yylineno reentrant bison-bridge 

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

<INITIAL>.                       { yylval->error_msg = yytext; return 0; }

%%

  // int main(const int len, char** argv) {
  //   yylex();
  //   printf("%s", buffer.c_str());
  //   printf( "# of lines = %d, # of chars = %d\n", num_lines, num_chars );
  //   return 0;
  // }