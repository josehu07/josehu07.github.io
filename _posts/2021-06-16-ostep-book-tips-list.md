---
layout: post
title: "System Building Rules & Tips from the OSTEP Book"
date: 2021-06-15 15:03:17
author: Guanzhou Hu
categories: Memo
---

This short post is a summary list of all the system building tips/rules/laws boxes in [the OSTEP book](https://pages.cs.wisc.edu/~remzi/OSTEP/) (also see my [reading note](https://www.josehu.com/notes.html)). Without proper context, these tips make little sense, so I included the chapter numbers as well for easier back-tracing.

## List of System Building Tips

- Use *time-sharing* and *space-sharing* (Chapter 4)
- Separate *policy* and *mechanism* (Chapter 4)
- "*Get it right*. Neither abstraction nor simplicity is a substitute for getting it right." (Lampson's law, Chapter 5)
- *RTFM*: read the manual pages (Chapter 5)
- Use *protected control transfer* (Chapter 6)
- Be wary of *user inputs* in secure systems (Chapter 6)
- Deal with application *misbehavior* (Chapter 6)
- Use *interrupts* to regain control (Chapter 6)
- *Reboot* is useful because it reverts the system to a known and likely correct state (Chapter 6)
- *Shortest-job-first* is a general scheduling principle (Chapter 7)
- *Amortization* can reduce costs (Chapter 7)
- *Overlapping* enables higher utilization (Chapter 7)
- Learn from *history* to make better decisions (Chapter 8)
- *Scheduling* also needs to be secure from attacks (Chapter 8)
- "*Avoid voo-doo constants*." (Ousterhout's Law, Chapter 8)
- Use *advice* where possible (Chapter 8)
- Use *randomness* when appropriate (Chapter 9)
- Use *efficient data structures* (Chapter 9)
- Remember the principle of *isolation* (Chapter 13)
- When in doubt, *try it out* (Chapter 14)
- It *compiled/ran* != it is *correct* (Chapter 14)
- *Interposition* is powerful (Chapter 15)
- Require *hardware support* if that's better (Chapter 15)
- If 1000 solutions exist, no great one does; in this case, try to *avoid the problem* altogether (Chapter 16)
- Great engineers are *really great* (Chapter 17)
- Use *caching* when possible (Chapter 19)
- Use *hybrid* solution when appropriate (Chapter 20)
- Do work in the *background* (Chapter 21)
- Comparing against *theoretical optimal* is useful (Chapter 22)
- Be aware of the *curse of generality* (Chapter 23)
- Be *lazy* in certain cases (Chapter 23)
- Consider *incrementalism* (Chapter 23)
- Know and use available *tools* (Chapter 26)
- Use *atomic* operations (Chapter 26)
- Think in the way of a *malicious scheduler* when talking about concurrency bugs (Chapter 28)
- "*Less code* is often better code." (Lauer's Law, Chapter 28)
- More concurrency *isn't necessarily faster* (Chapter 29)
- Be wary of *control flow* changes when using locks (Chapter 29)
- "*Avoid premature optimization*." (Knuth's law, Chapter 29)
- Always *hold* the lock while signaling (Chapter 30)
- Use *while*, not if, in multi-threaded program (Chapter 30)
- "*Simple and dumb* can be better." (Hill's law, Chapter 31)
- Be careful with *generalization* (Chapter 31)
- "*Don't always do it perfectly*." (Tom West's law, Chapter 32)
- Don't *block* in event-based servers. (Chapter 33)
- *Interrupts* not always better than *polling*. (Chapter 36)
- Be aware of disk *sequentiality* (Chapter 37)
- "*It always depends*." (Livny's law, Chapter 37)
- *Transparency* enables easier deployment (Chapter 38)
- Think carefully about *naming* (Chapter 39)
- Be wary of *powerful commands* (Chapter 39)
- *TOCTTOU*: time-of-check to time-of-use (Chapter 39)
- Consider *extent*-based approaches (Chapter 40)
- Reads don't access *allocation* structures (Chapter 40)
- Understand *static* vs. *dynamic* partitioning (Chapter 40)
- Understand the *durability/performance tradeoff* (Chapter 40)
- Make the system *usable* (Chapter 41)
- *Details* matter (Chapter 43)
- Use a level of *indirection* when necessary (Chapter 43)
- Turn *flaws* into *features* (Chapter 43)
- Be careful with *terminology* (Chapter 44)
- The importance of *backwards compatibility* (Chapter 44)
- Sometimes the *implementation* shapes the *interface* (Chapter 44)
- *TNSTAAFL*: there is no free lunch (Chapter 45)
- *Communication* is inherently unreliable (Chapter 48)
- Use *checksums* for integrity (Chapter 48)
- Be careful setting the *timeout* value (Chapter 48)
- *Idempotency* is powerful (Chapter 49)
- "*Perfection* is the enemy of the good. Even in a beautiful system, there are corner cases." (Voltaire's law, Chapter 49)
- *Innovaton* breeds innovation (Chapter 49)
- "*Measure*, then build." (Patterson's law, Chapter 50)
- *Crash consistency* is not a panacea (Chapter 50)
- Understand the importance of *workload* (Chapter 50)
- Be careful of the *weakest link* (Chapter 53)
- Avoid storing *secrets* (Chapter 54)
- *Privilege escalation* is considered dangerous (Chapter 55)
- Don't develop your *own ciphers* (Chapter 56)
- Infer *implicit* information if necessary (Appendix B)