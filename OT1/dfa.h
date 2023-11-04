#ifndef DFA_H
#define DFA_H

#include <vector>
#include <set>
#include <map>
#include "nfa.h"

#include <iostream>

class SimpDfa;

class DfaNode
{
public:
    std::map<char, std::size_t> map;
    bool accept = false;
};

class Dfa
{
public:
    Dfa();
    Dfa(const Dfa&) = delete;
    Dfa& operator=(const Dfa&) = delete;
    Dfa(Dfa&&) noexcept;
    Dfa& operator=(Dfa&&) noexcept;
    ~Dfa();
    DfaNode* getNode(std::size_t);
private:
    std::vector<DfaNode*> nodes;
    using SubsetMap = std::map<std::set<NfaNode*>, std::size_t>;
    SubsetMap subsetMap;
    std::pair<SubsetMap::iterator, bool> makeNode(const std::set<NfaNode*>&, bool);
    friend Dfa nfaToDfa(const Nfa& nfa);
    friend SimpDfa simplifyDfa(const Dfa& dfa);
};

Dfa nfaToDfa(const Nfa&);

#endif