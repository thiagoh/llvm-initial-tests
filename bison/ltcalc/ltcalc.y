/* Infix notation calculator.  */
%{

  #include <ctype.h>
  #include <stdio.h>
  #include <math.h>
  #include <math.h>
  #include <stdio.h>

  #define YYLTYPE YYLTYPE
  typedef struct YYLTYPE {
      int first_line;
      int first_column;
      int last_line;
      int last_column;
    } YYLTYPE;

  // YYLTYPE yylloc;
  
  int line_number;
  int yylex (void);
  void yyerror (char const *);
  // void division_by_zero();
  void division_by_zero(YYLTYPE yylloc);
  
%}
/* Bison declarations.  */
%define api.value.type {double}

%token NUM
%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */
%precedence NEG   /* negation--unary minus */

%% /* The grammar follows.  */

input:
  %empty
  | input line
;
line:
  '\n'
  | exp '\n'  { printf ("line %d: %.10g\n", line_number, $1); }
  | error '\n' { yyerrok; }
;

exp:
  NUM                  { $$ = $1; }
  | exp '+' exp        { $$ = $1 + $3; }
  | exp '-' exp        { $$ = $1 - $3; }
  | exp '*' exp        { $$ = $1 * $3; }
  | exp '/' exp {
    if ($3) {
      $$ = $1 / $3;
    } else {
      $$ = 1;
      // printf("%s", @3);
      division_by_zero(@3);
    }
  }

  | '-' exp  %prec NEG {
      /**
        * The %prec simply instructs Bison that the rule ‘| '-' exp’ 
        * has the same precedence as NEG—in this case the next-to-highest
        */
      $$ = -$2;          
    }
  | exp '^' exp        { $$ = pow ($1, $3); }
  | '(' exp ')'        { $$ = $2; }
  ;
%%

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */


int yylex (void) {
  int c;
  /* Skip white space.  */
  while ((c = getchar ()) == ' ' || c == '\t')
    ++yylloc.last_column;
  /* Step.  */
  yylloc.first_line = yylloc.last_line;
  yylloc.first_column = yylloc.last_column;
  /* Process numbers.  */
  if (isdigit (c))
    {
      yylval = c - '0';
      ++yylloc.last_column;
      while (isdigit (c = getchar ()))
        {
          ++yylloc.last_column;
          yylval = yylval * 10 + c - '0';
        }
      ungetc (c, stdin);
      return NUM;
    }
  /* Return end-of-input.  */
  if (c == EOF)
    return 0;

  /* Return a single char, and update location.  */
  if (c == '\n') {
    ++line_number;
      ++yylloc.last_line;
      yylloc.last_column = 0;
  } else
    ++yylloc.last_column;
  return c;
}

int main (void) {
  line_number = 1;
  yylloc.first_line = yylloc.last_line = 1;
  yylloc.first_column = yylloc.last_column = 0;
  
  return yyparse ();
}

/* Called by yyparse on error.  */
void yyerror (char const *s) {
  fprintf (stderr, "%s\n", s);
}

void division_by_zero(YYLTYPE yylloc) {
  fprintf (stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
                   yylloc.first_line, yylloc.first_column,
                   yylloc.last_line, yylloc.last_column);
  yyerror("");
}