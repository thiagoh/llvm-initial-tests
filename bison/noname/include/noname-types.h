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
#include "noname-parse.h"
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

class ASTNode {
 public:
  virtual ~ASTNode() = default;
};

class NumberNode : public ASTNode {
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
};

class VarNode : public ASTNode {
 private:
  std::string name;

 public:
  VarNode(const std::string &name) : name(name) {}
  const std::string &getName() const { return name; }
};

class UnaryExpNode : public ASTNode {
 private:
  char op;
  std::unique_ptr<ASTNode> lhs;
 public:
  UnaryExpNode(char op, std::unique_ptr<ASTNode> lhs)
      : op(op), lhs(std::move(lhs)) {}
  UnaryExpNode(char op, ASTNode* lhs)
      : op(op), lhs(std::unique_ptr<ASTNode>(std::move(lhs))) {}
};

class BinaryExpNode : public ASTNode {
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
};

class AssignmentNode : public ASTNode {
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
};

class DeclarationNode : public ASTNode {
 private:
  std::string name;
 public:
  DeclarationNode(const std::string &name)
      : name(name) {}
};




#endif