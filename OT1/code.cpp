#include "code.h"

void generateCode(std::ostream& os, const std::string& name, const SimpDfa& dfa)
{
    const char* indent = "    ";
    os << "#include <iostream>\n"
        << "\n"
        << "class " << name << "\n"
        << "{\n"
        << "public:\n"
        << indent << "~" << name << "()\n"
        << indent << "{\n"
        << indent << indent << "for (auto&& p : states)\n"
        << indent << indent << indent << "delete p;\n"
        << indent << "}\n"
        << indent << "bool operator()(const std::string& s)\n"
        << indent << "{\n"
        << indent << indent << "index = " << dfa.begin << ";\n"
        << indent << indent << "for (auto&& c : s)\n"
        << indent << indent << indent << "(*states[index])(c);\n"
        << indent << indent << "return states[index]->accept();\n"
        << indent << "}\n"
        << "private:\n"
        << indent << "struct State\n"
        << indent << "{\n"
        << indent << indent << name << "* ptr;\n"
        << indent << indent << "State(" << name << "* ptr)\n"
        << indent << indent << indent << ": ptr(ptr) { }\n"
        << indent << indent << "virtual ~State() = default;\n"
        << indent << indent << "virtual bool accept() = 0;\n"
        << indent << indent << "virtual void operator()(char) = 0;\n"
        << indent << "};\n"
        << indent << "struct StateAccept : State\n"
        << indent << "{\n"
        << indent << indent << "using State::State;\n"
        << indent << indent << "virtual ~StateAccept() override = default;\n"
        << indent << indent << "virtual bool accept() override final\n"
        << indent << indent << "{\n"
        << indent << indent << indent << "return true;\n"
        << indent << indent << "}\n"
        << indent << indent << "virtual void operator()(char) override = 0;\n"
        << indent << "};\n"
        << indent << "struct StateReject : State\n"
        << indent << "{\n"
        << indent << indent << "using State::State;\n"
        << indent << indent << "virtual ~StateReject() override = default;\n"
        << indent << indent << "virtual bool accept() override final\n"
        << indent << indent << "{\n"
        << indent << indent << indent << "return false;\n"
        << indent << indent << "}\n"
        << indent << indent << "virtual void operator()(char) override = 0;\n"
        << indent << "};\n"
        << indent << "struct StateError : StateReject\n"
        << indent << "{\n"
        << indent << indent << "using StateReject::StateReject;\n"
        << indent << indent << "virtual ~StateError() override = default;\n"
        << indent << indent << "virtual void operator()(char c) override final\n"
        << indent << indent << "{\n"
        << indent << indent << indent << ";\n"
        << indent << indent << "}\n"
        << indent << "};\n";
    auto size = dfa.nodes.size();
    for (decltype(size) i = 0; i != size; ++i)
    {
        using namespace std::string_literals;
        auto& node = *dfa.nodes[i];
        auto className = "State" + std::to_string(i);
        auto baseName = "State"s + (node.accept ? "Accept" : "Reject");
        os << indent << "struct " << className << " : " << baseName << " \n"
            << indent << "{\n"
            << indent << indent << "using " << baseName << "::" << baseName << ";\n"
            << indent << indent << "virtual ~" << className << "() override = default;\n"
            << indent << indent << "virtual void operator()(char c) override final\n"
            << indent << indent << "{\n"
            << indent << indent << indent << "switch (c)\n"
            << indent << indent << indent << "{\n";
        for (auto&& kv : node.map)
            os << indent << indent << indent << "case '" << kv.first << "':\n"
                << indent << indent << indent << indent << "ptr->index = " << kv.second << ";\n"
                << indent << indent << indent << indent << "break;\n";
        os << indent << indent << indent << "default:\n"
            << indent << indent << indent << indent << "ptr->index = " << size << ";\n"
            << indent << indent << indent << indent << "break;\n"
            << indent << indent << indent << "}\n"
            << indent << indent << "}\n"
            << indent << "};\n";
    }
    os << indent << "State* states[" << size + 1 << "] = {\n";
    for (decltype(size) i = 0; i != size; ++i)
        os << indent << indent << "new State" << std::to_string(i) << "{this},\n";
    os << indent << indent << "new StateError{this},\n"
        << indent << "};\n"
        << indent << "std::size_t index;\n"
        << "};\n"
        << "\n"
        << "int main()\n"
        << "{\n"
        << indent << "std::cout << std::boolalpha;\n"
        << indent << "Automaton a;\n"
        << indent << "std::string input;\n"
        << indent << "while (std::getline(std::cin, input))\n"
        << indent << indent << "std::cout << a(input) << std::endl;\n"
        << "}\n";
}
