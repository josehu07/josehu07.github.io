---
layout: post
title: "Systems for AI and AI for Systems: Some Chitter-Chatter"
date: 2022-05-21 18:29:30
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
---

This is a short post where I note down some of my insignificant thoughts about the interaction between AI and systems. With the rapid evolution of AI technologies, especially in the field of *machine learning* (ML), there is now a rising interest in studying the intersection between AI and *computer systems* design. The combination of the two can further be categorized into two directions: building systems for AI applications (Sys for AI) and using AI to empower smarter systems (AI for Sys).

## Systems for AI

The very early form of AI, namely small-scale statistical algorithms, didn't attract too much attention from computer architects and system builders. They were treated as yet another type of normal application workloads. System researchers had other issues to deal with, such as the I/O bottleneck, which appear to be more urgent problems to be solved at that time.

Around the year 2010, system researchers started to pay attention to something slightly closer to AI -- which we later call "Big Data" applications -- thanks to the emergence of Hadoop MapReduce[^1] and Spark[^2] [^3]. A typical example of such Big Data application is an iterative graph processing algorithm, such as PageRank. These workloads require notably more compute power as well as higher storage performance requirement, pushing datacenters to go really large-scale and become vastly distributed. Combined with technical advances in other areas, including OS virtualization, high-speed networking, and advanced architecture, they lead to the success of large-scale datacenters and cloud computing (beyond traditional HPC).

Then, there comes machine learning (ML), more specifically, *deep learning* (DL) models. There's no need for me to emphasize how much attention these data-hungry workloads have attracted in other areas of computer science in recent years. Their requirements for tremendous amount of data storage, massive parallel computation, and heavy communication have made them one of the most important and challenging workloads. People have done many things in building better systems for ML, and nothing seems to be stopping this trend so far:

* Hardware: GP-GPU, specialized tensor computation hardware such as TPU, ...
* Programming: auto differentiation (Autograd), just-in-time compilation (JAX), ...
* Computation: highly-optimized libraries, various systems for scalable and high-throughput training, scheduling, ...
* Communication: collective communication for distributed training, parameter servers, high-speed interconnect (NVLink), ...
* Profiling: performance monitoring, ...
* Serving: low-latency inference, performance predictability, ...
* Storage: data I/O optimizations, model checkpointing, ...

With big models (with billions of parameters) gaining popularity, AI continues to be one of the main driving forces of the advancement of computing infrastructure. Many top conferences in e.g. the systems area now have 1 or 2 sessions dedicated for ML systems in recent years (see [^4] for an example). There's even a specialized conference for this topic, MLSys[^5], which started in 2018.

## AI for Systems

The interaction between AI and systems can also go the other way around: deploying AI algorithms to help design and implement smarter computer systems infrastructure, in short, AI for Sys. A natural question to ask at this point is: what are the problems in computer systems that AI techniques could really solve better than experienced developers? This is a tough question and many systems researchers are still trying to find a reasonable answer.

### Heuristics Might Be A Good Entry Point

One of such opportunities, in my opinion, is to use AI algorithms to help improve or replace **heuristics**. Systems builders have long been putting heuristics here and there in different kinds of systems.

For example, cache eviction algorithms in data store systems rely heavily on heuristics about the incoming workload to decide which entry to evict when the cache is full. Many production systems still choose a simple heuristic such as LRU (least-recently used) that might not fit the actual workload well and is not resistant to large scans. If you are interested, here is [a post](https://josehu.com/technical/2020/08/07/cache-eviction-algorithms.html) [^6] I wrote earlier about cache modes and eviction algorithms.

Another example of heuristics would be magic configuration numbers. A hash function implementation needs to decide how many buckets to create initially and how many more to grow at resizing. A database system needs to decide how much memory space to allocate as the block cache, etc. Magic numbers are everywhere and they are typically just chosen by an experienced system designer with very little assumption on the actual workload the system is going to serve.

AI techniques, especially data-driven ML models, seem to be a good fit to replace such heuristics. Given that a workload has its own statistical characteristics, we may assume that it is drawn from some probability distribution and is thus learnable by a smart enough ML model. Indeed, there are quite a few recent research papers addressing this opportunity. Just to name a few off the top of my head:

* Bourbon[^7]: applying *learned indexes* in LevelDB to speed up the searching of keys
* Stacked Filters[^8]: applying *learned filters* in database queries for more efficient filtering
* Entropy-Learned Hashing[^9]: discovering patterns in incoming keys to reduce the cost of hashing
* Learning on distributed *traces* for making decisions in datacenter storage systems[^10]
* LlamaTune[^11]: example of DBMS configuration *knobs tuning* on given workloads

However, ML models are not free plug-and-play replacement for these decision-making heuristics. The real workload might not actually follow a causal pattern, and even if we assume it always does, the pattern may change dynamically and rapidly. Furthermore, ML training and inference are themselves storage- and compute-heavy.

### The Performance Obstacle

By integrating ML algorithms into systems, our ultimate goal is to let it come up with smarter *policies* that make better *decisions* to yield better *performance*. However, deploying ML models themselves introduce significant performance overhead. The overhead consists of two parts: *training* on some existing data to learn a policy and doing *inference* through the policy to get decisions.

Coarsely, we can categorize "ML for Sys" techniques into two classes:

* **Online**: gather workload data at run-time, train on gather data constantly to update the policy, and use the most up-to-date policy to make decisions.
  * $$\uparrow$$ This strategy is rather robust against workload shifts.
  * $$\downarrow$$ Gathering data and training most of the useful ML models at run-time are very expensive and time-consuming.
* **Offline**: train on offline data (which are probably profiled from previous runs ahead-of-time) to get a determined policy and then deploy that policy.
  * $$\uparrow$$ This strategy removes the cost of training from the critical path.
  * $$\downarrow$$ It cannot react to dynamic changes in workload pattern.
  * $$\downarrow$$ Evaluating a policy may still involve inference costs, which might not be cheap depending on the type of the model.

Nonetheless, the performance benefit of deploying a ML model in a computer system must be greater than its cost of deployment for it to be actually useful. This is why most of the research work around this topic so far are still limited to light-weight ML models. Bourbon, for example, only incorporates a simple segmented linear regression model and not any form of neural networks (NN). Some offline configuration tuning tools that produce static magic numbers may use larger NN models.

I hope that other ways of integrating AI techniques into computer systems can be discovered in the near future to help us build smarter systems and spawn more interesting ideas.

## References

[^1]: [https://dl.acm.org/doi/10.1145/1327452.1327492](https://dl.acm.org/doi/10.1145/1327452.1327492)
[^2]: [https://dl.acm.org/doi/10.1145/2934664](https://dl.acm.org/doi/10.1145/2934664)
[^3]: [https://www.usenix.org/conference/nsdi12/technical-sessions/presentation/zaharia](https://www.usenix.org/conference/nsdi12/technical-sessions/presentation/zaharia)
[^4]: [https://www.usenix.org/conference/osdi22/technical-sessions](https://www.usenix.org/conference/osdi22/technical-sessions)
[^5]: [https://mlsys.org/](https://mlsys.org/)
[^6]: [https://josehu.com/technical/2020/08/07/cache-eviction-algorithms.html](https://josehu.com/technical/2020/08/07/cache-eviction-algorithms.html)
[^7]: [https://www.usenix.org/conference/osdi20/presentation/dai](https://www.usenix.org/conference/osdi20/presentation/dai)
[^8]: [https://dl.acm.org/doi/10.14778/3436905.3436919](https://dl.acm.org/doi/10.14778/3436905.3436919)
[^9]: [https://bhentsch.github.io/doc/EntropyLearnedHashing.pdf](https://bhentsch.github.io/doc/EntropyLearnedHashing.pdf)
[^10]: [https://mlsys.org/virtual/2021/oral/1627](https://mlsys.org/virtual/2021/oral/1627)
[^11]: [https://arxiv.org/abs/2203.05128](https://arxiv.org/abs/2203.05128)
