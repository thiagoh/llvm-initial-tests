#include "noname-parse.h"
#include "noname-types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>

extern YYSTYPE yylval;
extern char *noname_yytext;
extern int curr_lineno;

#define yytext noname_yytext
#define MAX_STR_CONST 1025
char string_buf[MAX_STR_CONST]; /* to assemble string constants */

char *string_buf_ptr;
unsigned int string_buf_left;
bool string_error;

int str_write(char *str, unsigned int len) {
  if (len < string_buf_left) {
    strncpy(string_buf_ptr, str, len);
    string_buf_ptr += len;
    string_buf_left -= len;
    return 0;
  } else {
    string_error = true;
    yylval.error_msg = "String constant too long";
    return -1;
  }
}

int null_character_err() {
  yylval.error_msg = "String contains null character";
  string_error = true;
  return -1;
}

char *backslash_common() {
  char *c = &yytext[1];
  if (*c == '\n') {
    curr_lineno++;
  }
  return c;
}