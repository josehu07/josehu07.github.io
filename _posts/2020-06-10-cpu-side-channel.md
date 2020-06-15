---
layout: post
title: "CPU Cache Side-Channel Attacks: <i>Meltdown</i> & <i>Spectre</i>"
date: 2020-06-10 18:50:51
author: Guanzhou Hu
categories: Technical
---

One of the most dangerous kinds of security attacks is *side-channel attacks* since they are not part of the designed threat model. *Meltdown* & *Spectre*, the most recent side-channel vulnerabilities found on modern microprocessors, are good demonstration of the sneakiness and danger of side-channel attacks. These attacks combine *CPU speculative execution* + *cache timing side-channel*.

### Side-Channel Attacks

A **side channel** is some indirect signal / side effect / shared-state change produced by the processing of hidden secret which may leak information about the secret[^1]. Side channels may include:

- Electrical magnetic waves
- Power usage
- Physical vibrations
- Various timing clues
- ... (many more)

In general, **any states / signals shared between the secret and the outside world** can become a potential side channel and might be used for attacking.

### Cache Timing Side-Channel

Modern processors all use caching to boost performance. However, processor-level cache is a shared state. Suppose a secret routine and a public routine are running on a machine at the same time. The shared state here is a little bit tricky: memory addresses that the secret routine has recently visited is somewhat visible to the public routine.

Say the secret routine has just visited memory address `0xc4000`. The public routine can try reading a bunch of memory addresses and time all of these reads. The address that hits the cache (`0xc400` in this case) will expose a significantly shorter reading time. It then knows that the secret routine has just visited address `0xc400`.

Well, how can a memory address leak secret information to an attacker? Let's assume that hardware cache line is 4096 bytes in length. In the target process's virtual address space there is an array `arr[]` with valid length `10`. The attacker wants to steal a secret byte `arr[7654]` (i.e., at address `&arr + 7654`, somehow calculated by the attacker, perhaps pointing to a private key in kernel region). The attacker can use the following pattern to carry out such attack:

```c
/**
 * Leaking the secret byte `arr[7654]`.
 * Secret byte has possible value 0 - 255, so we create a
 * probing array of fixed length 256 * cache_line_length.
 * Need to make sure `&probe` is aligned to cache line, then
 * loads the `arr[7654]`-th cache line of `probe` array into
 * cache.
 */
char probe[256 * 4096];
read(probe[arr[7654] * 4096]);

/**
 * Cache timing.
 * The `b` that hits reveals `b == arr[7654]`.
 */
for (b = 0; b < 256; b++)
    timing(read[probe[b * 4096]]);
```

Note that such simple pattern won't work in most normal cases. Directly reading a protected memory address `&arr + 7654` is prohibited by OS paging. So, with a sequential processor and a trusted OS, such attacks can hardly be carried out.

### Speculative Execution

What makes such attacks possible is a modern microprocessor feature called *speculative execution*. Since modern processors have dedicated pipelines, they guess aggressively what will be executed ahead on branching / exception raising, so that empty CPU cycles won't always be wasted[^2].

The problem is that **memory protection checks are not triggered (or are delayed) on speculatively executed code**. Though execution result is revoked if the processor later finds out that it guessed wrong, the side effect - loading `probe[secret * 4096]` into cache - remains.

### Meltdown & Spectre

Meltdown & Spectre attacks are formally published in the year 2018 (check their [page](https://meltdownattack.com/)[^3]). Combining cache timing channel with speculative execution, they exploit one of most sneaky vulnerabilities in modern ISA and low-level hardware, affecting many computers across multiple operating systems.

These two attacks have similar essence. Attacker launches a process with his own provided code and tries to steal some hidden secret from the kernel memory region. Most operating systems map the whole kernel virtually into every user process's virtual address space. (Typically in the upper part, called an *higher-half kernel*.)

![HigherHalfKernel](/assets/img/kernel-memory-mapping.png)

Figure from a Quora post[^4]. The attacker wants a secret byte at address `&secret` within the kernel data region. Given an array `arr[]` in lower memory, the attacker calculates the offset `x = &secret - &arr` and then tries to read out `arr[x]`. Normally, accessing a kernel memory address would require kernel-mode execution, so the attacker cannot directly read the secret out. However, with the attack pattern as described in the above two sections, this is made possible.

### 1) Meltdown

Meltdown's core idea: speculative execution on raising exception + cache timing channel[^5].

```c
/**
 * Meltdown demo.
 * Wanna steal the byte `arr[x]`.
 */

// Attacker's snippet.
raise_exception();
read(probe[arr[x] * 4096]);

// Speculative execution might have ended here, but cache
// is not cleared.

// Cache timing.
for (b = 0; b < 256; b++)
    timing(read(probe[b * 4096]));
```

### 2) Spectre

Spectre's core idea: train the branch predictor to mis-predict + cache timing channel[^6].

```c
/**
 * Spectre demo.
 * Wanna steal the byte `arr[x]`.
 */

// Attacker's snippet / Victim gadget.
// First, feed several valid `x` values 0 <= x < arr_length,
// so that the branch predictor guesses this branch condition
// should be true.
// Then, provide the malicious `x`.
if (x < arr_length)
    read(probe[arr[x] * 4096]);

// Speculative execution might have ended here, but cache
// is not cleared.

// Cache timing.
for (b = 0; b < 256; b++)
    timing(read(probe[b * 4096]));
```

> Spectre is sometimes considered more powerful than Meltdown.
> 
> If the attacker wants to steal a secret from another victim process (instead of from the kernel data region of the same attacker process), and there is actually a victim gadget of the exact branching pattern, then Spectre can exploit it. In contrast, Meltdown can only be used to leak data from the kernel memory region within the same process.

### Mitigations Against These Attacks

Many mitigation patches have come out since the announcement of Meltdown & Spectre. Some of them are microprocessor architecture enhancements and some of them are OS software enhancements. Examples include:

- Architecture level: permission bit checking on speculatively executed instructions.
- OS software level: *kernel address space layout randomization* (KASLR) - randomize the kernel memory mapping within the process's virtual address space, so that the attacker can hardly know the address of a kernel secret.

#### References

[^1]: [https://en.wikipedia.org/wiki/Side-channel_attack](https://en.wikipedia.org/wiki/Side-channel_attack)
[^2]: [https://en.wikipedia.org/wiki/Speculative_execution](https://en.wikipedia.org/wiki/Speculative_execution)
[^3]: [https://meltdownattack.com/](https://meltdownattack.com/)
[^4]: [https://www.quora.com/In-reference-to-Linux-Kernel-what-is-the-difference-between-high-memory-and-normal-memory](https://www.quora.com/In-reference-to-Linux-Kernel-what-is-the-difference-between-high-memory-and-normal-memory)
[^5]: [https://meltdownattack.com/meltdown.pdf](https://meltdownattack.com/meltdown.pdf)
[^6]: [https://spectreattack.com/spectre.pdf](https://spectreattack.com/spectre.pdf)
