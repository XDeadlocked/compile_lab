#ifndef SIMPLIFY_H
#define SIMPLIFY_H

#include <vector>
#include <map>
#include "dfa.h"

class SimpNode
{
public:
    std::map<char, std::size_t> map;
    bool accept = false;
};

class SimpDfa
{
public:
    SimpDfa();
    SimpDfa(const SimpDfa&) = delete;
    SimpDfa& operator=(const SimpDfa&) = delete;
    SimpDfa(SimpDfa&&) noexcept;
    SimpDfa& operator=(SimpDfa&&) noexcept;
    ~SimpDfa();
    std::size_t begin = 0;
    SimpNode* getNode(std::size_t);
private:
    std::vector<SimpNode*> nodes;
    std::size_t makeNode();
    friend SimpDfa simplifyDfa(const Dfa& dfa);
    friend void generateCode(std::ostream&, const std::string&, const SimpDfa&);
};

SimpDfa simplifyDfa(const Dfa& dfa);

#endif