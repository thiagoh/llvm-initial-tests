#ifndef _NONAME_TREE_H
#define _NONAME_TREE_H

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

#endif