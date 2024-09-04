---
layout: main
title: "Publications"
permalink: /publications.html
---

<p class="navigation-bar">
  <a href="/index.html">About Me</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <b>Publications</b>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/blogs.html">Blogs</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/notes.html">Notes</a>
</p>

# Publications

I am working with [Prof. Andrea Arpaci-Dusseau](http://pages.cs.wisc.edu/~dusseau/) and [Prof. Remzi Arpaci-Dusseau](http://pages.cs.wisc.edu/~remzi/) (great advisors!) on distributed storage systems and operating systems. My current focus is on modernizing distributed replication protocols for emerging workloads, such as data-heavy replication and wide-area replication. Previously, I have studied file systems and kernel storage stack technologies for new hardware such as persistent memory.

I worked with [Prof. Harry Xu](http://web.cs.ucla.edu/~harryxu/) as a summer intern on scaling and accelerating graph neural networks computation using serverless computing.

I learned a lot from [Prof. Shu Yin](http://sist.shanghaitech.edu.cn/2018/0502/c2739a24245/page.htm) during my undergraduate study on optimizing file system organization for inherently-structured workload.

<style>
  a.btn-acmdoi {
    color: #5499C7;
    opacity: 0.8;
    display: inline-block;
    padding-right: 5px;
  }
  a.btn-acmdoi:hover, a.btn-acmdoi:focus {
    opacity: 1;
  }

  a.btn-usenix {
    color: #ff6600;
    opacity: 0.8;
    display: inline-block;
    padding-right: 5px;
  }
  a.btn-usenix:hover, a.btn-usenix:focus {
    opacity: 1;
  }

  a.btn-arxiv {
    color: #aa1e2f;
    opacity: 0.8;
    display: inline-block;
    padding-right: 5px;
  }
  a.btn-arxiv:hover, a.btn-arxiv:focus {
    opacity: 1;
  }

  a.btn-github {
    color: #34495E;
    opacity: 0.8;
    display: inline-block;
    padding-right: 5px;
  }
  a.btn-github:hover, a.btn-github:focus {
    opacity: 1;
  }

  a.btn-pdf {
    color: #EC7063;
    opacity: 0.8;
    display: inline-block;
    padding-right: 5px;
  }
  a.btn-pdf:hover, a.btn-pdf:focus {
    opacity: 1;
  }

  img.paper-button {
    height: 24px;
    vertical-align: middle;
    padding-left: 3px;
  }
  img.paper-button-small {
    height: 21px;
    vertical-align: middle;
    padding-left: 3px;
  }
</style>

### Conferences

- <b>(In submission, title fuzzed) A replication protocol for a new, untreated type of workloads</b>. <u>Guanzhou Hu</u> et al. <br/>
- <b>MadFS: Per-File Virtualization for Userspace Persistent Memory Filesystems</b>. Shawn Zhong, Chenhao Ye, <u>Guanzhou Hu</u>, Suyan Qu, Andrea Arpaci-Dusseau, Remzi Arpaci-Dusseau, Michael Swift. 2023. In Proceedings of the 21th USENIX Conference on File and Storage Technologies (<b><i>FAST '23</i></b>). USENIX Association. <br/>
    <a class="btn-usenix" href="https://www.usenix.org/conference/fast23/presentation/zhong" target="_blank"><img class="paper-button" src="/assets/img/usenix-button.svg" /> USENIX</a>
    <a class="btn-github" href="https://github.com/WiscADSL/MadFS" target="_blank"><img class="paper-button-small" src="/assets/img/github-button.svg" /> Code</a>
- <b>Dorylus: Affordable, Scalable, and Accurate GNN Training with Distributed CPU Servers and Serverless Threads</b>. John Thorpe, Yifan Qiao, Jonathan Eyolfson, Shen Teng, <u>Guanzhou Hu</u>, Zhihao Jia, Jinliang Wei, Keval Vora, Ravi Netravali, Miryung Kim, and Guoqing Harry Xu. 2021. In Proceedings of the 15th USENIX Symposium on Operating Systems Design and Implementation (<b><i>OSDI '21</i></b>). USENIX Association. <br/>
    <a class="btn-usenix" href="https://www.usenix.org/conference/osdi21/presentation/thorpe" target="_blank"><img class="paper-button" src="/assets/img/usenix-button.svg" /> USENIX</a>
    <a class="btn-github" href="https://github.com/uclasystem/dorylus" target="_blank"><img class="paper-button-small" src="/assets/img/github-button.svg" /> Code</a>
- <b>The Storage Hierarchy is Not a Hierarchy: Optimizing Caching on Modern Storage Devices with Orthus</b>. Kan Wu, Zhihan Guo, <u>Guanzhou Hu</u>, Kaiwei Tu, Ramnatthan Alagappan, Rathijit Sen, Kwanghyun Park, Andrea C. Arpaci-Dusseau, and Remzi H. Arpaci-Dusseau. 2021. In Proceedings of the 19th USENIX Conference on File and Storage Technologies (<b><i>FAST '21</i></b>). USENIX Association. <br/>
    <a class="btn-usenix" href="https://www.usenix.org/conference/fast21/presentation/wu-kan" target="_blank"><img class="paper-button" src="/assets/img/usenix-button.svg" /> USENIX</a>
    <a class="btn-github" href="https://github.com/josehu07/nhc-demo" target="_blank"><img class="paper-button-small" src="/assets/img/github-button.svg" /> Code</a>
- <b>BORA: A Bag Optimizer for Robotic Analysis</b>. Jian Zhang, Tao Xie, Yuzhuo Jing, Yanjie Song, <u>Guanzhou Hu</u>, Si Chen, and Shu Yin. 2020. In Proceedings of the International Conference for High Performance Computing, Networking, Storage and Analysis (<b><i>SC '20</i></b>). IEEE Press, Article 12, 1–15. <br/>
    <a class="btn-acmdoi" href="https://dl.acm.org/doi/abs/10.5555/3433701.3433716" target="_blank"><img class="paper-button" src="/assets/img/acmdoi-button.svg" /> ACM-DOI</a>

### Preprints

- <b>A Unified, Practical, and Understandable Summary of Non-transactional Consistency Levels in Distributed Replication</b>. <u>Guanzhou Hu</u>, Andrea Arpaci-Dusseau, Remzi Arpaci-Dusseau. 2024. <br/>
    <a class="btn-arxiv" href="https://arxiv.org/abs/2409.01576" target="_blank"><img class="paper-button" src="/assets/img/arxiv-button.svg" /> arXiv</a>
- <b>Foreactor: Exploiting Storage I/O Parallelism with Explicit Speculation</b>. <u>Guanzhou Hu</u>, Andrea Arpaci-Dusseau, Remzi Arpaci-Dusseau. 2024. <br/>
    <a class="btn-arxiv" href="https://arxiv.org/abs/2409.01580" target="_blank"><img class="paper-button" src="/assets/img/arxiv-button.svg" /> arXiv</a>
    <a class="btn-github" href="https://github.com/josehu07/foreactor" target="_blank"><img class="paper-button-small" src="/assets/img/github-button.svg" /> Code</a>

### Patents

- <b>A Storage System Management Policy Based on Data Content Locality.</b> CN. Yin, S. and Hu, G., filed in June 2019. Patent application 201910499391.9.
