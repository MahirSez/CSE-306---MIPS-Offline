%{
#include<bits/stdc++.h>
#include "SymbolInfo.h"


using namespace std;

int yyparse(void);
int yylex(void);


extern FILE *yyin;

FILE *fp  , *outputFile;
int instruction_count;

void yyerror(char *s)
{
	cout<<"Syntax error at line "<<instruction_count<<endl;
}

map<string , int >jmpAt ;
map<string,string> machineCode , registerID;
bool secondPass;




string toHex(int num , int tgt) {

    

    string str = "";

    while(num) {

        int rem = num%16;

        if( rem < 10 ) str += char(rem + '0');
        else {
            rem %= 10;
            str += char('A' + rem);
        }
        num/=16;
    }

    while(str.size() < tgt) str += '0';
    reverse(str.begin() , str.end());
    
    return str;
}
string toHex(string ss,int tgt) {
    
    int num = 0;

    for(int i =0 ; i < ss.size() ; i++ ) {

        num *= 10;

        num += (ss[i] - '0');
    }
    
    return toHex(num , tgt);
    
}



void initialize() {


    string pattern = "IDFGJMLHOKNCBEAP";

    vector<string>ops;


    ops.push_back("add");
    ops.push_back("addi");
    ops.push_back("sub");
    ops.push_back("subi");
    ops.push_back("and");
    ops.push_back("andi");
    ops.push_back("or");
    ops.push_back("ori");
    ops.push_back("sll");
    ops.push_back("srl");
    ops.push_back("nor");
    ops.push_back("sw");
    ops.push_back("lw");
    ops.push_back("beq");
    ops.push_back("bneq");
    ops.push_back("j");


    for(int i =0 ; i < ops.size() ; i++ ) {
        
        int num =  (pattern[i] - 'A') ;
        machineCode[ops[i]] = toHex(num , 1);
    }

    // for(int i= 0 ; i < ops.size() ; i++ ) {
    //     cout<<i<<" "<<machineCode[ops[i]]<<" "<<(pattern[i]-'A')<<endl;
    // }

    registerID["$zero"] = "0";
    registerID["$t0"] = "1";
    registerID["$t1"] = "2";
    registerID["$t2"] = "3";
    registerID["$t3"] = "4";
    registerID["$t4"] = "5";
    registerID["$sp"] = "6";


}


%}

%define api.value.type { SymbolInfo* }

%token ADD  ADDI  SUB  SUBI  AND  ANDI  OR  ORI  SLL  SRL  NOR  SW  LW  BEQ  BNEQ  J
%token REGISTER   COMMA  CONST_INT   COLON  LABEL   LPAREN RPAREN

%%


start:	program	{

			$$ = $1;
            fprintf(outputFile , "%s\n" , $$->code.c_str() );
			
		}

program:	program unit {

				$$ = new SymbolInfo() ;
				$$->code = $1->code + $2->code;
			}
			| unit	{ 
				$$ = $1 ;
			}
			;

	
unit:	LABEL COLON	{ 
			$$ = $1 ;
            jmpAt[$$->getName()] = instruction_count;
		}
 		|	expression	{
			$$ = $1 ;
            instruction_count++;
			
		};
     
expression: ADD  REGISTER COMMA REGISTER COMMA REGISTER 	{

                $$ = new SymbolInfo();
                string op = machineCode["add"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID[$6->getName()];

                $$->code = op + s1 + s2 + dst + "0\n";

			}
			|   ADDI REGISTER COMMA REGISTER COMMA CONST_INT    {

                $$ = new SymbolInfo();
                string op = machineCode["addi"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string imm = toHex($6->getName() , 2); 

                $$->code = op + s1 + dst +  imm  + "\n";
            }
            |   SUB  REGISTER COMMA REGISTER COMMA REGISTER    {

                $$ = new SymbolInfo();
                string op = machineCode["sub"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID[$6->getName()];

                $$->code = op + s1 + s2 + dst + "0\n";
            }
            |   SUBI REGISTER COMMA REGISTER COMMA CONST_INT    {

                $$ = new SymbolInfo();
                string op = machineCode["subi"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string imm = toHex($6->getName() , 2);   

                $$->code = op + s1 + dst +  imm  + "\n";
                
            }
            |   AND  REGISTER COMMA REGISTER COMMA REGISTER    {


                $$ = new SymbolInfo();
                string op = machineCode["and"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID[$6->getName()];

                $$->code = op + s1 + s2 + dst + "0\n";

            }
            |   ANDI  REGISTER COMMA REGISTER COMMA CONST_INT    {
                
                $$ = new SymbolInfo();
                string op = machineCode["andi"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string imm = toHex($6->getName() , 2);   

                $$->code = op + s1 + dst +  imm  + "\n";                
            }
            |   OR  REGISTER COMMA REGISTER COMMA REGISTER  {

                $$ = new SymbolInfo();
                string op = machineCode["or"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID[$6->getName()];

                $$->code = op + s1 + s2 + dst + "0\n";
            }
            |   ORI REGISTER COMMA REGISTER COMMA CONST_INT    {

                $$ = new SymbolInfo();
                string op = machineCode["ori"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string imm = toHex($6->getName() , 2);   

                $$->code = op + s1 + dst +  imm  + "\n";     
            }
            |   SLL REGISTER COMMA REGISTER COMMA CONST_INT    {
                
                $$ = new SymbolInfo();
                string op = machineCode["sll"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string shamt = toHex($6->getName() , 1);   

                $$->code = op + "0" + s1 + dst +  shamt  + "\n";     
            }

            |   SRL REGISTER COMMA REGISTER COMMA CONST_INT    {

                $$ = new SymbolInfo();
                string op = machineCode["srl"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string shamt = toHex($6->getName() , 1);   

                $$->code = op + "0" + s1 + dst +  shamt  + "\n";                
            }
            |   NOR REGISTER COMMA REGISTER COMMA REGISTER  {

                $$ = new SymbolInfo();
                string op = machineCode["nor"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID[$6->getName()];

                $$->code = op + s1 + s2 + dst + "0\n";
            }

            |   SW REGISTER COMMA CONST_INT LPAREN REGISTER RPAREN  {

                $$ = new SymbolInfo();
                string op = machineCode["sw"];
                string reg1 = registerID[$2->getName()];
                string reg2 = registerID[$6->getName()];
                string imm = toHex($4->getName() , 2); 

                $$->code = op + reg2 + reg1 +  imm  + "\n";
            }
            |   LW REGISTER COMMA CONST_INT LPAREN REGISTER RPAREN  {

                $$ = new SymbolInfo();
                string op = machineCode["lw"];
                string reg1 = registerID[$2->getName()];
                string reg2 = registerID[$6->getName()];
                string imm = toHex($4->getName() , 2); 

                $$->code = op + reg2 + reg1 +  imm  + "\n";                

            }
            |   BEQ REGISTER COMMA REGISTER COMMA LABEL {

                $$ = new SymbolInfo();
                string op = machineCode["beq"];
                string reg1 = registerID[$2->getName()];
                string reg2 = registerID[$6->getName()];
                string imm = toHex($4->getName() , 2); 

                $$->code = op + reg2 + reg1 +  imm  + "\n";                

            }
            |   BNEQ REGISTER COMMA REGISTER COMMA LABEL {
                
                $$ = new SymbolInfo();
                string op = machineCode["bneq"];
                string reg1 = registerID[$2->getName()];
                string reg2 = registerID[$6->getName()];
                string imm = toHex($4->getName() , 2); 

                $$->code = op + reg2 + reg1 +  imm  + "\n";    
            }
            |   J LABEL {
                
                $$ = new SymbolInfo();
                string op = machineCode["j"];
                string address = toHex(jmpAt[$2->getName()] , 2);

                $$->code = op + address + "00\n";

            };
	


%%
int main(int argc,char *argv[])
{

    initialize();

    secondPass = false;
    instruction_count = 0;
	
    fp = fopen(argv[1],"r");
	outputFile = fopen("MachineCode.txt" , "w");

	yyin=fp;
	yyparse();

    instruction_count = 0;
    secondPass = true;

    fp = fopen(argv[1],"r");
	outputFile = fopen("MachineCode.txt" , "w");

	yyin=fp;
	yyparse();
    

	fclose(fp);
	
	return 0;
}
