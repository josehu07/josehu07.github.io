---
layout: post
title: "Notes on Consensus Algorithms - <i>Paxos</i>, <i>Multi-Paxos</i>, and <i>Raft</i>"
date: 2020-04-04 16:40:17
author: Guanzhou Hu
categories: Technical
---

分布式系统中，基础的共识算法（Consensus Algorithms）希望解决的是在节点可能 crash / restart、节点间网络消息可能乱序、丢失、重复的情况下，让所有节点对 clients 一串提案达成 strong consistency (linearizability)，从而实现 Replicated State Machines，做到有效的 fault-tolerence。

### 共识算法针对的问题

分布式系统中，基础的 **共识算法（Consensus Algorithm）** 希望解决的是如下问题：**节点可能 crash / restart、节点间网络消息可能乱序、丢失、重复的情况下，让所有节点对 clients 一串提案达成强一致**[^1]（see newer post for explanation of strong consistency）。

- 不考虑消息内容的篡改（*Byzantine*）
- 假设节点的 persistent 存储是可靠的

### 为什么对 Paxos、Raft 等的研究很重要

传统 *2PC*（两阶段提交）、*3PC*（三阶段提交） 在用于 transactions
 之外也可以用于共识一个提案的问题，但缺点是一个节点宕机则系统不可用（或在出现 network partition 后存在 [脑裂](https://en.wikipedia.org/wiki/Split-brain_(computing)) 无法解决）；这些共识算法的目标就是在有多个副本同时参与、超半数仍正常工作的情况下（少数副本可以挂掉，从而**可用性更高**了）仍能**保证 100% 一致性**。

### Paxos、Multi-Paxos、Raft

- **Paxos**: 保证单个提案的一致
    - 方法：多个 acceptors；proposal = (ID, V)，ID 有全序关系；超半数同意
    - 保证永远可用吗？不：
        - 一样可能多数都挂掉，只是可靠性更高了
        - 原始的 Paxos 会出现两阶段化带来的活锁
    - 值得阅读：
        1. Paxos 初版论文 from Lamport - [The Part-Time Parliament](http://lamport.azurewebsites.net/pubs/lamport-Paxos.pdf), TOCS'98[^2]
        2. Paxos 二版解释 from Lamport - [Paxos Made Simple](http://lamport.azurewebsites.net/pubs/Paxos-simple.pdf)[^3]
        3. 最清楚的解释来自 wiki：[https://zh.wikipedia.org/wiki/Paxos%E7%AE%97%E6%B3%95](https://zh.wikipedia.org/wiki/Paxos%E7%AE%97%E6%B3%95)[^4]
- **Multi-Paxos**：需保证一批提案的一致
    - 方法：利用 Paxos 选举唯一的 leader，而后在 leader 有效期内所有的议案都只能由 leader 发起；也可每个提案都跑原始 Paxos，但性能太差，不实际
    - 值得阅读：[http://oceanbase.org.cn/?p=111](http://oceanbase.org.cn/?p=111)[^5]
- **Raft**：更易理解、更贴近实践、更易 implement 的 Multi-Paxos 替代方案
    - 方法：加入 timeout 机制，用随机性来简化 leader 选举；log replication 时，Paxos 中的 ID 即为 Raft 中的 term + log index，一旦出现更新的 term 则听从
    - 值得阅读：
        1. Raft 官网 - [https://raft.github.io/](https://raft.github.io/)
        2. Raft 论文 from Stanford, extended ver. - [In Search of an Understandable Consensus Algorithm](https://raft.github.io/raft.pdf)[^6]
        3. 非常好的在线演示：[http://thesecretlivesofdata.com/raft/](http://thesecretlivesofdata.com/raft/)

### 其他共识算法

其他在部署中成功的共识算法有 Zab（即 Zookeeper 所基于的 replication）、ViewStamps 等等。

#### References

[^1]: [https://zhuanlan.zhihu.com/p/46531628](https://zhuanlan.zhihu.com/p/46531628)
[^2]: [http://lamport.azurewebsites.net/pubs/lamport-Paxos.pdf](http://lamport.azurewebsites.net/pubs/lamport-Paxos.pdf)
[^3]: [http://lamport.azurewebsites.net/pubs/Paxos-simple.pdf](http://lamport.azurewebsites.net/pubs/Paxos-simple.pdf)
[^4]: [https://zh.wikipedia.org/wiki/Paxos%E7%AE%97%E6%B3%95](https://zh.wikipedia.org/wiki/Paxos%E7%AE%97%E6%B3%95)
[^5]: [http://oceanbase.org.cn/?p=111](http://oceanbase.org.cn/?p=111)
[^6]: [https://raft.github.io/raft.pdf](https://raft.github.io/raft.pdf)
