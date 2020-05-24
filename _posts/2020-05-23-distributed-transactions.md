---
layout: post
title: "Serializable Distributed Transactions over Sharded Scenario"
date: 2020-05-23 10:19:36
author: Guanzhou Hu
categories: Technical
---

*Sharding* is a common distributed system design to scale out and achieve better performance. *Distributed transactions* (concurrency control + atomic commits) are used to coordinate sharded nodes. It is important to implement *serializable* distributed transactions for such a system to act correctly.

### Sharded Key-Value Store

[BLOG ONGOING...]

### The "ACID" Principle & Serializability

### Pessimistic/Optimistic Concurrency Control

### Atomic Commits with Two-Phase Commit (2PC)

#### References

[^1]: [link](link)
