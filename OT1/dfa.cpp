#include "dfa.h"

#include <queue>

Dfa::Dfa() = default;

Dfa::Dfa(Dfa&& other) noexcept
    : nodes(std::move(other.nodes))
{
    ;
}

Dfa& Dfa::operator=(Dfa&& other) noexcept
{
    nodes.swap(other.nodes);
    return *this;
}

Dfa::~Dfa()
{
    for (auto&& p : nodes)
        delete p;
}

DfaNode* Dfa::getNode(std::size_t index)
{
    return nodes[index];
}

std::pair<Dfa::SubsetMap::iterator, bool> Dfa::makeNode(const std::set<NfaNode*>& set, bool accept)
{
    auto found = subsetMap.find(set);
    if (found != subsetMap.end())
        return { found, false };
    auto ptr = new DfaNode;
    auto index = nodes.size();
    nodes.push_back(ptr);
    ptr->accept = accept;
    return subsetMap.insert({ set, index });
}

static void epsClosure(NfaNode* node, std::set<NfaNode*>& set, bool& accept)
{
    if (set.find(node) != set.end())
        return;
    set.insert(node);
    if (node->accept)
        accept = true;
    for (auto&& n : node->eps)
        epsClosure(n, set, accept);
}

static std::pair<std::set<NfaNode*>, bool> epsClosure(NfaNode* node)
{
    std::set<NfaNode*> set;
    bool accept = false;
    epsClosure(node, set, accept);
    return { set, accept };
}

Dfa nfaToDfa(const Nfa& nfa)
{
    Dfa dfa;
    auto ret = epsClosure(nfa.begin);
    dfa.makeNode(ret.first, ret.second);
    auto start = dfa.subsetMap.begin();
    std::queue<decltype(start)> queue;
    queue.push(start);
    while (!queue.empty())
    {
        auto iter = queue.front();
        queue.pop();
        std::set<char> sigma;
        for (auto&& node : iter->first)
            for (auto&& kv : node->map)
                sigma.insert(kv.first);
        for (auto&& c : sigma)
        {
            std::set<NfaNode*> set;
            bool accept = false;
            for (auto&& node : iter->first)
            {
                auto found = node->map.find(c);
                if (found == node->map.end())
                    continue;
                auto ret = epsClosure(found->second);
                set.insert(ret.first.begin(), ret.first.end());
                accept = accept || ret.second;
            }
            auto pair = dfa.makeNode(set, accept);
            dfa.nodes[iter->second]->map[c] = pair.first->second;
            if (pair.second)
                queue.push(pair.first);
        }
    }
    return dfa;
}
