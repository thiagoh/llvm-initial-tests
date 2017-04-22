#ifndef _NONAME_TREE_H
#define _NONAME_TREE_H

#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/GVN.h"

#include "lexer-utilities.h"
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

using namespace llvm;
// using namespace llvm::orc;


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

#ifndef AST_NODE_TYPE
#define AST_NODE_TYPE
enum ast_node_type {
  AST_NODE_TYPE_AST_NODE =        32,
  AST_NODE_TYPE_EXP_NODE =        33,
  AST_NODE_TYPE_NUMBER =          34,
  AST_NODE_TYPE_VARIABLE =        35,
  AST_NODE_TYPE_STRING =          36,
  AST_NODE_TYPE_UNARY_EXP =       37,
  AST_NODE_TYPE_BINARY =          38,
  AST_NODE_TYPE_CALL_EXP =        39,
};
#endif

#define AST_NODE_TYPE_AST_NODE    32
#define AST_NODE_TYPE_EXP_NODE    33
#define AST_NODE_TYPE_NUMBER      34
#define AST_NODE_TYPE_VARIABLE    35
#define AST_NODE_TYPE_STRING      36
#define AST_NODE_TYPE_UNARY_EXP   37
#define AST_NODE_TYPE_BINARY      38
#define AST_NODE_TYPE_CALL_EXP    39

class ASTNode;
class ExpNode;
class NodeValue;

/* list of symbols, for an argument list */
struct explist {
  ASTNode* node;
  struct explist *next;
};
/* list of args, for an argument list */
struct arg {
  char* name;
  ASTNode* defaultValue;
};
struct arglist {
  struct arg* arg;
  struct arglist *next;
};

typedef struct explist explist;
typedef struct arglist arglist;
typedef struct arg arg;

class ASTNode {
 public:
  virtual ~ASTNode() = default;
  virtual int getType() const {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_AST_NODE;
  };
};

template <typename To, typename From>
struct is_of_type_impl {
  static inline bool doit(const From &from) {
    // fprintf(stderr, "\ncomparing %d with %d", from.getType(), To::getClassType());
    return from.getType() == To::getClassType() || std::is_base_of<To, From>::value;
  }
};

template <class To, class From> inline bool is_of_type(const From &from) {
  return is_of_type_impl<To, From>::doit(from);
}

class NodeValue {
  int type;
  void* value;
 public:
  NodeValue(int value) : type(TYPE_INT), value(0) {
    this->value = new int;
    memcpy(this->value, &value, sizeof(int));
  }
  NodeValue(double value) : type(TYPE_DOUBLE), value(0) {
    this->value = new double;
    memcpy(this->value, &value, sizeof(double));
  }
  NodeValue(long value) : type(TYPE_LONG), value(0) {
    this->value = new long;
    memcpy(this->value, &value, sizeof(long));
  }
  int getType() {
    return type;
  }
  void* getValue() {
    return value;
  }
};

class ExpNode : public ASTNode {
  public:
  virtual ~ExpNode() = default;

  virtual NodeValue* getValue() = 0;
  
  virtual int getType() const {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_EXP_NODE;
  };
};

class NumberNode : public ExpNode {
 private:
  void *value;
  int type;

 public:
  NumberNode(double val) : type(TYPE_DOUBLE) {
    value = new double;
    memcpy(value, &val, sizeof(double));
  };
  NumberNode(int val) : type(TYPE_INT) {
    value = new int;
    memcpy(value, &val, sizeof(int));
  };
  NumberNode(long val) : type(TYPE_LONG) {
    value = new long;
    memcpy(value, &val, sizeof(long));
  };

  NodeValue* getValue() override {

    if (type == TYPE_DOUBLE) {
      return new NodeValue(*(double*) value);
    }
    if (type == TYPE_LONG) {
      return new NodeValue(*(long*) value);
    }
    if (type == TYPE_INT) {
      return new NodeValue(*(int*) value);
    }
    return NULL;
  }

  int getType() const override {
    return getClassType();
  };

  static int getClassType() {
    return AST_NODE_TYPE_NUMBER;
  };
};

class StringNode : public ExpNode {
 private:
  std::string value;

 public:
  StringNode(std::string &value) : value(value) {
  };
  StringNode(const char* value) : value(std::string(value)) {
  };

  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_STRING;
  };

  NodeValue* getValue() override {
    return 0;
  }
};

class VarNode : public ExpNode {
 private:
  std::string name;

 public:
  VarNode(const std::string &name) : name(name) {}
  const std::string &getName() const { return name; }

  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_VARIABLE;
  };

  NodeValue* getValue() override {
    return 0;
  }
};

class UnaryExpNode : public ExpNode {
 private:
  char op;
  std::unique_ptr<ASTNode> lhs;
 public:
  UnaryExpNode(char op, std::unique_ptr<ASTNode> lhs)
      : op(op), lhs(std::move(lhs)) {}
  UnaryExpNode(char op, ASTNode* lhs)
      : op(op), lhs(std::unique_ptr<ASTNode>(std::move(lhs))) {}

  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_UNARY_EXP;
  };

  NodeValue* getValue() override {
    return 0;
  }
};

class BinaryExpNode : public ExpNode {
 private:
  char op;
  std::unique_ptr<ASTNode> lhs, rhs;
 public:
  BinaryExpNode(char op, std::unique_ptr<ASTNode> lhs, std::unique_ptr<ASTNode> rhs)
      : op(op), 
      lhs(std::move(lhs)), 
      rhs(std::move(rhs)) {}
  BinaryExpNode(char op, ASTNode* lhs, ASTNode* rhs)
      : op(op), 
      lhs(std::unique_ptr<ASTNode>(std::move(lhs))), 
      rhs(std::unique_ptr<ASTNode>(std::move(rhs))) {}

  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_BINARY;
  };

  NodeValue* getValue() override {
    return 0;
  }
};

/// CallExprNode - Expression class for function calls.
class CallExprNode : public ExpNode {
 private:
  std::string callee;
  std::vector<std::unique_ptr<ASTNode>> args;

public:
  CallExprNode(const std::string &callee, std::vector<std::unique_ptr<ASTNode>> args)
      : callee(callee), args(std::move(args)) {}
  CallExprNode(const std::string &callee, explist* exp_list)
      : callee(callee), args(std::vector<std::unique_ptr<ASTNode>>())  {

    if (exp_list->node) {
      args.push_back(std::unique_ptr<ASTNode>(std::move(exp_list->node)));
    }

    while (exp_list->next) {
      exp_list = exp_list->next;

      if (exp_list->node) {
        args.push_back(std::unique_ptr<ASTNode>(std::move(exp_list->node)));
      }
    }
  }
  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_CALL_EXP;
  };

  const std::string &getCallee() const { return callee; }

  NodeValue* getValue() override {
    return 0;
  }
};

class AssignmentNode : public ExpNode {
 private:
  std::string name;
  std::unique_ptr<ASTNode> rhs;
 public:
  AssignmentNode(const std::string &name, std::unique_ptr<ASTNode> rhs)
      : name(name), 
      rhs(std::move(rhs)) {}
  AssignmentNode(const std::string &name, ASTNode* rhs)
      : name(name), 
      rhs(std::unique_ptr<ASTNode>(std::move(rhs))) {}

  NodeValue* getValue() override {
    return 0;
  }
};

// FunctionDefNode - Node class for function definition.
class FunctionDefNode : public ASTNode {
 private:
  std::string name;
  std::vector<std::unique_ptr<arg>> args;
  std::vector<std::unique_ptr<ASTNode>> body;

public:
  FunctionDefNode(const std::string &name, std::vector<std::unique_ptr<arg>> args, 
      std::vector<std::unique_ptr<ASTNode>> body) 
      : name(name), args(std::move(args)), body(std::move(body)) {}
  FunctionDefNode(const std::string &name, arglist* arg_list, explist* exp_list)
      : name(name), args(std::vector<std::unique_ptr<arg>>()), 
      body(std::vector<std::unique_ptr<ASTNode>>())  {

    if (arg_list->arg) {
      args.push_back(std::unique_ptr<arg>(std::move(arg_list->arg)));
    }

    while (arg_list->next) {
      arg_list = arg_list->next;

      if (arg_list->arg) {
        args.push_back(std::unique_ptr<arg>(std::move(arg_list->arg)));
      }
    }

    if (exp_list->node) {
      body.push_back(std::unique_ptr<ASTNode>(std::move(exp_list->node)));
    }

    while (exp_list->next) {
      exp_list = exp_list->next;

      if (exp_list->node) {
        body.push_back(std::unique_ptr<ASTNode>(std::move(exp_list->node)));
      }
    }
  }

  int getType() const override {
    return getClassType();
  };
  static int getClassType() {
    return AST_NODE_TYPE_CALL_EXP;
  };

  const std::string &getName() const { return name; }
};

class DeclarationNode : public ASTNode {
 private:
  std::string name;
 public:
  DeclarationNode(const std::string &name)
      : name(name) {}
};

explist *newexplist(explist *next_exp_list, ASTNode *node);
arg *newarg(char* arg, ASTNode* defaultValue);
arg *newarg(char* arg, double defaultValue);
arg *newarg(char* arg, long defaultValue);
arg *newarg(char* arg, char* defaultValue);
arglist *newarglist(arglist *next_arg_list, arg* arg);

#endif