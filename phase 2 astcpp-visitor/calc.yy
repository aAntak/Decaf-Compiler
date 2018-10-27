/* $Id$ -*- mode: c++ -*- */
/** \file parser.yy Contains the example Bison parser source */

%{ /*** C/C++ Declarations ***/

#include <stdio.h>
#include <string>
#include <vector>

#include "ast.h"

%}

/*** yacc/bison Declarations ***/

/* Require bison 2.3 or later */
%require "2.3"

/* add debug output code to generated parser. disable this for release
 * versions. */
%debug

/* start symbol is named "start" */
%start line

/* write out a header file containing the token defines */
%defines

/* use newer C++ skeleton file */
%skeleton "lalr1.cc"

/* namespace to enclose parser in */
%name-prefix="decaf"

/* set the parser's class identifier */
%define "parser_class_name" "Parser"

/* keep track of the current position within the input */
%locations
%initial-action
{
    // initialize the initial location object
    @$.begin.filename = @$.end.filename = &driver.streamname;
};

/* The driver is passed by reference to the parser and to the scanner. This
 * provides a simple but effective pure interface, not relying on global
 * variables. */
%parse-param { class Driver& driver }

/* verbose error messages */
%error-verbose

/*** BEGIN EXAMPLE - Change the example grammar's tokens below ***/

%union {
	int  			integerVal;
    ASTnode*		astnode;
}

%type <astnode>	line  

//%destructor { delete $$; } expr

 /*** END EXAMPLE - Change the example grammar's tokens above ***/

%{

#include "driver.h"
#include "scanner.h"

/* this "connects" the bison parser in the driver to the flex scanner class
 * object. it defines the yylex() function call to pull the next token from the
 * current lexer object of the driver context. */
#undef yylex
#define yylex driver.lexer->lex

%}

%token END 0
%token EOL
%token CLASS
%token PROGRAM
%token COMMENT
%token VOID
%token L_FLO
%token R_FLO
%token L_SQ
%token R_SQ
%token L_P
%token R_P
%token EQ
%token PE
%token ME
%token COMMA
%token SEMI
%token ID
%token BOOLEAN
%token INT
%token INTEGER_LIT
%token HEX_LIT
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token LT
%token GT
%token NOT
%token CHAR_LIT
%token TRUE
%token FALSE
%token NE
%token DO
%token GE
%token DA
%token LE
%token DE
%token CALLOUT
%token STRING_LIT
%token RETURN
%token BREAK
%token CONTINUE
%token IF
%token ELSE
%token FOR

%left ADD SUB
%left MUL DIV MOD
%left LE GE LT GT DE NE DA DO
%right NOT

%%

line :  CLASS PROGRAM L_FLO  R_FLO { $$ = new ProgramASTnode("Program"); driver.ast.root = $$;}

field_decl_list : field_decl | field_decl_list field_decl

field_decl : type decl_list SEMI

decl_list : decl | decl_list  COMMA decl

decl : ID | ID L_SQ intlit R_SQ

type : INT | BOOLEAN;

intlit : HEX_LIT | INTEGER_LIT





%%

void decaf::Parser::error(const Parser::location_type& l,
			    const std::string& m)
{
    driver.error(l, m);
}
