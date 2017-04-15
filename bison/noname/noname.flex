%{
  #include "stdio.h"
  #include "stdlib.h"
  #include "noname-parse.h"

  int num_lines = 0, num_chars = 0;
  extern YYSTYPE yylval;
  // extern int yylex(void);
  extern void yyerror(char const *s);
%}

  // %option noyywrap nounput batch debug yylineno
  // %option warn noyywrap nodefault yylineno reentrant bison-bridge 

%START COMMENT

LINE_BREAK      \n
STMT_SEP        (\n|;)
LETTER          [a-zA-Z]
ALPHA           [a-zA-Z$_]
DIGIT           [0-9]
DIGITS          {DIGIT}+
NUM             {DIGIT}+(\.{DIGIT}+)?
ID              {ALPHA}({ALPHA}|{DIGIT})*

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
ASSIGN          =
LE              <=
DARROW          =>
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
{WHITESPACE}                    {
                                  ++num_chars;
                                }
<COMMENT>.*                     {
                                        num_chars += yyleng;
                                        // print(yytext);
                                }
<INITIAL>{ASSIGN}                { return (ASSIGN); }
<INITIAL>{ELSE}                  { return (ELSE); }
<INITIAL>{IF}                    { return (IF); }
<INITIAL>{IN}                    { return (IN); }
<INITIAL>{LET}                   { return (LET); }
<INITIAL>{THEN}                  { return (THEN); }
<INITIAL>{WHILE}                 { return (WHILE); }
<INITIAL>{CASE}                  { return (CASE); }
<INITIAL>{NEW}                   { return (NEW); }
<INITIAL>{NOT}                   { return (NOT); }
<INITIAL>{STMT_SEP}              { return (STMT_SEP); }
<INITIAL>{ID}                    { return (ID); }
<INITIAL>{NUM}                   { yylval.doublev = atoi(yytext); return (NUM); }

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

<INITIAL>. {
    printf("error '%s'", yytext);
    yylval.error_msg = yytext; return 0; 
  }

%%