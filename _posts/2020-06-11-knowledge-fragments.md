---
layout: post
title: "Noting Down Some Knowledge Fragments Encountered"
date: 2020-06-11 05:12:40
author: Guanzhou Hu
categories: Memo
enable_math: "enable"
---

Memory fragments encountered, mostly not in my major fields. Noting them down just for a memorandum. 这篇用于记录一些学习中遇到的细碎知识。大多不是主要领域的知识，所以并未系统地学习和整理，权当备忘和随笔啦。

### Messaging Security

Messaging security 中的加密主要重点考虑一下三个维度的安全性：

1. *Confidentiality* (**机密性**)：数据消息通路被监听，监听者不能轻易地解析出数据内容；对称/非对称加密都保障了 confidentiality 这一基本维度
2. *Integrity* （**数据完整性**）：消息的接收方能确认这个数据包就是发送方发出来的样子 (as-is)，中途没有被篡改；MAC-tagging 等操作保障了 integrity 这一维度
3. *Authenticity* (**身份验证**)：消息的接收方能确认这个消息来自正确的另一方，即能确认对方的身份 (中间人攻击 MITM 中，中间人的伪装往往也被视为打破了 authenticity)；非对称加密的签名机制同时保障了 integrity 和 authenticity 两个维度

特殊情境下，也考虑一些额外的维度：

- *Privacy* (**私密性**)：匿名网络中，用户的请求在网络中传输时，不能被其他参与者判断出这个请求来自哪个用户；经典例子为洋葱路由与 Tor
- *Forward Secrecy* (**前向加密**)：开启 session 时，使用 long-term 的 key 来交换一个 short-lived 的 session key，而后基于 session key 来交换消息，这样在攻击者破解了这个 session 时，之前 sessions 所有的老消息不受影响
- Performance：**性能**是现在互联网大规模扩展的基石，理论上绝对安全但性能上不 pratical 的方案是没有实际使用价值的
- ...

维度之间是有冲突的，所以设计一个安全的 messaging 网络系统往往也需要做大量 trade-off。

### Quaternion & Rotations

- 二维中绕任意点旋转需要三维矩阵（平移 $$\times$$ 旋转 $$\times$$ 平移）：[Read](https://blog.csdn.net/csxiaoshui/article/details/65446125)
- 三维中绕任意轴旋转需要四维矩阵（四元数表示法）：[Read](https://www.zhihu.com/question/23005815/answer/33971127)


### Python 2 vs. 3 Syntax

(For using Mininet...) Essential coding differences that may sometimes disturb me:

- `print a` vs. `print(a)`
- Integer `/` division $$\rightarrow$$ integer vs. $$\rightarrow$$ float
- `xrange()` iterating vs. `range()`


### Julia Language

Notes about Julia during the 6.S083 course at MIT:

- **Dynamic + Compiled** (high-performance)
    - Good for data science tasks
    - But lacks robustness in some cases ;(, e.g.
        - Lack of index out-of-bound checks
        - Need to **follow performance tips**, o.w. can perform really bad
- **Greek (Unicode) symbols allowed**, looks like math ;)
- **Some functional programming properties**
    - No OOP, functions live outside
    - Multi-dispatch: function is a name and methods are its different variants of signatures
    - Mutation guard by `!`
- `Array{}` enables 1/multi-dimensional storage
    - `Vector{}` is a 1d array
        - **Index starts from `1` ;(**
        - Matlab-flavor `.` operators
    - Matrices can be represented as a multi-d array

> Julia looks like a strange hybrid of Python + Matlab + Lisp to me. But its spirit is great and it is developing really fast. I like it.


### Statistics

- **中心极限定理**：对一个总体，做无穷次同样大小样本的抽样，这些样本的均值会呈现一种正态分布
    - 该正态分布的均值即总体的均值（i.e., 样本均值是对总体均值的无偏估计）
    - 该正态分布的标准差即标准误（Standard Error，*SE*），代表了我随意抽一次样本，这个样本的均值大概会离总体均值有多远的误差
- **标准误** *SE* = $$\frac{\sigma}{\sqrt{n}}$$，$$\sigma$$ 为总体标准差，$$n$$ 为样本容量
    - 但总体标准差不可知，故使用所抽样本的标准差 $$s$$ 代替，则标准误 *SE* $$\approx \frac{s}{\sqrt{n}}$$
    - 总体遵循对称的分布时，样本标准差 $$s$$ 更接近总体标准差 $$\sigma$$（总体若是遵循 skew 的分布，如指数分布，则这个近似会不太精确）；同时，所抽样本容量越大，近似更精确；故当我们对总体遵循的分布有一个事先的认识的情况下，若知道总体是 skew 的（如遵循指数规律），则应选取较大的样本大小，从而使 “使用所抽样本的标准差 $$s$$ 代替总体标准差 $$\sigma$$” 这一行为更为精确
- **95% 置信区间** 即抽出的样本的均值 $$\pm$$ 1.96 *SE*，代表了我有 95% 的信心保证下次抽样的均值应该在这个区间内

> 将一切未知都交给 random 是一种聪明但有些懒惰的做法 (?)。


### Dual Number & Differentiation

**二元数**（*Dual Number*）：$$a + b \epsilon$$ with $$\epsilon^2 = 0$$，可用于 model 计算机前向自动微分中的**导数计算**过程：$$f(a + b \epsilon) = f(a) + b f’(a) \epsilon$$，故求解 $$\epsilon$$ 的系数即可得出 $$a$$ 处的导数值：

1. 首先，将所有初等函数的导数求值方式 hardcode 成表，e.g.，$$(x)’_{x=a} = 1$$, $$(e^x)’_{x=a} = e^a$$
2. 然后，任一复杂函数都是初等函数通过各种算符在计算图上组合而成的，故只需要将二元数各类运算的规则定义好，e.g.，$$(a + b \epsilon) \cdot (c + d  \epsilon) = ac + (ad+bc) \epsilon$$, $$r (a + b \epsilon) = a r+ b r \epsilon$$：[Read](https://en.wikipedia.org/wiki/Dual_number)
3. 从而，函数 $$f(x) = 3 x e^x$$ 在 $$x=a$$ 处的导数的一种计算过程如下：
    1. $$g(x) = x, g(a + b \epsilon) = g(a) + b g’(a) \epsilon = a + b \epsilon$$
        *[查表了初等函数 $$x$$ 的导数]*
    2. $$h(x) = e^x, h(a + b \epsilon) = h(a) + b h’(a) \epsilon = e^a + b e^a \epsilon$$
        *[查表了初等函数 $$e^x$$ 的导数]*
    3. $$k(x) = 3 g(x), k(a + b \epsilon) = 3 g(a + b \epsilon) = 3(a + b \epsilon) = 3 a + 3 b \epsilon$$
        *[代入了 step.1 中 $$g(x)$$ 的结果，而后使用了二元数乘实数运算规则]*
    4. $$f(x) = k(x) \cdot h(x), f(a + b \epsilon) = k(a + b \epsilon) \cdot h(a + b \epsilon) =$$ $$(3 a + 3 b \epsilon) \cdot (e^a + b e^a \epsilon) = 3 a e^a + (3 a b e^a + 3 b e^a) \epsilon$$
        *[代入了 step.2-3 中 $$h(x), k(x)$$ 的结果，而后使用了二元数乘二元数运算规则]*
    5. 得 $$f’(a) = (3 a b e^a + 3 b e^a) / b = 3 (a+1) e^a$$

这么做的原因：

- 不是数值方法，没有使用差分近似
- 相较于对表达式做符号求导的好处：
    - 符号求导是将数学代数表达式依据导数规则完整展开，直到最后才代入 $$x=a$$ 求值，因此较易出现**表达式膨胀**，不适合仅需对特定点处求导的情形
    - 前向自动求导则是在计算图推进的每一步中都将到这一节点为止的表达式值求出，在下一步中利用运算规则，调取前一步算出的子表达式（每个子表达式值 essentially 只是一个二元数）进行相应组合，因而避免了表达式膨胀；见上述例子中 step.4


### Programming Models

- OOP: Design a `sendMoney` method for a class `Person`
- SP: Design a `sendFromA2B` routine
- FP: Design the mapping $$(A, B) \rightarrow (A', B')$$
