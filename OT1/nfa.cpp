#include "nfa.h"

#include <iostream>
#include <vector>

Nfa::Nfa(const Regex* regex)
{
    if (dynamic_cast<const RegexEpsilon*>(regex))
    {
        begin = makeNode();
        end = begin;
        end->accept = true;
    }
    else if (dynamic_cast<const RegexChar*>(regex))
    {
        auto r = static_cast<const RegexChar*>(regex);
        begin = makeNode();
        end = makeNode();
        end->accept = true;
        begin->map[r->c] = end;
    }
    else if (dynamic_cast<const RegexConcat*>(regex))
    {
        auto r = static_cast<const RegexConcat*>(regex);
        begin = makeNode();
        auto nfa0 = makeSubNfa(r->re0);
        auto nfa1 = makeSubNfa(r->re1);
        begin->eps.push_back(nfa0.begin);
        nfa0.end->eps.push_back(nfa1.begin);
        nfa0.end->accept = false;
        end = nfa1.end;
    }
    else if (dynamic_cast<const RegexAlter*>(regex))
    {
        auto r = static_cast<const RegexAlter*>(regex);
        begin = makeNode();
        end = makeNode();
        auto nfa0 = makeSubNfa(r->re0);
        auto nfa1 = makeSubNfa(r->re1);
        begin->eps.push_back(nfa0.begin);
        nfa0.end->eps.push_back(end);
        nfa0.end->accept = false;
        begin->eps.push_back(nfa1.begin);
        nfa1.end->eps.push_back(end);
        nfa1.end->accept = false;
        end->accept = true;
    }
    else if (dynamic_cast<const RegexClosure*>(regex))
    {
        auto r = static_cast<const RegexClosure*>(regex);
        begin = makeNode();
        end = makeNode();
        auto nfa = makeSubNfa(r->re);
        begin->eps.push_back(end);
        begin->eps.push_back(nfa.begin);
        nfa.end->accept = false;
        nfa.end->eps.push_back(begin);
        end->accept = true;
    }
}

Nfa::Nfa(Nfa&&) noexcept = default;

Nfa& Nfa::operator=(Nfa&& other) noexcept
{
    begin = other.begin;
    end = other.end;
    nodes.swap(other.nodes);
    return *this;
}

Nfa::~Nfa()
{
    for (auto&& p : nodes)
        delete p;
}

NfaNode* Nfa::makeNode()
{
    auto ptr = new NfaNode;
    nodes.push_back(ptr);
    return ptr;
}

Nfa Nfa::makeSubNfa(const Regex* regex)
{
    auto temp = regexToNfa(regex);
    nodes.insert(nodes.end(), temp.nodes.begin(), temp.nodes.end());
    temp.nodes.clear();
    return temp;
}

Nfa regexToNfa(const Regex* regex)
{
    return Nfa(regex);
}
