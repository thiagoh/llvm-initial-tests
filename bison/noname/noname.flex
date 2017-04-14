%{
#include "stdio.h"
#include "stdlib.h"
#include <iostream>
#include <string>

using namespace std;
%}

  int yylex(void);
  void yyerror(const char *);
  int num_lines = 0, num_chars = 0;
  string buffer = "";
  const char* newline = "\n";
  const char* getLogin();
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

START_COMMENT   [/][*]
END_COMMENT     [*][/]

LINE_BREAK      \n
LETTER          [a-zA-Z]
DIGIT           [0-9]
DIGITS          DIGIT+
IF              if
ELSE            else
ELSIF           elsif
THEN            then
DONE            done
DO              do
BREAK           break
ID              {LETTER}({LETTER}|{DIGIT})*
%%

<INITIAL>{START_COMMENT}        {print("[START_COMMENT]"); BEGIN COMMENT;}
<COMMENT>{START_COMMENT}        {
                                        num_chars += yyleng;
                                        print("[DISCARDED]\n");
                                }
<COMMENT>{END_COMMENT}          {
                                        num_chars += yyleng;
                                        print("[END_COMMENT]");
                                        BEGIN 0;
                                }
<COMMENT>{LINE_BREAK}           {
                                        ++num_chars;
                                        ++num_lines;
                                }
<COMMENT>.*                     {
                                        num_chars += yyleng;
                                        // print(yytext);
                                }

{IF}            exec_if();
{THEN}          exec_then();
{ELSIF}         exec_elsif();
{ELSE}          exec_else();
username        printf("%s", getLogin());
{ID}            exec_identifier();
{LINE_BREAK}    exec_lb();
[ \t]           ++num_chars;
.               ++num_chars;

%%
const char* getLogin() {
        const char* text = "my login";
        num_chars += yyleng;
        num_chars += strlen(text);
        return text;
}
main() {
        yylex();
        printf("%s", buffer.c_str());
        printf( "# of lines = %d, # of chars = %d\n", num_lines, num_chars );
}
