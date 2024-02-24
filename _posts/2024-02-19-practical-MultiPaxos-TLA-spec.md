---
layout: post
title: "Practical SMR-style TLA+ Specification of the MultiPaxos Protocol"
date: 2024-02-19 12:11:20
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
---

The attached files present a practical TLA+ specification of MultiPaxos that very closely models how a real state machine replication (SMR) system would implement this protocol. I did not find anything similar on the web, so I'd like to share it with anyone interested.

## Files of This TLA+ Spec

Below are the files composing the checkable model (organized in VSCode extension style):

- [MultiPaxos.tla](/assets/file/tla-specs/multipaxos_smr_style/MultiPaxos.tla) (main protocol spec written in PlusCal and with translation attached)
- [MultiPaxos_MC.tla](/assets/file/tla-specs/multipaxos_smr_style/MultiPaxos_MC.tla) (entrance of running model checking; contains the checked constraints)
- [MultiPaxos_MC.cfg](/assets/file/tla-specs/multipaxos_smr_style/MultiPaxos_MC.cfg) (recommended model inputs and configurations, which should give 100% coverage of all interesting cases)
- [MultiPaxos_MC_small.cfg](/assets/file/tla-specs/multipaxos_smr_style/MultiPaxos_MC_small.cfg) (smaller input with one fewer write and no `CommitNotice` messages)

## What's Good About This Spec

This spec is different from traditional, general descriptions of Paxos/MultiPaxos in the following aspects:

- It models MultiPaxos in a practical SMR system style that's much closer to real implementations than its traditional, abstract specs (e.g., [this](https://github.com/tlaplus/Examples/tree/master/specifications/Paxos))
  - All servers explicitly replicate a log of instances, each holding a command
  - Numbers of client write/read commands are made model inputs
  - Explicit *termination* condition is defined, thus semi-liveness can be checked by not having deadlocks
  - Safety constraint is defined as a clean client-viewed *linearizability* property upon termination
  - Replica node failure is injected to assure the protocol's fault-tolerance level
  - See the detailed comments in the source files...
- Careful optimizations are applied to the spec to reduce the state space W.L.O.G.
  - Model checking with recommended inputs completes in < 22 min on a 40-core server machine
  - Commenting out the `HandleCommitNotice` action (which is the least significant) and having one fewer request reduces check time down to < 10 secs
- It is easy to extend this spec and add even more practical features
  - Leader lease and local read
  - Asymmetric write/read quorum sizes
  - ...

This spec has been accepted into the official [TLA+ Examples repo](https://github.com/tlaplus/Examples)! [^1]

Here are some links I found particularly useful when developing this spec by myself: [^2] [^3] [^4] [^5]

## Update: Extended Spec with Extra Features

Below are the files composing an extended version of the spec along with model inputs:

- [MultiPaxos.tla](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos.tla) (extended main protocol spec written in PlusCal and with translation attached)
- [MultiPaxos_MC.tla](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos_MC.tla) (entrance of running model checking; contains the checked constraints)
- [MultiPaxos_MC.cfg](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos_MC.cfg) (recommended model inputs and configurations, which should give 100% coverage of all interesting cases with default features)
- [MultiPaxos_MC_small.cfg](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos_MC_small.cfg) (smallest input for sanity check)
- [MultiPaxos_MC_rwqrm.cfg](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos_MC_rwqrm.cfg) (input demonstrating asymmetric write/read quorum sizes)
- [MultiPaxos_MC_lease.cfg](/assets/file/tla-specs/multipaxos_smr_addon/MultiPaxos_MC_lease.cfg) (input demonstrating stable leader leases and local read)

## What's New in the Extend Spec

The extended spec includes the following extra features/variants of MultiPaxos that are very essential and useful in practice:

- Only keep writes in the log (while reads squeeze in between writes)
- Asymmetric write/read quorum sizes
- Stable leader lease and local read at leader

## References

[^1]: [https://github.com/tlaplus/Examples](https://github.com/tlaplus/Examples)
[^2]: [https://lamport.azurewebsites.net/tla/tutorial/home.html](https://lamport.azurewebsites.net/tla/tutorial/home.html)
[^3]: [https://learntla.com/index.html](https://learntla.com/index.html)
[^4]: [https://lamport.azurewebsites.net/tla/summary-standalone.pdf](https://lamport.azurewebsites.net/tla/summary-standalone.pdf)
[^5]: [https://tla.msr-inria.inria.fr/tlatoolbox/doc/model/distributed-mode.html](https://tla.msr-inria.inria.fr/tlatoolbox/doc/model/distributed-mode.html)
