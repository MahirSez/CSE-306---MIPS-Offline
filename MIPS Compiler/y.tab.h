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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ADD = 258,
    ADDI = 259,
    SUB = 260,
    SUBI = 261,
    AND = 262,
    ANDI = 263,
    OR = 264,
    ORI = 265,
    SLL = 266,
    SRL = 267,
    NOR = 268,
    SW = 269,
    LW = 270,
    BEQ = 271,
    BNEQ = 272,
    J = 273,
    MOV = 274,
    JR = 275,
    MOVI = 276,
    REGISTER = 277,
    COMMA = 278,
    CONST_INT = 279,
    COLON = 280,
    LABEL = 281,
    LPAREN = 282,
    RPAREN = 283
  };
#endif
/* Tokens.  */
#define ADD 258
#define ADDI 259
#define SUB 260
#define SUBI 261
#define AND 262
#define ANDI 263
#define OR 264
#define ORI 265
#define SLL 266
#define SRL 267
#define NOR 268
#define SW 269
#define LW 270
#define BEQ 271
#define BNEQ 272
#define J 273
#define MOV 274
#define JR 275
#define MOVI 276
#define REGISTER 277
#define COMMA 278
#define CONST_INT 279
#define COLON 280
#define LABEL 281
#define LPAREN 282
#define RPAREN 283

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef  SymbolInfo*  YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
