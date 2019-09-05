#include<bits/stdc++.h>
using namespace std;

class SymbolInfo {

private:
	string name , type;
    int instructionCount;

public:
    string code;


    SymbolInfo(string symbolName = "", string symbolType = "") {

		name = symbolName;
		type = symbolType;
        instructionCount = -1;
    }

    void setName( string &symbolName) {
    	name = symbolName;
    }

    string getName() {
    	return name;
    }

    void setType( string &symbolType) {
    	type = symbolType;
    }

    string getType() {
    	return type;
    }

    void setInstructionCount(int cnt) {
        instructionCount = cnt;
    }
    int getInstructionCount() {
        return instructionCount;
    }

};

