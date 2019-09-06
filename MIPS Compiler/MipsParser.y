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

int getDecimal(char ch) {

    if(ch>='A' && ch<='F') return (ch - 'A' + 10);
    return (ch -'0');
}


char hexSubtract(char c1 , char c2) {

    
    int num1 = getDecimal(c1);
    int num2 = getDecimal(c2);

    int ret = num1 - num2;

    char ch;
    if(ret < 10 ) ch = char(ret + '0');
    else {
        ret %=10;
        ch = char(ret + 'A');
    }
    return ch;
}

string addOne(string str) {

    string one = "1";
    while(one.size() < str.size()) one = "0" + one;

    int carry = 0;

    string tot = "";

    for(int i = str.size() -1 ; i >= 0 ; i-- ) {

        int num1 = getDecimal(str[i]);
        int num2 = getDecimal(one[i]);
        int sum = num1 + num2 + carry;

        carry = sum/16;
        sum %= 16;

        if(sum < 10 ) tot  += char(sum + '0');
        else {
            sum%=10;
            tot += char('A' + sum);
        }
    }
    reverse(tot.begin() , tot.end());
    return tot;

}


string complimented(string str) {

    

    for(int i =0 ; i < str.size() ; i++ ) {

        str[i] = hexSubtract('F' , str[i]);
    }

    return addOne(str);


}

string toHex(int num , int tgt) {


    bool neg = false;
    if(num < 0 ) {
        neg = true;
    }
    num = abs(num);
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

    if(neg) return complimented(str);
    return str;
}
string toHex(string ss,int tgt) {
    
    int num = 0;

    for(int i =0 ; i < ss.size() ; i++ ) {
        
        if(ss[i] == '-') continue;
        num *= 10;

        num += (ss[i] - '0');
    }
    if(ss[0] == '-') num *=-1;
    
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
        
        int id =  (pattern[i] - 'A') ;
        machineCode[ops[id]] = toHex(i , 1);
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

%token ADD  ADDI  SUB  SUBI  AND  ANDI  OR  ORI  SLL  SRL  NOR  SW  LW  BEQ  BNEQ  J MOV JR MOVI
%token REGISTER   COMMA  CONST_INT   COLON  LABEL   LPAREN RPAREN

%%


start:	program	{

			$$ = $1;
            $$->code = "v2.0 raw\n" + $1->code;
            if(secondPass) {
                outputFile = fopen("MachineCode.txt" , "w");
                fprintf(outputFile , "%s\n" , $$->code.c_str() );
                fclose(outputFile);
            }
			
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
			$$ = new SymbolInfo() ;
            jmpAt[$1->getName()] = instruction_count;

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
                string reg2 = registerID[$4->getName()];
                string label = toHex(jmpAt[$6->getName()] , 2);

                $$->code = op + reg2 + reg1 +  label  + "\n";                

            }
            |   BNEQ REGISTER COMMA REGISTER COMMA LABEL {
                
                $$ = new SymbolInfo();
                string op = machineCode["bneq"];
                string reg1 = registerID[$2->getName()];
                string reg2 = registerID[$4->getName()];
                string label = toHex(jmpAt[$6->getName()] , 2);

                //cout<<$6->getName()<<" "<<jmpAt[$6->getName()]<<" "<<label<<endl;

                $$->code = op + reg2 + reg1 +  label  + "\n";   
                //cout<<$$->code<<endl;
            }
            |   J LABEL {
                
                $$ = new SymbolInfo();
                string op = machineCode["j"];
                string label = toHex(jmpAt[$2->getName()] , 2);

                //cout<<$2->getName()<<" "<<jmpAt[$2->getName()] <<" "<<label<<endl;
                

                $$->code = op + label + "00\n";
                //cout<<$$->code<<endl;

            }
			|MOV  REGISTER COMMA REGISTER {

                $$ = new SymbolInfo();
                string op = machineCode["add"];
                string dst = registerID[$2->getName()];
                string s1 = registerID[$4->getName()];
                string s2 = registerID["$zero"];

                $$->code = op + s1 + s2 + dst + "0\n";

			}
			|  MOVI REGISTER COMMA CONST_INT    {

                $$ = new SymbolInfo();
                string op = machineCode["addi"];
                string dst = registerID[$2->getName()];
                string s1 = registerID["$zero"];
                string imm = toHex($4->getName() , 2);   

                $$->code = op + s1 + dst +  imm  + "\n";     
            }
			|JR REGISTER{
				$$ = new SymbolInfo();
				string op = machineCode["j"];
				string s1 = registerID[$2->getName()];
				$$->code = op + s1+ "001\n";
			};
	


%%
int main(int argc,char *argv[])
{

    initialize();

    secondPass = false;
    instruction_count = 0;	
    fp = fopen(argv[1],"r");

	yyin=fp;
	yyparse();
    fclose(fp);


    instruction_count = 0;
    secondPass = true;
    fp = fopen(argv[1],"r");
	
	yyin=fp;
	yyparse();
    fclose(fp);
	
	return 0;
}
