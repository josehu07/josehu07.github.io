---
layout: post
title: "Distributed Lease 101 and How To Localize Linearizable Reads"
date: 2026-07-07 04:41:07
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
---

Leases are a powerful and widely-used primitive in distributed systems, but what are they really? Let's understand learn how leases work and, through a pleasant journey, learn how to apply leases to optimize linearizable consensus reads. We will derive the Bodega protocol at the end -- the state-of-the-art protocol that allows linearizable read at any client-nearest replica (anywhere) with minimal write interruption (anytime).

## Lease, and What to Expect?

A *lease* is a directional, time-bounded, refreshable promise: one node (the *grantor*) promises another (the *grantee*) that it will uphold some rule until expiry.

Let's walk through how leases work, and how to apply leases to optimize wide-area linearizable read on a replicated consensus cluster:

1. **One-to-one** -- the primitive: a safe promise between two nodes.
2. **Lease manager** -- one node distributes a promise out to many.
3. **Leader Leases** -- everyone leases the leader, producing a stable leader who can local read.
4. **Quorum Leases** -- everyone leases a subset of local readers in the absence of writes.
5. **Roster Leases** -- everyone exchanges leases on the roster: a free side-channel agreement.
6. **Bodega protocol** -- co-designs roster leases with consensus: read anywhere, anytime.

Prefer hands-on exploration? Try our [distributed lease simulator playground](https://bodega-consensus.com/sim).

## 01. Standard One-to-One Leasing (one-to-one)

The base primitive: one grantor promises one grantee.

One *invariant* holds at all times: the grantor expires the lease no earlier than the grantee does, so the grantee never believes on a lease the grantor has dropped.

Lease only requires *bounded clock drift* between the two sides, i.e., the speed of time flowing does not differ by more than `t_Δ`.

How do we hold the invariant true without synchronized timestamps? Via messages. Two phases:

1. **Guard** (once). Tames the unknown delay of the first message -- the grantee accepts the first renewal only inside a self-imposed window, letting the grantor bound expiry before any reply.
2. **Renew** (steady state). The lease starts on the first renewal (if received timely before guard expiry); a renew exchange loop at sub-timeout intervals keeps the lease alive.

Example -- Lease established and kept alive:

![Lease established and kept alive](/assets/img/lease-101-one-to-one-success.gif)

Example -- Guard msg/reply missing, not established:

![Guard msg/reply missing, not established](/assets/img/lease-101-one-to-one-guard-reply-lost.gif)

Lease ends at either when the grantor proactively *revokes* it, or when renewals don't arrive before expiry -- the expiration mechanism makes lease failure-resilient.

Example -- Proactively revoked by grantor:

![Proactively revoked by grantor](/assets/img/lease-101-one-to-one-revoked.gif)

Example -- Failure on the link, lease expires:

![Failure on the link, lease expires](/assets/img/lease-101-one-to-one-renew-replies-lost.gif)

Notice the grantor-side timer dance: every renewal it sends pessimistically *extends* grantor's expiry (in case the reply never comes back), and upon receiving the reply it *tightens* expiry calculation back to the confirmed receipt.

## 02. The Lease Manager Pattern (one-to-many)

A common way to deploy the primitive in a distributed system is to have a dedicated *lease manager* entity that holds the authority to grant leases, handing them out to nodes as they request them. Each grant is just an independent instance of the one-to-one primitive.

Example -- Manager hands grants to 1,2 then 2,3:

![Manager hands grants to 1,2 then 2,3](/assets/img/lease-101-lease-manager-handover.gif)

Distributed lock managers are a common example of application of this pattern. But, what about for consensus, how can leases help there?

## 03. Classic Leader Leases (all-to-one)

Every node acts as a grantor and leases the one node it thinks is leader (which may be self). A *majority* of those promises becomes a cluster-wide guarantee.

The primitive is unchanged -- only the aggregate pattern. Each node grants to the latest leader it knows (after revoking any previous lease). Once a leader holds a majority number of grants (`⌈n/2⌉`, counting its own), it is provably the only one: the **stable leader**.

Two majorities must overlap, and the shared node never promises two leaders at once. Majority intersection, applied to leases.

Example -- Every node leases their believed leader:

![Every node leases their believed leader](/assets/img/lease-101-leader-leases.gif)

The payoff: the stable leader knows every latest commit, so it can serve reads from its local state directly -- a linearizable read becomes a local check, not a network quorum.

However, this convenience is only at the leader, not at any other replica nodes that clients may be closer to. A big improvement to regular quorum-mandatory consensus reads nonetheless, but not exploiting clients' location affinity fully.

- **Pro:** Leases sit off the critical path of consensus; writes never interrupt stable leadership.
- **Con:** Only leadership is protected, so only the sole stable leader acquires local read power.

## 04. Quorum Read Leases (all-to-many)

One local reader is limiting. Hand the privilege to any *chosen subset* of nodes instead -- picked per object, so each object's frequent readers can serve its reads locally [^1].

The promise is new in kind -- not “you are the leader” but “I won't accept writes to this object without notifying you first and revoking” -- a **read lease**. A grantee reads locally once a majority grant it ∧ its latest known write is in committed status; that write's value can be used.

Example -- A chosen subset of nodes hold read leases:

![A chosen subset of nodes hold read leases](/assets/img/lease-101-quorum-leases.gif)

What happens upon a write? The trick: lease revocation rides the write's accept messages. A write already needs a majority quorum; we include all the grantees in it as an additional requirement, and their ordinary accept-replies *double as* the lease revocation notification -- no extra trip.

The downside of read lease semantic: any write to a leased object *disrupts* its local reads and tears the leases down, forcing re-establishment and causing local intervals of degradation.

Example -- Write folds lease logic and disrupts read leases:

![Write folds lease logic and disrupts read leases](/assets/img/lease-101-quorum-leases-write-disruption.gif)

- **Pro:** Local reads possible at a a configurable subset of nodes, exploiting read locality.
- **Con:** Lease logic is coupled to consensus serving, and any write disrupts local reads.

## 05. Roster Leases: New, Simple, and Powerful (all-to-all)

The culminating pattern, simple but powerful. Decouple *who takes part* in leasing from *what a lease protects*. Everyone takes part, exchanging leases in an **all-to-all** pattern, via logical messages [^2].

What the leases protect is a simple piece of cluster metadata -- a **roster**: who is the leader ∧ who are the *responders* (i.e., local readers) per object. Roster is tagged by the ballot number as `⟨bal, ros⟩`.

A lease now says “we agree on the roster”. Every node is both grantor and grantee, exchanging the primitive with every peer. Once a node holds a majority (`⌈n/2⌉`), that majority agrees on its `⟨bal, ros⟩` -- so at most one such **stable roster** can exist, the precondition for local reads *anywhere*.

Being about metadata, the promise isn't disrupted by writes. Reads can therefore go local *anytime*, not just in write-quiet windows.

Example -- All-to-all leasing on a roster metadata:

![All-to-all leasing on a roster metadata](/assets/img/lease-101-roster-leases.gif)

That decoupling is the philosophy, combining both pros and avoiding both cons. But roster leases is only half the story -- the other half is how to integrate it with consensus with minimal tension. That co-design is Bodega.

## 06. Bodega: Roster Leases and Consensus Co-designed

Co-designs consensus serving around the roster. A responder serves reads locally if a majority grant it ∧ it is a responder according to the current roster ∧ its latest known write is in committed status. Write requires gathering accepts from responders and broadcasts commit notifications.

Reads stay local through writes. The lease traffic is nearly free too: it *piggybacks on the heartbeats* that consensus replicas already exchange.

Two more subtleties keep local reads honest and efficient:

1. Latest slot not yet committed: Rather than an outright rejection, Bodega **optimistically holds** the read, anchors it on that slot, and answers it the moment it receives the commit notification for that slot (a bounded, often brief wait; the best strategy possible).
2. A newly-joined responder doesn't always have an *up-to-date* consensus log: Let each initial lease message carry the grantor's highest accepted slot, so a responder starts localizing reads when its log has caught up to a sufficient point.

| Trait | First seen in |
| --- | --- |
| Bounded clock drift assumption only | One-to-one |
| Fault tolerance via self-healing expiry | One-to-one |
| Off the critical path leases on role (anytime) | Leader Leases |
| Configurable set of local readers (anywhere) | Quorum Leases |
| Decoupled leasing and consensus (anywhere, anytime) | **Roster Leases** |
| Efficiency via optimistic holding and more (co-design) | **Bodega** |

## References

[^1]: [https://dl.acm.org/doi/10.1145/2670979.2671001](https://dl.acm.org/doi/10.1145/2670979.2671001)
[^2]: [https://www.usenix.org/conference/osdi26/presentation/hu-guanzhou](https://www.usenix.org/conference/osdi26/presentation/hu-guanzhou)
