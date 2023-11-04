#include <iostream>
#include <fstream>
#include "regex.h"
#include "nfa.h"
#include "dfa.h"
#include "simplify.h"
#include "code.h"

int main()
{
    std::string input;
    std::getline(std::cin, input);
    auto regex = stringToRegex(input);
    auto nfa = regexToNfa(regex);
    auto dfa1 = nfaToDfa(nfa);
    auto dfa2 = simplifyDfa(dfa1);
    std::getline(std::cin, input);
    std::ofstream file(input);
    std::getline(std::cin, input);
    generateCode(file, input, dfa2);
}
