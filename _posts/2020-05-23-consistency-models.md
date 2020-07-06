---
layout: post
title: "Consistency Models for Distributed Replicated State Machines"
date: 2020-05-23 20:22:39
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
---

*Replicated state machine* is a common distributed system design to achieve fault-tolerance against *fail-stops*. *Consistency* among distributed replicas thus arise as a crucial problem. People have defined different levels of consistency models throughout distributed systems research. Some of them are strong and easier to reason about and program with, while others weaken the constraints to pursue higher performance.

## Replicated State Machines

Consider a classic key-value store scenario. To provide fault-tolerance, data is replicated over multiple server nodes and coordinated (using a consensus algorithm such as Paxos or Raft, or a coordination service such as ZooKeeper, or other models with weaker consistency).

![ReplicatedStateMachine](/assets/img/replicated-state-machine.png)

We assume nodes can fail independently at any time (losing temporary states) and the networking among clients and server nodes is unreliable (nodes may be partitioned, packets may drop, and may arrive out-of-order). We do require that persistent storage is reliable and there is no malicious modification of messages (no *Byzantine failures*).

Clients talk to a distribteud KV store service hoping that it performs just as a single machine executing orders serially. This is the ideal case under *strong consistency* (*linearizability*). Different designs of how data gets replicated expose different levels of consistency. Strong consistency acts just like a single machine and is easier for application programmers to reason about, but it mostly means limited scalability and poorer performance. Weaker consistency models are typically more scalable, has lower latency, and much higher throughput.

## The "CAP" Theorem

The CAP Theorem[^1] states that every distributed replicated state machine cannot achieve all the following three properties at the same time.

1. (Strongly) **C**onsistent: satisfies linearizability, see the next section;
2. (Always) **A**vailable: requests always receive a response;
3. **P**artition-tolerant: works under arbitrary network partitioning.

The [wikipedia page](https://en.wikipedia.org/wiki/CAP_theorem) clearly states why. This theorem illustrates that when network partitioning is possible, we must tradeoff between consistency and availability.

## Consistency Models

Consider a distributed data store system with two kinds of operations: `v = read(x)` (Rxv) and `write(x, v)` (Wxv). A partial rank of strictness of common consistency models, based on the COPS paper by Lloyd et al.[^2], is:

<p style="text-align: center;"><b><u>Strong (Linearizability) > Sequential > Causal > Eventual</u></b>.</p>

### 1) Strong Consistency (Linearizability)

A data store system is strongly consistent (linearizable) if all replicas agree on a global serial order of all operations that satisfies both:

- *Real-time*: if operation $$y$$ starts after operation $$x$$ ends in time, i.e., operation $$y$$ is issued after someone receives response for operation $$x$$, then $$x < y$$;
- *Up-to-date*: every read operation reflects the most recent (up to itself in the order) value written to that variable by previous writes.

![Linearizability](/assets/img/linearizability-demo.png)

Intuitively, **strong consistency requires a distributed system to act as if it is a single machine without replication - all clients are virtually talking to a single-core node in some serial order**. If a read is issued after some client after a write has been confirmed by perhaps another client, then we expect that read to reflect the written value. This property is desired when data must be synchronized in real time and stale data is strictly not allowed. **Read must return the global newest value among all nodes**.

Examples include all consensus algorithms such as Paxos[^3] and Raft[^4], and some other replication techniques such as ZooKeeper (ZAB) and chain replication (CR). They typically record client requests (both R and W) into log entries, replicate and agree on a global log sequence, and then apply the log entries in order. Many (I would say most) systems are built upon these log-based models to provide a linearizable history as long as a majority of the nodes are alive and connected. The price is that each operation has a long latency-to-apply and overall throughput is low.

### 2) Sequential Consistency

A slightly weaker consistency model with respective to strong consistency is sequential consistency. It still asks for a global ordering, but relaxes the real-time property and instead requires that, for each client thread, its operations happen in the same order as in the global ordering.

![SequentialConsistency](/assets/img/sequential-consistency-demo.png)

Notice that within a single client thread, the next operation always starts only if the previous one has returned (they do not overlap in time). Thus, **this is a weaker constraint compared to the "real-time" constraint of strong consistency**, which forces ordering between operations across threads that do not overlap in time.

### 3) Causal Consistency

Causal consistency further decouples different client threads and only requires that, for each client thread, its operations happen in order. No explicit guarantee is placed upon how operations reflect results written by other clients. We do not require all replicas to agree on the same global order, as long as they end up with the same values in database.

![CausalConsistency](/assets/img/causal-consistency-demo.png)

Causally consistent systems often encode operation dependencies within each client thread, and on each replica, apply an operation when its dependencies have all been applied. Since only a local order is forced, **causal consistency allows a system to be available under network partitioning**. If one client thread only interacts with its nearest replica, causal consistency enables **local read** - read returns the local replica's value and does not have to wait.

Causal consistency is widely criticized for its known *cascading dependency wait* issue. Such programming model is also not straightforward - programmers must arrange their code to maintain the "causality" of database requests. (Consider a scenario when you update profile content together with an access control list. When you are adding someone into the ACL, should update content first, so that as soon as they see you accepted their friend request, they see your up-to-date profile. However, when you are revoking someone from the ACL, should update ACL first, so that they cannot notice your latest profile change. Awkward~)

### 4) Eventual Consistency

The weakest consistency guarantee for a distributed replicated system is eventual consistency. Reads will eventually reflect the result of all writes and replicas eventually contain consistent values. Yet, reads are allowed to return temporary stale values and out-of-order intermediate values.

![EventualConsistency](/assets/img/eventual-consistency-demo.png)

**Eventual consistency is very useful for many web services, where temporary stale data is not a big deal, but scalability and performance are significant**. Because we no longer fear out-of-order writes at replicas, with eventual consistency, we can use cached **local write** + **background pushing**. Writes can now return immediately without waiting, just as reads.

Because all replicas still need to agree on a consistent value at the end, such systems often involve a *conflict resolution* mechanism when a replica receives concurrent writes to the same variable. Might be "last writer wins" with *Lamport clock timestamp*[^5], or some ad-hoc mechanisms like "taking the union".

Examples include AWS DynamoDB and Cassandra.

## References

[^1]: [https://en.wikipedia.org/wiki/CAP_theorem](https://en.wikipedia.org/wiki/CAP_theorem)
[^2]: [https://www.cs.cmu.edu/~dga/papers/cops-sosp2011.pdf](https://www.cs.cmu.edu/~dga/papers/cops-sosp2011.pdf)
[^3]: [https://lamport.azurewebsites.net/pubs/paxos-simple.pdf](https://lamport.azurewebsites.net/pubs/paxos-simple.pdf)
[^4]: [https://raft.github.io/raft.pdf](https://raft.github.io/raft.pdf)
[^5]: [https://en.wikipedia.org/wiki/Lamport_timestamps](https://en.wikipedia.org/wiki/Lamport_timestamps)

