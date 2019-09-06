%{
#include<bits/stdc++.h>
#include "SymbolInfo.h"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;

void yyerror(char *);


%}

digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v\n]
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer [+-]?{digit}+

%%

{delim}+	{}

"add"       {return ADD; }
"addi"      {return ADDI; }
"sub"       {return SUB; }
"subi"      {return SUBI; }
"and"       {return AND; }
"andi"      {return ANDI; }
"or"        {return OR; }
"ori"       {return ORI; }
"sll"       {return SLL; }
"srl"       {return SRL; }
"nor"       {return NOR; }
"sw"        {return SW; }
"lw"        {return LW; }
"beq"       {return BEQ; }
"bneq"      {return BNEQ; }
"j"         {return J; }
"mov"       {return MOV;}
"jr"        {return JR;}
"movi"       {return MOVI;}

"$t"[0-4]  |
"$zero"    |
"$sp"      {

            SymbolInfo *s = new SymbolInfo(yytext , "REGISTER");
            yylval = (YYSTYPE) s;
            return REGISTER;
            }

"," 	{return COMMA;}
":" 	{return COLON;}
"("     {return LPAREN;}
")"     {return RPAREN;}


{integer}	{
				SymbolInfo *s= new  SymbolInfo(yytext, "CONST_INT");
				yylval = (YYSTYPE)s;
				return CONST_INT;
			}


{id} 		{	 
							
				SymbolInfo *s= new SymbolInfo(yytext, "LABEL");
				yylval = (YYSTYPE)s;
				return LABEL;
			}


%%

int yywrap(void)
{
	return 1;
}


