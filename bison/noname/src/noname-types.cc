#include "lexer-utilities.h"
#include "noname-parse.h"
#include "noname-types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <memory>

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

class BinaryExpNode : public ASTNode {
 private:
  char op;
  std::unique_ptr<ASTNode> lhs, rhs;
 public:
  BinaryExpNode(char op, std::unique_ptr<ASTNode> lhs, std::unique_ptr<ASTNode> rhs)
      : op(op), lhs(std::move(lhs)), rhs(std::move(rhs)) {}
};