#include "noname-types.h"

extern void yyerror(const char *error_msg);

explist *newexplist(explist *next_exp_list, ASTNode *node) {
  explist *newexp_list = (explist *) malloc(sizeof(explist));

  if (!newexp_list) {
    yyerror("out of space");
    exit(0);
  }
  newexp_list->next = next_exp_list;
  newexp_list->node = node;
  return newexp_list;
}

arg *create_newarg(char* arg_name) {
  arg *new_arg = (arg *) malloc(sizeof(arg));

  if (!new_arg) {
    yyerror("out of space");
    exit(0);
  }
  new_arg->name = arg_name;
  return new_arg;
}

arg *newarg(char* arg_name, ASTNode* defaultValue) {
  arg *new_arg = create_newarg(arg_name);
  new_arg->defaultValue = defaultValue;
  return new_arg;
}

arg *newarg(char* arg_name, double defaultValue) {
  arg *new_arg = create_newarg(arg_name);
  new_arg->defaultValue = new NumberNode(defaultValue);
  return new_arg;
}
arg *newarg(char* arg_name, long defaultValue) {
  arg *new_arg = create_newarg(arg_name);
  new_arg->defaultValue = new NumberNode(defaultValue);
  return new_arg;
}
arg *newarg(char* arg_name, char* defaultValue) {
  arg *new_arg = create_newarg(arg_name);
  new_arg->defaultValue = new StringNode(defaultValue);
  return new_arg;
}

arglist *newarglist(arglist *next_arg_list, arg* arg) {
  arglist *newarg_list = (arglist *) malloc(sizeof(arglist));

  if (!newarg_list) {
    yyerror("out of space");
    exit(0);
  }
  newarg_list->next = next_arg_list;
  newarg_list->arg = arg;
  return newarg_list;
}

FunctionDefNode* new_function_def(ASTContext& context, const std::string& name, arglist* arg_list, explist* exp_list) {
  FunctionDefNode* node = new FunctionDefNode(name, std::move(arg_list), std::move(exp_list));
  context.storeFunction(name, node);
  // fprintf(stderr, "\n[stmt - assignment]: ");
  return node;
}
