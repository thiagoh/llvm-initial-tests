/* Reverse polish notation calculator.  */

%{
  #include <ctype.h>
  #include <stdio.h>
  #include <string>
  #include <math.h>

  struct YYSTYPE {
      int intd;
      char chard;
      double doubled;
      float floatd;
      char* stringd;
  };

  // typedef struct data {
  //   std::string stringd;
  //   int intd;
  //   double doubled;
  //   float floatd;
  // } data;

  #define YYSTYPE struct YYSTYPE
  void compose(YYSTYPE &yylval, const int len, YYSTYPE** args);
  YYSTYPE** fill_args(char op, void** args);
  char buf[1024 * 8];
  int yylex (void);
  void yyerror (char const *);

  YYSTYPE** args;
  void** void_args;
%}

// %define api.value.type {struct data}
// %token NUM
%token <stringd> IDENTIFIER "identifier"
%token <doubled> NUM     "number"
%token <chard> '+'         "operator +"
%token <chard> '-'         "operator -"
%token <chard> '/'         "operator /"
%token <chard> '*'         "operator *"
%token <chard> '^'         "operator ^"
%type  <doubled> exp        "expression"


%% /* Grammar rules and actions follow.  */
input:
  %empty
| input line
;
line:
  '\n'
| exp '\n' {
    printf ("result -> %.10g\n\n", $1); 
  }
;
exp:
  NUM           { $$ = $1;           }
| exp exp '+'   {
    $$ = $1 + $2;
    void_args[0] = &$1;
    void_args[1] = &$2;
    compose(yylval, 3, fill_args($3, void_args));
    printf("%s -> %.10g\n", yylval.stringd, $$);
  }
| exp exp '-'   {
    $$ = $1 - $2;
    void_args[0] = &$1;
    void_args[1] = &$2;
    compose(yylval, 3, fill_args($3, void_args));      
    printf("%s -> %.10g\n", yylval.stringd, $$);
  }
| exp exp '*'   {
    $$ = $1 * $2;
    void_args[0] = &$1;
    void_args[1] = &$2;
    compose(yylval, 3, fill_args($3, void_args));
    printf("%s -> %.10g\n", yylval.stringd, $$);
  }
| exp exp '/'   {
    $$ = $1 / $2;
    void_args[0] = &$1;
    void_args[1] = &$2;
    compose(yylval, 3, fill_args($3, void_args));
    printf("%s -> %.10g\n", yylval.stringd, $$);
  }
| exp exp '^'   {
    $$ = pow ($1, $2);
    void_args[0] = &$1;
    void_args[1] = &$2;
    compose(yylval, 3, fill_args($3, void_args));
    printf("%s -> %.10g\n", yylval.stringd, $$);
  }
| exp 'n'       { $$ = -$1;          }  /* Unary minus    */
;
%%

YYSTYPE** fill_args(char op, void** void_args) {
  YYSTYPE d1, d2, d3;
  d1.doubled = *(double*) void_args[0];
  d2.chard = op;
  d3.doubled = *(double*) void_args[1];

  args[0] = &d1;
  args[1] = &d2;
  args[2] = &d3;
  return args;
}

void compose(YYSTYPE &yylval, const int len, YYSTYPE** args) {

  YYSTYPE d1, d2, d3;
  d1 = (YYSTYPE) *args[0];
  d2 = (YYSTYPE) *args[1];
  d3 = (YYSTYPE) *args[2];
  sprintf(buf, "%lf %c %lf", d1.doubled, d2.chard, d3.doubled);

  yylval.stringd = buf;
}

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */

int yylex (void) {

  int c;
  char buf[2048];
  // yylval.stringd = (char*) "nha";

  /* Skip white space.  */
  while ((c = getchar ()) == ' ' || c == '\t') {
    // char ch = (char) c;
    // strncat(buf, &ch, 1);
    continue;
  }

  if (c == '\n') {
    // yylval.stringd = buf;
    return c;
  }

  if (c == '+' || c == '-' || c == '/' || c == '*' || c == '^') {
      char ch = (char) c;
      yylval.chard = ch;
      return c;
  }

  /* Process numbers.  */
  if (c == '.' || isdigit(c)) {
      ungetc(c, stdin);
      double val;
      scanf("%lf", &val);
      yylval.doubled = val;

      // printf("\n%f\n", val);
      // char str[64];
      // sprintf(buf, "%s%lf", buf, val);
      // yylval.stringd = buf;
      
      return NUM;
    }
  /* Return end-of-input.  */
  if (c == EOF) {
    return 0;
  }

  char ch = (char) c;
  // strncat(buf, &ch, 1);
  yylval.chard = ch;

  /* Return a single char.  */
  return c;
}

int main (void) {
  args = (YYSTYPE**) malloc(sizeof(YYSTYPE)*3);
  void_args = (void**) malloc(sizeof(YYSTYPE)*3);
  return yyparse ();
}

/* Called by yyparse on error.  */
void yyerror (char const *s) {
  fprintf (stderr, "%s\n", s);
}