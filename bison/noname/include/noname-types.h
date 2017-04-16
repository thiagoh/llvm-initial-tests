#ifndef _NONAME_TREE_H
#define _NONAME_TREE_H

/* Data type for links in the chain of symbols.  */
struct symrec {
  char *name; /* name of symbol */
  int type;   /* type of symbol: either VAR or FNCT */
  union {
    char charv;
    short shortv;
    int intv;
    float floatv;
    long longv;
    double doublev;
    // func_t fnctptr;  /* value of a FNCT */
  } value;
  struct symrec *next; /* link field */
};
typedef struct symrec symrec;
typedef struct symrec* symrecv;

/* Token type.  */
#ifndef YYTOKENTYPE
#define YYTOKENTYPE
enum yytokentype {
  TYPE_CHAR = 32,
  TYPE_SHORT = 33,
  TYPE_INT = 34,
  TYPE_FLOAT = 35,
  TYPE_LONG = 36,
  TYPE_DOUBLE = 37,
};
#endif

#define TYPE_CHAR 32
#define TYPE_SHORT 33
#define TYPE_INT 34
#define TYPE_FLOAT 35
#define TYPE_LONG 36
#define TYPE_DOUBLE 37

#endif