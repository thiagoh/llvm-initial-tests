#ifndef _NONAME_PARSE_H
#define _NONAME_PARSE_H

#include "copyright.h"

#ifndef _NONAME_H_
#define _NONAME_H_

#include "noname-io.h"

/* a type renaming */
// typedef int bool;

bool copy_bool(bool);
void assert_bool(bool);
void dump_bool(ostream &, int, bool);

#endif

#include "noname-types.h"

// typedef class Program_class *Program;
// typedef class Class__class *Class_;
// typedef class Feature_class *Feature;
// typedef class Formal_class *Formal;
// typedef class Expression_class *Expression;
// typedef class Case_class *Case;
// typedef list_node<Class_> Classes_class;
// typedef Classes_class *Classes;
// typedef list_node<Feature> Features_class;
// typedef Features_class *Features;
// typedef list_node<Formal> Formals_class;
// typedef Formals_class *Formals;
// typedef list_node<Expression> Expressions_class;
// typedef Expressions_class *Expressions;
// typedef list_node<Case> Cases_class;
// typedef Cases_class *Cases;


/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LINE_BREAK = 258,
    STMT_SEP = 259,
    LETTER = 260,
    DIGIT = 261,
    DIGITS = 262,
    DARROW = 263,
    ELSE = 264,
    FALSE = 265,
    IF = 266,
    IN = 267,
    LET = 268,
    DEF = 269,
    LOOP = 270,
    THEN = 271,
    WHILE = 272,
    BREAK = 273,
    CASE = 274,
    NEW = 275,
    NOT = 276,
    TRUE = 277,
    NEWLINE = 278,
    NOTNEWLINE = 279,
    WHITESPACE = 280,
    LE = 281,
    ASSIGN = 282,
    NULLCH = 283,
    BACKSLASH = 284,
    STAR = 285,
    NOTSTAR = 286,
    LEFTPAREN = 287,
    NOTLEFTPAREN = 288,
    RIGHTPAREN = 289,
    NOTRIGHTPAREN = 290,
    LINE_COMMENT = 291,
    START_COMMENT = 292,
    END_COMMENT = 293,
    QUOTES = 294,
    ERROR = 295,
    ID = 296,
    STR_CONST = 297,
    DOUBLE = 298,
    LONG = 299,
    NEG = 308
  };
#endif
/* Tokens.  */
#define LINE_BREAK 258
#define STMT_SEP 259
#define LETTER 260
#define DIGIT 261
#define DIGITS 262
#define DARROW 263
#define ELSE 264
#define FALSE 265
#define IF 266
#define IN 267
#define LET 268
#define DEF 269
#define LOOP 270
#define THEN 271
#define WHILE 272
#define BREAK 273
#define CASE 274
#define NEW 275
#define NOT 276
#define TRUE 277
#define NEWLINE 278
#define NOTNEWLINE 279
#define WHITESPACE 280
#define LE 281
#define ASSIGN 282
#define NULLCH 283
#define BACKSLASH 284
#define STAR 285
#define NOTSTAR 286
#define LEFTPAREN 287
#define NOTLEFTPAREN 288
#define RIGHTPAREN 289
#define NOTRIGHTPAREN 290
#define LINE_COMMENT 291
#define START_COMMENT 292
#define END_COMMENT 293
#define QUOTES 294
#define ERROR 295
#define ID 296
#define STR_CONST 297
#define DOUBLE 298
#define LONG 299
#define NEG 308

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 35 "noname.y" /* yacc.c:1915  */

  char* id_v;
  double double_v;
  long long_v;
  explist* exp_list;
  arglist* arg_list;
  arg* arg;

  ASTNode* node;
  char* error_msg;

#line 156 "noname.tab.h" /* yacc.c:1915  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_NONAME_TAB_H_INCLUDED  */
