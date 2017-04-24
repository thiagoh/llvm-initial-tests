#include "noname-types.h"

extern void yyerror(const char *error_msg);

/// LogError* - These are little helper functions for error handling.
ASTNode* logError(const char *str) {

  char msg[1024];
  sprintf(msg, "%s\n", str);
  yyerror(msg);
  // abort();
  // fprintf(stderr, "Error: %s\n", str);
  return NULL;
}

/// LogError* - These are little helper functions for error handling.
FunctionDefNode* logErrorF(const char *str) {
  logError(str);
  return nullptr;
}

explist *newexplist(ASTContext* context, explist *next_exp_list, ASTNode *node) {
  explist *newexp_list = (explist *) malloc(sizeof(explist));

  if (!newexp_list) {
    yyerror("out of space");
    exit(0);
  }
  newexp_list->next = next_exp_list;
  newexp_list->node = node;
  return newexp_list;
}

arg *create_newarg(ASTContext* context, char* arg_name) {
  arg *new_arg = (arg *) malloc(sizeof(arg));

  if (!new_arg) {
    yyerror("out of space");
    exit(0);
  }
  new_arg->name = arg_name;
  return new_arg;
}

arg *newarg(ASTContext* context, char* arg_name, ASTNode* defaultValue) {
  arg *new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = defaultValue;
  return new_arg;
}

arg *newarg(ASTContext* context, char* arg_name, double defaultValue) {
  arg *new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new NumberNode(defaultValue);
  return new_arg;
}
arg *newarg(ASTContext* context, char* arg_name, long defaultValue) {
  arg *new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new NumberNode(defaultValue);
  return new_arg;
}
arg *newarg(ASTContext* context, char* arg_name, char* defaultValue) {
  arg *new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new StringNode(defaultValue);
  return new_arg;
}

arglist *newarglist(ASTContext* context, arglist *next_arg_list, arg* arg) {
  arglist *newarg_list = (arglist *) malloc(sizeof(arglist));

  if (!newarg_list) {
    yyerror("out of space");
    exit(0);
  }
  newarg_list->next = next_arg_list;
  newarg_list->arg = arg;
  return newarg_list;
}

FunctionDefNode* new_function_def(ASTContext* context, const std::string& name, arglist* arg_list, explist* exp_list) {
  FunctionDefNode* node = new FunctionDefNode(name, std::move(arg_list), std::move(exp_list));

  ASTContext* parent = context->getParent();

  FunctionDefNode* functionNode = parent->getFunction(name);
  if (functionNode) {
    return logErrorF("\nFunction already exists in this context!");
  }
  
  parent->storeFunction(name, node);

  fprintf(stderr, "\n[new_function_def]: %s", parent->getName().c_str());
  fprintf(stderr, "\n[new_function_def]: %s", parent->getName().c_str());
  fprintf(stderr, "\n[new_function_def]: %s", parent->getName().c_str());
  return node;
}

// FunctionDefNode* new_function_def(ASTContext& context, const std::string& name, arglist* arg_list, explist* exp_list) {
//   FunctionDefNode* node = new FunctionDefNode(name, std::move(arg_list), std::move(exp_list));

//   ASTContext* parent = context.getParent();
//   parent.storeFunction(name, node);
//   // fprintf(stderr, "\n[stmt - assignment]: ");
//   return node;
// }
