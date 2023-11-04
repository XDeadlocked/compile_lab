#ifndef NFA_H
#define NFA_H

#include <vector>
#include <map>
#include "regex.h"

class NfaNode
{
public:
    std::vector<NfaNode*> eps;
    std::map<char, NfaNode*> map;
    bool accept = false;
};

class Nfa
{
public:
    explicit Nfa(const Regex*);
    Nfa(const Nfa&) = delete;
    Nfa& operator=(const Nfa&) = delete;
    Nfa(Nfa&&) noexcept;
    Nfa& operator=(Nfa&&) noexcept;
    ~Nfa();
    NfaNode* begin = nullptr;
    NfaNode* end = nullptr;
private:
    std::vector<NfaNode*> nodes;
    NfaNode* makeNode();
    Nfa makeSubNfa(const Regex*);
};

Nfa regexToNfa(const Regex*);

#endif