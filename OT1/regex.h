#ifndef REGEX_H
#define REGEX_H

#include <string>
#include <utility>

class Regex
{
public:
    Regex();
    Regex(const Regex&) = delete;
    virtual ~Regex() = 0;
};

class RegexEpsilon : public Regex
{
public:
    virtual ~RegexEpsilon() override;
    RegexEpsilon();
};

class RegexChar : public Regex
{
public:
    virtual ~RegexChar() override;
    RegexChar(char);
    char c;
};

class RegexConcat : public Regex
{
public:
    virtual ~RegexConcat() override;
    RegexConcat(Regex*, Regex*);
    Regex* re0;
    Regex* re1;
};

class RegexAlter : public Regex
{
public:
    virtual ~RegexAlter() override;
    RegexAlter(Regex*, Regex*);
    Regex* re0;
    Regex* re1;
};

class RegexClosure : public Regex
{
public:
    virtual ~RegexClosure() override;
    RegexClosure(Regex* re);
    Regex* re;
};

Regex* stringToRegex(const std::string& string);

#endif