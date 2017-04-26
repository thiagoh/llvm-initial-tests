#include "noname-types.h"
#include <stdio.h>
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <memory>
#include <string>
#include <vector>

extern void yyerror(const char* error_msg);

/// LogError* - These are little helper functions for error handling.
ASTNode* logError(const char* str) {
  char msg[1024];
  sprintf(msg, "%s\n", str);
  yyerror(msg);
  // abort();
  // fprintf(stderr, "Error: %s\n", str);
  return NULL;
}

FunctionDefNode* logErrorF(const char* str) {
  logError(str);
  return nullptr;
}

AssignmentNode* logErrorV(const char* str) {
  logError(str);
  return nullptr;
}

stmtlist* newstmtlist(ASTContext* context, stmtlist* next_stmt_list, ASTNode* node) {
  stmtlist* newexp_list = (stmtlist*)malloc(sizeof(stmtlist));

  if (!newexp_list) {
    yyerror("out of space");
    exit(0);
  }
  newexp_list->next = next_stmt_list;
  newexp_list->node = node;
  return newexp_list;
}

explist* newexplist(ASTContext* context, explist* next_exp_list, ExpNode* node) {
  explist* newexp_list = (explist*)malloc(sizeof(explist));

  if (!newexp_list) {
    yyerror("out of space");
    exit(0);
  }
  newexp_list->next = next_exp_list;
  newexp_list->node = node;
  return newexp_list;
}

arg* create_newarg(ASTContext* context, char* arg_name) {
  arg* new_arg = (arg*)malloc(sizeof(arg));

  if (!new_arg) {
    yyerror("out of space");
    exit(0);
  }
  new_arg->name = arg_name;
  return new_arg;
}

arg* newarg(ASTContext* context, char* arg_name, ASTNode* defaultValue) {
  arg* new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = defaultValue;
  return new_arg;
}

arg* newarg(ASTContext* context, char* arg_name, double defaultValue) {
  arg* new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new NumberNode(context, defaultValue);
  return new_arg;
}
arg* newarg(ASTContext* context, char* arg_name, long defaultValue) {
  arg* new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new NumberNode(context, defaultValue);
  return new_arg;
}
arg* newarg(ASTContext* context, char* arg_name, char* defaultValue) {
  arg* new_arg = create_newarg(context, arg_name);
  new_arg->defaultValue = new StringNode(context, defaultValue);
  return new_arg;
}

arglist* newarglist(ASTContext* context, arglist* next_arg_list, arg* arg) {
  arglist* newarg_list = (arglist*)malloc(sizeof(arglist));

  if (!newarg_list) {
    yyerror("out of space");
    exit(0);
  }
  newarg_list->next = next_arg_list;
  newarg_list->arg = arg;
  return newarg_list;
}

VarNode* new_var_node(ASTContext* context, const std::string& name) {
  VarNode* new_node = new VarNode(context, name);
  return new_node;
}
AssignmentNode* new_assignment_node(ASTContext* context, const std::string& name, ExpNode* exp) {
  AssignmentNode* new_node = new AssignmentNode(context, name, exp);
  return new_node;
}
CallExprNode* new_call_node(ASTContext* context, const std::string& name, explist* exp_list) {
  CallExprNode* new_node = new CallExprNode(context, name, exp_list);
  return new_node;
}
AssignmentNode* new_declaration_node(ASTContext* context, const std::string& name) {
  AssignmentNode* new_node = new AssignmentNode(context, name, NULL);

  AssignmentNode* temp_node = context->getVariable(name);
  if (temp_node) {
    return logErrorV("\nVariable already exists in this context!");
  }

  context->store(name, new_node);

  fprintf(stderr, "\n[new_assignment %s]", context->getName().c_str());

  return new_node;
}

FunctionDefNode* new_function_def(ASTContext* context, const std::string& name, arglist* arg_list,
                                  stmtlist* stmt_list) {
  FunctionDefNode* new_node = new FunctionDefNode(context, name, std::move(arg_list), std::move(stmt_list));

  ASTContext* parent = context->getParent();

  FunctionDefNode* functionNode = parent->getFunction(name);
  if (functionNode) {
    return logErrorF("\nFunction already exists in this context!");
  }

  parent->store(name, new_node);

  fprintf(stderr, "\n[new_function_def %s]", parent->getName().c_str());
  return new_node;
}

void CallExprNode::eval() {

  NodeValue* node_value = getValue();
}

NodeValue* CallExprNode::getValue() {
  ASTContext* context = getContext();
  FunctionDefNode* functionNode = context->getFunction(getCallee());

  if (!functionNode) {
    fprintf(stderr, "\n\nThe called function was: '%s' BUT it wan not found on the context\n", getCallee().c_str());
    return 0;
  }

  std::vector<std::unique_ptr<ExpNode>>* valueArgs = &getArgs();
  std::vector<std::unique_ptr<ExpNode>>::iterator itValueArg = valueArgs->begin();
  std::vector<std::unique_ptr<arg>>* signatureArgs = &functionNode->getArgs();
  std::vector<std::unique_ptr<arg>>::iterator itSignatureArg = signatureArgs->begin();
  std::vector<std::unique_ptr<ASTNode>>* bodyNodes = &functionNode->getBody();
  std::vector<std::unique_ptr<ASTNode>>::iterator itBodyNodes = bodyNodes->begin();

  for (; itSignatureArg != signatureArgs->end() || itValueArg != valueArgs->end();) {
    std::unique_ptr<ExpNode>& valueArg = *itValueArg;
    std::unique_ptr<arg>& signatureArg = *itSignatureArg;

    AssignmentNode* assignment_node = new AssignmentNode(context, signatureArg.get()->name, valueArg.get());
    context->store(signatureArg.get()->name, assignment_node);

    ++itSignatureArg;
    ++itValueArg;
  }

  for (; itBodyNodes != bodyNodes->end();) {
    std::unique_ptr<ASTNode>& bodyNode = *itBodyNodes;
    bodyNode.get()->eval();

    fprintf(stderr, "\neval ASTNode of type %d\n", bodyNode.get()->getType());
    ++itBodyNodes;
  }

  return 0;
}
