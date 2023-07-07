---
layout: post
title: "Revisiting My Distributed Replication Consistency Models Post"
date: 2023-04-05 13:47:05
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
--- 

Previously, I made a [blog post](https://www.josehu.com/technical/2020/05/23/consistency-models.html) about common consistency models in distributed state machine replication (SMR). As I am recently picking up my scattered knowledge about distributed replication systems, I found some inaccuracy and ambiguity in that old post. This short post lists some patches and complementary material I revisited on this convoluted topic.

## Revisited Material

- **[Decentralized Thoughts blog series](https://decentralizedthoughts.github.io/start-here/)**: a really good blog series on consensus problems. Although most of the advanced blog posts there focus on decentralized Byzantine-fault-tolerant systems, the beginner posts offer a great summary of the problem and the foundational models we are studying.
- **[My half-completed technical report](/assets/file/Consistency_Levels_Summary.pdf)**: a "somewhat formal" summary of non-transactional consistency models and availability models for distributed replication. This report corrects some inaccuracy/errors in my previous blog post and extends it to a broader scope.
