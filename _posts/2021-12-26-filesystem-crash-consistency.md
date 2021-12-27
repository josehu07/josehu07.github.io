---
layout: post
title: "Formal Description of File System Crash Consistency Techniques"
date: 2021-12-26 15:28:41
author: Guanzhou Hu
categories: Technical
enable_math: "enable"
---

*Crash consistency* is one of the most essential guarantees that a storage system needs to make to ensure correctness. In a file system (FS) setting, consistency techniques must be carefully designed, integrated with the layout of blocks, and deployed in the procedure of updates. This post summarizes the three classic FS consistency techniques: *journaling*, *shadow paging* (CoW), and *log-structuring*, in a formal way and analyzes their pros & cons.

## Concept of Crash Consistency

Crash consistency is a general concept that applies to any storage system maintaining data on persistent storage media.

### General Crash Consistency

We say a piece of persistent data is in a **consistent state** if it is in a correct form representing the logical data structure it stores. For example, if a group of bytes is meant to store a B-tree, then it is in a consistent state iff. the root block is in the correct position and all non-null node pointers point to correct child nodes (no dangling pointers), etc. Note that the "data structure" does not have to be a canonical data structure such as a B-tree -- it can be any custom user specification.

We say a storage system provides **crash consistency** if data on persistent media it manages always transits from a consistent state to another consistent state. Equivalently, no matter when a crash happens during the steps of an update, data on persistent media is always left at a consistent state and can thus be *recovered* correctly upon restart.

### Disambiguation

Consistency and **durability** are two orthogonal guarantees:

- Having durability means that all requests that have been *acknowledged* to the user must have been made persistent;
- Having consistency means that when applying any request, data on persistent media is always in a consistent state.

It is possible for a storage system to be consistent yet not durable: acking requests once reaching DRAM cache, but always flushing them to persistent media in a consistent way -- acked requests might be lost after a crash, but data on persistent media is always consistent, thus can be recovered (to a possibly outdated version).

It is also possible to be durable yet not consistent: reflecting any updates to persistent media immediately, but not managing ordering carefully -- acked requests must have been persisted completely, but in-progress requests might leave the system in a *corrupted* state after a crash.

This post focuses on the consistency aspect, although most file systems provide both guarantees. Providing consistency is often a must. In certain cases where the application allows version rollbacks, weaker durability might be allowed.

> The difference between crash consistency and other "consistency" terminologies should also be made clear:
>
> - In distributed systems, consistency often means the strength of guarantee of reaching global consensus on the ordering of actions;
> - Sometimes, the word "consistent" might also be used as a synonym to "uniform", such as in consistent hashing.

### FS Crash Consistency

In the setting of a file system, there are three categories of persistent data that must be managed:

1. *FS metadata*: FS-wide meta information, e.g., superblock fields, inode bitmap, data block bitmap, ...
2. *File metadata*: metadata information of a file stored in its inode, e.g., file size, data block index mapping table, ...
3. *File data*: actual user data of a file.

Depending on which of the three categories of data are guaranteed crash consistent, an FS could provide two different levels of crash consistency:

- *Metadata consistency*: FS metadata and all file metadata are guaranteed crash consistent, while file data might be not. The FS is always able to identify all files and figure out which data blocks belong to which file correctly, yet the actual content of those data blocks could be corrupted across a crash.
- *Data consistency*: in addition to metadata, the content of data blocks are guaranteed crash consistent. User update requests are applied to file data in a consistent way as well.

Metadata consistency is often enough, since applications often have their own error detection & correction mechanisms on file data. As long as the FS image is always consistent, file content does not matter too much. Some FS designs also provide data consistency inherently.

## Required Architecture Primitives

Before diving into the three FS consistency techniques in detail, I'd like to talk about two underlying hardware architecture primitives that must be available to FS developers. These two primitives are so essential that any file system design must rely on them, otherwise it is impossible to provide any consistency guarantee.

- **Atomicity**: there must be a way to write to persistent data *atomically* (complete-or-none), at least at *some granularity*. For example, to maintain a B-tree data structure consistently, there must be a way to at least write out a pointer value atomically.
    - On block drives, at least updating a sector is atomic;
    - On non-volatile memory DIMMs on x86, at least flushing a cacheline is atomic.
    - Formally, if an action $$A$$ is atomic, we denote as $$\overline{A}$$.
- **Ordering**: there must be a way to *enforce an ordering* between certain actions. For example, to append to a file consistently (assuming data write & file size update are two separate steps in the FS), there must be a way to enforce that the update to file size happens strictly after the new data blocks have been prepared.
    - On block drives, device controllers at least raise signals about completions, which the FS software waits on;
    - On non-volatile memory DIMMs on x86, *memory fences* set up barriers between updates.
    - Formally, if action $$B$$ is ordered after action $$A$$, we denote as $$A \rightarrow B$$; if actions $$C$$ and $$D$$ do not require an ordering barrier in between, we denote as $$C \vert D$$.

The formularization comes from the Optimistic Crash Consistency paper [^1].

## Three FS Consistency Techniques

This section formally summarizes the three classic FS consistency techniques: *journaling*, *shadow paging*, and *log-structuring*, and analyzes their pros & cons.

### 1) Journaling (WAL)

A **journaling** FS allocates a dedicated region of persistent storage as a **journal** (sometimes referred to as a log, though the name might get confused with log-structuring). The journal is an append-only "log" of *transactions*, where each transaction corresponds to a user update request. The idea behind journaling is that, for any user request, its transaction entry must be persisted and committed before the actual update. Journaling is a specific form of the **write-ahead logging** (WAL) technique. The action of "committing a transaction entry" must be atomic.

Journaling could be done in two different flavors:

- *Redo journaling*: transactions record new data to be applied. During recovery, the FS replays the journal forward, re-applies all committed entries, and discards all uncommitted entries;
- *Undo journaling*: transactions record backup old data. During recovery, the FS reads out all uncommitted entries to back things out, and ignores all committed entries.

Handling a user request involves the following actions:

- $$J_M$$: write out metadata changes to journal
- $$J_D$$: write out data changes to journal
- $$J_E$$: write out "transaction end" to journal, indicating a commit
- $$M$$: actual in-place update of metadata
- $$D$$: actual in-place update of data

A journaling FS has the flexibility to choose between providing only metadata consistency and providing stronger data consistency. In *metadata journaling* mode, only metadata changes are logged in the journal. This mode introduces minimal overhead. Formally, the algorithm is:

$$D \vert J_M \rightarrow \overline{J_E} \rightarrow M$$

In *data journaling* mode, data changes are logged in the journaling as well, resulting in *write-twice penalty*. Formally, the algorithm is:

$$J_D \vert J_M \rightarrow \overline{J_E} \rightarrow D \vert M$$

Many famous Linux file systems are journaling file systems, with Ext2/4 [^2] being a perfect example. By default, Ext4 is mounted in `data=ordered` mode, i.e., only doing metadata journaling. When mounted with `data=journal` option, Ext4 does data journaling. XFS [^3] also uses journaling. Also see the Optimistic Crash Consistency paper [^1] for a thorough discussion on possible optimizations to the algorithm.

### 2) Shadow Paging (CoW)

**Shadow paging** (or shadowing) is a specific form of the **copy-on-write** (CoW) technique. The idea behind shadow paging is to first write all updates to newly-allocated empty blocks (copying over any partial blocks if necessary), and then *publish* the new blocks into the file atomically.

Handling a user request involves the following actions:

- $$B$$: allocation of empty blocks
- $$W_C$$: copy any partial blocks touched by the update from current file data into the new blocks
- $$W_D$$: write out new data into the new blocks
- $$M$$: publish the new blocks into metadata (typically a pointer switch in the inode's index table)

Formally, the algorithm is:

$$B \rightarrow W_C \vert W_D \rightarrow \overline{M}$$

Shadow paging has its obvious advantages and disadvantages compared to journaling. $$\uparrow$$ Shadow paging provides data consistency without introducing write-twice penalty. $$\downarrow$$ Shadow paging works well only if most updates are bulky, block-sized, and block-aligned. Small, in-place updates will introduce significant overhead of allocation and copying. In tree-structured FS, shadow paging might also result in cascading CoW upto the root of the tree (where an atomic pointer switch can be done).

BtrFS [^4] and WAFL [^5] are two typical examples of CoW FS. To reduce the CoW overhead on small updates, WAFL aggregates and batches incoming writes into a single CoW. BPFS [^6] is a CoW FS optimized for non-volatile memory.

### 3) Log-Structuring

Introduced in the classic LFS paper [^7], a **log-structured** file system organizes the entire FS itself as an append-only log. All updates are just atomic appends to the log (involving both new data blocks and new metadata inode). Atomicity of appends is ensured by doing atomic updates to the **log tail** offset. The FS maintains an in-DRAM *inode map* recording the address of the latest version of each file's inode. This in-DRAM inode map can be safely lost after a crash -- the persistent log is the ground-truth and the FS image can be rebuilt from reading through the log and figuring out the latest version of each block.

Handling a user request involves the following actions:

- $$A_D$$: append new data blocks to log tail
- $$L_D$$: update of log tail to right after the newly appended data blocks
- $$A_M$$: append new inode metadata to log tail, which contains updated pointers to the previously appended data blocks
- $$L_M$$: update of log tail to right after the newly appended inode
- $$I$$: update the DRAM inode map image with the address in log of the new inode

Formally, the algorithm is:

$$A_D \rightarrow \overline{L_D} \rightarrow A_M \rightarrow \overline{L_M} \rightarrow I$$

Log-structuring has its own pros and cons. $$\uparrow$$ All device requests happen in a sequential manner, yielding good performance. Log-structured FS inherently provides data crash consistency. $$\downarrow$$ The log could grow indefinitely, so there must be a *garbage collection* mechanism to discard outdated blocks and compact the log. Also, though writes become sequential, reads of a single file get scattered around the log.

It is possible to combine log-structuring with journaling/shadow paging. For example, NOVA [^8] combines metadata journaling with log-structured file data blocks to optimize for non-volatile memory.

## References

[^1]: [https://research.cs.wisc.edu/adsl/Publications/optfs-sosp13.pdf](https://research.cs.wisc.edu/adsl/Publications/optfs-sosp13.pdf)
[^2]: [https://ext4.wiki.kernel.org/index.php/Main_Page](https://ext4.wiki.kernel.org/index.php/Main_Page)
[^3]: [https://en.wikipedia.org/wiki/XFS](https://en.wikipedia.org/wiki/XFS)
[^4]: [https://btrfs.wiki.kernel.org/index.php/Main_Page](https://btrfs.wiki.kernel.org/index.php/Main_Page)
[^5]: [https://en.wikipedia.org/wiki/Write_Anywhere_File_Layout](https://en.wikipedia.org/wiki/Write_Anywhere_File_Layout)
[^6]: [https://www.sigops.org/s/conferences/sosp/2009/papers/condit-sosp09.pdf](https://www.sigops.org/s/conferences/sosp/2009/papers/condit-sosp09.pdf)
[^7]: [https://web.stanford.edu/~ouster/cgi-bin/papers/lfs.pdf](https://web.stanford.edu/~ouster/cgi-bin/papers/lfs.pdf)
[^8]: [https://www.usenix.org/conference/fast16/technical-sessions/presentation/xu](https://www.usenix.org/conference/fast16/technical-sessions/presentation/xu)
