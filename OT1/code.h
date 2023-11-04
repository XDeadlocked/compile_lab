#ifndef CODE_H
#define CODE_H

#include <string>
#include <ostream>
#include "simplify.h"

void generateCode(std::ostream&, const std::string&, const SimpDfa&);

#endif