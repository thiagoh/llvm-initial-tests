%{
  #include "stdio.h"
  #include "stdlib.h"
  #include "lexer-utilities.h"
  #include "noname-parse.h"
  #include "noname-types.h"

  int num_lines = 0, num_chars = 0;
  extern YYSTYPE yylval;
  extern void yyerror(char const *s);
  
  extern int curr_lineno;
  extern int verbose_flag;

  unsigned int comment = 0;
%}

%option noyywrap 
  // %option noyywrap nounput batch debug yylineno
  // %option warn noyywrap nodefault yylineno reentrant bison-bridge 

%x COMMENT
%x STRING

LINE_BREAK      \n
STMT_SEP        ;
LETTER          [a-zA-Z]
ALPHA           [a-zA-Z$_]
DIGIT           [0-9]
DIGITS          {DIGIT}+
LONG            {DIGIT}+
DOUBLE          {DIGIT}+(\.{DIGIT}+)?
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

{START_COMMENT} {
  comment++;
  BEGIN(COMMENT);
}

<COMMENT><<EOF>> {
  yylval.error_msg = "EOF in comment";
  BEGIN(INITIAL);
  return (ERROR);
}

<COMMENT>{BACKSLASH}(.|{NEWLINE}) {
  backslash_common();
};

<COMMENT>{BACKSLASH}               ;

<COMMENT>{START_COMMENT} {
  comment++;
}

<COMMENT>{END_COMMENT} {
  comment--;
  if (comment == 0) {
    BEGIN(INITIAL);
  }
}

<COMMENT>.                      { ++num_chars; }

<INITIAL>{END_COMMENT} {
  yylval.error_msg = "Unmatched */";
  return (ERROR);
}

<*>{WHITESPACE}                  { ++num_chars; }
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
<INITIAL>{ID}      {
  yylval.id_v = strdup(yytext);
  return (ID); }
<INITIAL>{LONG}     {
  yylval.long_v = atoi(strdup(yytext));
  return (LONG); }
<INITIAL>{DOUBLE}  {
  yylval.double_v = atof(strdup(yytext));
  return (DOUBLE); }

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
<INITIAL>"&"                     { return int('&'); }
<INITIAL>";"                     { return int(STMT_SEP); }

<INITIAL>. {
    printf("lexer error '%s'", yytext);
    yylval.error_msg = yytext; return 0; 
  }

%%