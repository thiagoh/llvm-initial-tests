#include "noname-types.h"

extern void yyerror(const char *error_msg);

struct explist *newexplist(struct explist *explist, ASTNode *node) {
  struct explist *newexplist = (struct explist *) malloc(sizeof(struct explist));

  if (!newexplist) {
    yyerror("out of space");
    exit(0);
  }
  newexplist->next = explist;
  newexplist->node = node;
  return newexplist;
}