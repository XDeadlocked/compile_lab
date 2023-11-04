#include "regex.h"

#include <vector>

Regex::Regex() = default;

Regex::~Regex() = default;

RegexEpsilon::~RegexEpsilon() = default;

RegexEpsilon::RegexEpsilon() = default;

RegexChar::~RegexChar() = default;

RegexChar::RegexChar(char c)
    : c(c)
{
    ;
}

RegexConcat::~RegexConcat()
{
    delete re0;
    delete re1;
}

RegexConcat::RegexConcat(Regex* re0, Regex* re1)
    : re0(re0), re1(re1)
{
    ;
}

RegexAlter::~RegexAlter()
{
    delete re0;
    delete re1;
}

RegexAlter::RegexAlter(Regex* re0, Regex* re1)
    : re0(re0), re1(re1)
{

}

RegexClosure::~RegexClosure()
{
    delete re;
}

RegexClosure::RegexClosure(Regex* re)
    : re(re)
{
    ;
}

template<typename T, typename... Args>
Regex* makeRegex(Args&& ... args)
{
    return new T(std::forward<Args>(args)...);
}

static Regex* stringToRegex(std::string::const_iterator begin, decltype(begin) end)
{
    return stringToRegex(std::string{ begin, end });
}

Regex* stringToRegex(const std::string& string)
{
    auto begin = string.begin();
    auto end = string.end();
    while (1)
    {
        if (begin == end)
            return makeRegex<RegexEpsilon>();
        if (*begin != '(')
            break;
        int level = 0;
        bool bk = false;
        for (auto iter = begin, e = end - 1; iter != e; ++iter)
            if (*iter == '(')
                ++level;
            else if (*iter == ')' && --level == 0)
                bk = true;
        if (bk)
            break;
        ++begin;
        --end;
    }
    std::vector<std::string::const_iterator> alts;
    int level = 0;
    for (auto iter = begin; iter != end; ++iter)
        switch (*iter)
        {
        case '(':
            ++level;
            break;
        case ')':
            --level;
            break;
        case '|':
            if (level == 0)
                alts.push_back(iter);
            break;
        }
    if (alts.empty())
    {
        std::vector<Regex*> cons;
        for (auto iter = begin; iter != end; ++iter)
        {
            switch (*iter)
            {
            case ' ':
                cons.push_back(makeRegex<RegexEpsilon>());
                break;
            case '*':
            {
                auto back = cons.back();
                cons.pop_back();
                cons.push_back(makeRegex<RegexClosure>(back));
                break;
            }
            case '(':
            {
                int level = 0;
                auto begin = iter;
                for (; ; ++iter)
                    if (*iter == '(')
                        ++level;
                    else if (*iter == ')' && --level == 0)
                        break;
                cons.push_back(stringToRegex(begin, iter + 1));
                break;
            }
            default:
                cons.push_back(makeRegex<RegexChar>(*iter));
                break;
            }
        }
        auto regex = cons.front();
        for (auto iter = cons.begin() + 1; iter != cons.end(); ++iter)
            regex = makeRegex<RegexConcat>(regex, *iter);
        return regex;
    }
    else
    {
        auto size = alts.size();
        alts.push_back(end);
        auto regex = stringToRegex(begin, alts.front());
        for (decltype(size) i = 0; i != size; ++i)
            regex = makeRegex<RegexAlter>(regex, stringToRegex(alts[i] + 1, alts[i + 1]));
        return regex;
    }
}
