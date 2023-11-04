#include <list>
#include <set>
#include <map>
#include "simplify.h"

SimpDfa::SimpDfa() = default;

SimpDfa::SimpDfa(SimpDfa&& other) noexcept
    : nodes(std::move(other.nodes)), begin(other.begin)
{
    ;
}

SimpDfa& SimpDfa::operator=(SimpDfa&& other) noexcept
{
    nodes.swap(other.nodes);
    begin = other.begin;
    return *this;
}

SimpDfa::~SimpDfa()
{
    for (auto&& p : nodes)
        delete p;
}

SimpNode* SimpDfa::getNode(std::size_t index)
{
    return nodes[index];
}

std::size_t SimpDfa::makeNode()
{
    auto ptr = new SimpNode;
    auto index = nodes.size();
    nodes.push_back(ptr);
    return index;
}

struct ListItem
{
    ListItem() = default;
    ListItem(std::set<std::size_t>&& set)
        : indices(std::move(set)) { }
    std::set<std::size_t> indices;
    std::size_t node = 0;
};

struct ItemRef
{
    std::list<ListItem>::iterator iterator;
};

SimpDfa simplifyDfa(const Dfa& dfa)
{
    auto size = dfa.nodes.size();
    std::vector<ItemRef> helper(size);
    std::list<ListItem> list;
    {
        list.emplace_back();
        list.emplace_back();
        auto yes = list.begin();
        auto no = ++list.begin();
        for (decltype(size) i = 0; i != dfa.nodes.size(); ++i)
            if (dfa.nodes[i]->accept)
            {
                yes->indices.insert(i);
                helper[i].iterator = yes;
            }
            else
            {
                no->indices.insert(i);
                helper[i].iterator = no;
            }
        if (no->indices.empty())
            list.erase(no);
    }
    while (1)
    {
        bool ok = true;
        for (auto iter = list.begin(); iter != list.end(); )
        {

            std::map<std::map<char, ListItem*>, std::set<std::size_t>> map;
            for (auto&& i : iter->indices)
            {
                std::map<char, ListItem*> key;
                for (auto&& kv : dfa.nodes[i]->map)
                    key.insert({ kv.first, &*helper[kv.second].iterator });
                map[key].insert(i);
            }
            if (map.size() == 1)
            {
                ++iter;
                continue;
            }
            ok = false;
            for (auto&& pair : map)
            {
                auto& set = pair.second;
                list.emplace_back(std::move(set));
                auto iter = --list.end();
                for (auto&& i : iter->indices)
                    helper[i].iterator = iter;
            }
            iter = list.erase(iter);
        }
        if (ok)
            break;
    }
    SimpDfa result;
    for (auto&& item : list)
    {
        item.node = result.makeNode();
        result.nodes[item.node]->accept = dfa.nodes[*item.indices.begin()]->accept;
    }
    for (decltype(size) i = 0; i != size; ++i)
    {
        auto& map = result.nodes[helper[i].iterator->node]->map;
        for (auto&& kv : dfa.nodes[i]->map)
            map.insert({ kv.first, helper[kv.second].iterator->node });
    }
    result.begin = helper[0].iterator->node;
    return result;
}
