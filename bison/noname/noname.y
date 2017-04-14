/* Infix notation calculator.  */
%{

  #include <stdlib.h> /* malloc. */
  #include <string.h> /* strlen. */
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

  /* Function type.  */
  // typedef double (*func_t) (double);

  /* Data type for links in the chain of symbols.  */
  struct symrec {
    char *name;  /* name of symbol */
    int type;    /* type of symbol: either VAR or FNCT */
    union {
      double doublev;      /* value of a VAR */
      int intv;         /* value of a VAR */
      // func_t fnctptr;  /* value of a FNCT */
    } value;
    struct symrec *next;  /* link field */
  };
  typedef struct symrec symrec;
  
  typedef struct YYSTYPE {
      char* idv;
      char charv;
      double doublev;
      int intv;
      symrec* symrecv;
  } YYSTYPE;

  // YYLTYPE yylloc;
  
  int line_number;
  char buf[1024 * 8];
  int yylex (void);
  void yyerror (char const *);
  
  symrec * putsym (char const *sym_name, int sym_type);
  symrec * getsym (char const *sym_name);

  // void division_by_zero();
  void division_by_zero(YYLTYPE yylloc);
  
%}
/* Bison declarations.  */
%define parse.error verbose
%token LET STMT_SEP
%token <idv> ID              "identifier"
%token <doublev> NUM         "number"
%token <charv> '+'           "operator +"
%token <charv> '-'           "operator -"
%token <charv> '/'           "operator /"
%token <charv> '*'           "operator *"
%token <charv> '^'           "operator ^"
%type  <symrecv> assignment  "assignment"
%type  <symrecv> declaration "declaration"
%type  <symrecv> exp         "expression"
%type  <symrecv> stmt        "statement"

%left '-' '+'
%left '*' '/'
%right '^'        /* exponentiation */
%precedence NEG   /* negation--unary minus */

%% /* The grammar follows.  */

prog:
  %empty
  | prog stmt 
  | prog STMT_SEP
;

stmt:
  exp STMT_SEP               { printf("\n[stmt]"); }
  | declaration STMT_SEP     { printf("\n[stmt]"); }
  | assignment STMT_SEP      { printf("\n[stmt]"); }
  | error STMT_SEP           { printf("%d:%d", @1.first_column, @1.last_column); }
;

assignment:
  LET ID '=' exp             { $$ = $4; printf("\n[assignment]"); }
;

declaration:
  LET ID                     { printf("\n[declaration]"); }
;

exp:
  NUM {
    $$ = (symrec *) malloc (sizeof (symrec));
    $$->name = (char*) "__annon";
    $$->value.doublev = $1;
    printf("\nexp %lf", $1);
  }
  // | error                 { printf("ERROR3"); }
  // | exp '+' exp        { $$ = $1 intv $3; }
  // | exp '-' exp        { $$ = $1 - $3; }
  // | exp '*' exp        { $$ = $1 * $3; }
  // | exp '/' exp {
  //     if ($3) {
  //       $$ = $1 / $3;
  //     } else {
  //       $$ = 1;
  //       division_by_zero(@3);
  //     }
  //   }
  // | '-' exp  %prec NEG {
  //     /**
  //       * The %prec simply instructs Bison that the rule ‘| '-' exp’ 
  //       * has the same precedence as NEG—in this case the next-to-highest
  //       */
  //     $$ = -$2;          
  //   }
  // | exp '^' exp        { $$ = pow ($1, $3); }
  // | '(' exp ')'        { $$ = $2; }
  ;
%%

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */

int yylex (void) {
  int c;
  /* Skip white space.  */
  while ((c = getchar()) == ' ' || c == '\t')
    ++yylloc.last_column;
  printf("\nchar -> %c", c); 
  /* Step.  */
  yylloc.first_line = yylloc.last_line;
  yylloc.first_column = yylloc.last_column;
  /* Process numbers.  */

  if (c == '.' || isdigit(c)) {
    // ungetc(c, stdin);
    char* doubleBuf = new char[64];
    char* doubleBufBegin = doubleBuf;
    int dix = 0;
    do {
      ++yylloc.last_column;
      *doubleBuf = c;
      doubleBuf++;
      dix++;
      c = getchar();
    } while(c == '.' || isdigit(c));
    *doubleBuf = '\0';
    double val = strtod(doubleBufBegin, 0);
    yylval.doublev = val;
    // sscanf(doubleBuf, "%lf", &val);
    // printf("\nhere %s %lf \nhere %s %lf", &doubleBuf[0], val, &doubleBuf[0], val);
    return NUM;
  }
  
  /* Return end-of-input.  */
  if (c == EOF)
    return 0;
  if (c == 'l') {
    ++yylloc.last_line;
    printf("\nLET");
    return LET;
  }
  if (isalpha(c)) {
    char* s = new char[1];
    *s = c;
    yylval.idv = s;
    ++yylloc.last_line;
    return ID;
  }
  if (c == ';') {
    ++yylloc.last_line;
    printf("\nSTMT_SEP");
    return STMT_SEP;
  }
  /* Return a single char, and update location.  */
  if (c == '\n') {
    printf("\nSTMT_SEP");
    ++line_number;
      ++yylloc.last_line;
      yylloc.last_column = 0;
      return STMT_SEP;
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

symrec * putsym (char const *sym_name, int sym_type) {

  // symrec *ptr = (symrec *) malloc (sizeof (symrec));
  // ptr->name = (char *) malloc (strlen (sym_name) + 1);
  // strcpy (ptr->name,sym_name);
  // ptr->type = sym_type;
  // ptr->value.doublev = 0; /* Set value to 0 even if fctn.  */
  // ptr->next = (struct symrec *)sym_table;
  // sym_table = ptr;
  // return ptr;
  return 0;
}

symrec * getsym (char const *sym_name) {

  // symrec *ptr;

  // for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
  //   if (strcmp (ptr->name, sym_name) == 0)
  //     return ptr;
  return 0;
}

/* Called by yyparse on error.  */
void yyerror(char const *s) {
  fprintf (stderr, "ERROR: %s\n", s);
}

void division_by_zero(YYLTYPE yylloc) {
  fprintf (stderr, "SEVERE ERROR %d:%d - %d:%d. Division by zero",
                   yylloc.first_line, yylloc.first_column,
                   yylloc.last_line, yylloc.last_column);
}