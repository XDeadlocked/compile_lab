# 导入必要的库
from graphviz import Digraph
import graphviz
from collections import deque
import os

# 设置环境变量，确保Graphviz能够被调用
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'

# 定义一些全局变量
alpha = []  # 存储正则表达式中的字符
dfa_state_map = {}  # DFA状态映射
state_id = {}  # 状态的ID映射


# 定义一个状态类，用于表示NFA和DFA中的状态
class State:
    def __init__(self, label=None, arrow=None, is_closure_start=False, is_closure_end=False, is_closure=False):
        self.label = label
        self.arrow = arrow if arrow else {}  # 状态的转移关系
        self.id = None  # 状态ID
        self.is_closure_start = is_closure_start
        self.is_closure_end = is_closure_end
        self.is_closure = is_closure

    def __hash__(self):
        return id(self)

    def __str__(self):
        return str(id(self))

    # 计算epsilon闭包
    def epsilon_closure(self):
        closure = {self}
        queue = deque([self])

        while queue:
            state = queue.popleft()

            for next_state, transition in state.arrow.items():
                if transition == 'ε' and next_state not in closure:
                    closure.add(next_state)
                    queue.append(next_state)

        return closure


# 定义一个Fragment类，用于表示一个正则表达式的片段
class Fragment:
    def __init__(self, start, end):
        self.start = start  # 开始状态
        self.end = end  # 结束状态


def infix_to_postfix(regexp):
    """
    将中缀表示的正则表达式转换为后缀表示。

    参数:
        regexp (str): 中缀表示的正则表达式

    返回:
        str: 转换后的后缀表示的正则表达式
    """

    def get_precedence(op):
        """
        返回运算符的优先级。
        """
        precedence = {'|': 1, '.': 2, '*': 3}  # 定义运算符的优先级
        return precedence[op] if op in precedence else 0

    def assoc(op):
        """
        返回运算符的结合性。
        """
        # 这里，'*' 是右结合，其它的都是左结合。
        return 'left' if op in ['.', '|'] else 'right'

    output = []  # 初始化后缀表达式的列表
    operators = []  # 初始化操作符的栈

    # 隐式地通过插入 '.' 来转换连接
    i = 0
    while i < len(regexp) - 1:
        # 对于相邻的两个字符，如果它们之间可以形成一个连接，则插入 '.'
        if (regexp[i] not in ['(', '|', '*'] and regexp[i + 1] not in ['*', '|', ')']) or \
                (regexp[i] == ')' and regexp[i + 1] not in ['*', '|', ')']):
            regexp = regexp[:i + 1] + '.' + regexp[i + 1:]
            i += 2  # 增加 2 以跳过添加的 '.' 字符
        else:
            i += 1

    for char in regexp:
        if char == '(':
            # 左括号直接入栈
            operators.append(char)
        elif char == ')':
            # 如果是右括号，弹出操作符直到遇到左括号
            while operators[-1] != '(':
                output.append(operators.pop())
            operators.pop()  # 弹出 '('
        elif char in ['|', '.', '*']:
            # 如果是其他运算符，根据优先级和结合性，弹出栈顶的运算符
            while operators and (get_precedence(char) < get_precedence(operators[-1]) or
                                 (assoc(char) == 'left' and get_precedence(char) <= get_precedence(operators[-1]))):
                output.append(operators.pop())
            operators.append(char)
        else:
            # 如果是操作数，直接添加到输出列表中
            output.append(char)
            # 如果字符不在 alpha 列表中，则添加到其中
            if char not in alpha:
                alpha.append(char)

    # 如果操作符栈不为空，则将其所有元素添加到输出列表中
    while operators:
        output.append(operators.pop())

    return ''.join(output)  # 将列表转换为字符串并返回


def regex_to_nfa(postfix):
    # 初始化一个空栈，用于存储NFA的碎片
    stack_nfa = []

    # 遍历后缀正则表达式的每一个字符
    for char in postfix:
        # 如果字符是连接操作符'.'
        if char == '.':
            # 从栈中弹出两个NFA碎片
            frag2 = stack_nfa.pop()
            frag1 = stack_nfa.pop()

            # 将frag1的结束状态的箭头指向frag2的开始状态
            frag1.end.arrow = frag2.start.arrow

            # 将连接后的新NFA碎片压入栈
            stack_nfa.append(Fragment(frag1.start, frag2.end))

        # 如果字符是选择操作符'|'
        elif char == '|':
            # 从栈中弹出两个NFA碎片
            frag2 = stack_nfa.pop()
            frag1 = stack_nfa.pop()

            # 创建新的开始和结束状态
            start = State()
            end = State()

            # 将新的开始状态连接到两个碎片的开始状态
            start.arrow[frag1.start] = 'ε'
            start.arrow[frag2.start] = 'ε'

            # 将两个碎片的结束状态连接到新的结束状态
            frag1.end.arrow[end] = 'ε'
            frag2.end.arrow[end] = 'ε'

            # 将选择后的新NFA碎片压入栈
            stack_nfa.append(Fragment(start, end))

        # 如果字符是闭包操作符'*'
        elif char == '*':
            # 从栈中弹出一个NFA碎片
            frag = stack_nfa.pop()

            # 创建新的开始和结束状态
            start = State(is_closure_start=True)
            end = State(is_closure_end=True)

            # 新的开始状态可以跳过碎片，或者进入碎片
            start.arrow[frag.start] = 'ε'
            start.arrow[end] = 'ε'

            # 碎片的结束状态可以返回到碎片的开始状态，形成闭包，或者跳到新的结束状态
            frag.end.arrow[frag.start] = 'ε'
            frag.end.arrow[end] = 'ε'

            # 将闭包后的新NFA碎片压入栈
            stack_nfa.append(Fragment(start, end))

        # 如果字符是字母（非操作符）
        else:
            # 创建新的开始和结束状态
            end = State()
            start = State()

            # 将开始状态连接到结束状态，并标记为当前字符
            start.arrow[end] = char

            # 将新的NFA碎片压入栈
            stack_nfa.append(Fragment(start, end))

    # 从栈中弹出最终的NFA碎片
    final_nfa = stack_nfa.pop()

    # 创建一个新的开始状态，并连接到最终NFA碎片的开始状态
    new_start = State()
    new_start.arrow[final_nfa.start] = 'ε'

    # 返回完整的NFA，从新的开始状态到最终NFA碎片的结束状态
    return Fragment(new_start, final_nfa.end)


def visualize_nfa(frag):
    # 初始化一个有向图，用于表示NFA
    graph_nfa = graphviz.Digraph('NFA', node_attr={'shape': 'circle'}, graph_attr={'rankdir': 'LR'})

    # 使用广度优先搜索（BFS）为NFA中的状态分配从左到右的编号

    # 初始化计数器
    counter = [0]

    # 初始化访问过的状态集合
    visited = set()

    # 使用队列保存即将访问的状态，开始时只有起始状态
    queue = deque([frag.start])

    while queue:
        # 从队列头部取出一个状态
        state = queue.popleft()

        # 如果这个状态已经访问过，就跳过它
        if state in visited:
            continue

        # 如果这个状态是闭包的结束状态，将其标记移除并跳过它
        if state.is_closure_end:
            state.is_closure_end = False
            continue

        # 将这个状态标记为已访问
        visited.add(state)

        # 为这个状态分配一个ID
        state_id[state] = counter[0]
        counter[0] += 1

        # 首先处理ε转换，然后处理其他转换
        epsilon_transitions = [next_state for next_state, transition in state.arrow.items() if transition == 'ε']
        other_transitions = [next_state for next_state, transition in state.arrow.items() if transition != 'ε']

        # 将这个状态的所有后续状态加入队列，以备后续访问
        for next_state in epsilon_transitions + other_transitions:
            queue.append(next_state)

    # 根据状态ID生成图
    for state in state_id:
        for next_state, label in state.arrow.items():
            # 添加边，表示状态转换
            graph_nfa.edge(str(state_id[state]), str(state_id[next_state]), label=label)

        # 如果这个状态是起始状态或结束状态，使用双圆圈表示
        if state == frag.start or state == frag.end:
            graph_nfa.node(str(state_id[state]), label=str(state_id[state]), shape="doublecircle")
        else:
            graph_nfa.node(str(state_id[state]), label=str(state_id[state]))

    # 返回生成的图
    return graph_nfa


def e_closure(state_set):
    res = set()
    for state in state_set:
        closure = state.epsilon_closure()
        for item in closure:
            res.add(item)
    return res


def move(state_set, symbol):
    """Compute the move operation for a set of states and a given symbol."""
    result_set = set()
    for state in state_set:
        for next_state, transition in state.arrow.items():
            if transition == symbol:
                result_set.add(next_state)

    return result_set


def nfa2dfa(nfa):
    a = {nfa.start}
    dfa_list = []
    stack = []
    res1 = nfa.start.epsilon_closure()
    dfa_list.append(res1)

    for i in alpha:
        r = e_closure(move(res1, i))
        if r not in dfa_list:
            stack.append(r)
            dfa_list.append(r)

    while stack:
        tmp = stack.pop()
        for i in alpha:
            r = e_closure(move(res1, i))
            if r not in dfa_list:
                stack.append(r)
                dfa_list.append(r)
    return dfa_list


def visualize_dfa(dfa_list, alpha, name):
    # 初始化一个有向图，用于表示DFA
    graph_dfa = Digraph(name, node_attr={'shape': 'circle'}, graph_attr={'rankdir': 'LR'})

    # 生成一个大写字母列表，用于表示DFA的状态名
    letters = [chr(i) for i in range(65, 91)]  # 从 'A' 到 'Z'

    # 检查是否有超过大写字母数量的状态
    if len(dfa_list) > len(letters):
        raise ValueError("状态数量超过了基于字母的索引。考虑扩展字母列表。")

    # 为DFA的每个状态集创建一个映射
    dfa_state_map = {frozenset(state_set): letters[index] for index, state_set in enumerate(dfa_list)}

    # 打印字母到状态集的映射
    print(name)
    for state_set, letter in dfa_state_map.items():
        state_ids = [str(state_id[state]) for state in state_set]
        print(f"{letter} 对应于状态集: {{ {', '.join(state_ids)} }}")

    # 将节点添加到图中
    for state_set, letter in dfa_state_map.items():
        graph_dfa.node(letter, label=letter)

    # 将边添加到图中
    for state_set in dfa_list:
        current_letter = dfa_state_map[frozenset(state_set)]
        for symbol in alpha:
            next_state_set = e_closure(move(state_set, symbol))
            if next_state_set:
                next_letter = dfa_state_map[frozenset(next_state_set)]
                graph_dfa.edge(current_letter, next_letter, label=symbol)

    return graph_dfa


def minimize_dfa(dfa_list, alpha, nfa):
    # 第一步：删除不可达的状态（这里，所有状态都假定为可达）
    # 第二步：分割状态
    accept_states = [state for state in dfa_list if
                     nfa.end in state]  # 这里我们使用NFA的结束状态作为DFA接受状态的代理
    non_accept_states = [state for state in dfa_list if state not in accept_states]
    partitions = [accept_states, non_accept_states]

    is_refined = True
    while is_refined:
        is_refined = False
        new_partitions = []

        for partition in partitions:
            split = {}

            for state in partition:
                key = []
                for symbol in alpha:
                    next_state = e_closure(move(state, symbol))
                    key.append(next_id(next_state, partitions))
                key = tuple(key)

                if key not in split:
                    split[key] = []
                split[key].append(state)

            for _, states in split.items():
                if len(states) > 0:
                    new_partitions.append(states)

        if len(new_partitions) != len(partitions):
            is_refined = True
            partitions = new_partitions

    # 第五步：合并状态
    minimized_dfa = []
    for partition in partitions:
        if len(partition) > 0:
            minimized_dfa += partition

    return minimized_dfa


def next_id(state, partitions):
    # 查找给定状态属于哪个分区，并返回该分区的索引
    for idx, partition in enumerate(partitions):
        if state in partition:
            return idx
    return -1


def main():
    regex = "(a|b)*"
    postfix = infix_to_postfix(regex)
    nfa = regex_to_nfa(postfix)
    graph = visualize_nfa(nfa)
    graph.view()
    dfa_list = nfa2dfa(nfa)
    dfa_graph = visualize_dfa(dfa_list, alpha, "DFA")
    dfa_graph.view()
    minimized_dfa = minimize_dfa(dfa_list, alpha, nfa)
    minimized_dfa_graph = visualize_dfa(minimized_dfa, alpha, "MDFA")
    minimized_dfa_graph.view()


if __name__ == "__main__":
    main()
