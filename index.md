---
layout: main
title: "About Me"
permalink: /
---

<p class="navigation-bar">
  <b>About Me</b>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/publications.html">Publications</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/blogs.html">Blogs</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/notes.html">Notes</a>
</p>

# About Me

I am a computer science Ph.D. student in the [ADSL lab](https://research.cs.wisc.edu/adsl/) at the [University of Wisconsin-Madison](https://www.wisc.edu/), advised by [Professor Andrea C. Arpaci-Dusseau](http://pages.cs.wisc.edu/~dusseau/) and [Professor Remzi H. Arpaci-Dusseau](http://pages.cs.wisc.edu/~remzi/). My research interest lies in **computer systems**, especially distributed systems, operating systems, and cloud storage infrastructure.

My current research focus is on modernizing distributed replication protocols for emerging workloads, such as data-heavy replication and wide-area replication. Previously, I have studied file systems and kernel storage stack technologies for new hardware such as persistent memory.

I am working towards graduation this summer, and will join the [S3 team](https://www.amazon.science/tag/amazon-s3) at [Amazon Web Services](https://aws.amazon.com/) as a full-time Applied Scientist starting August 2025. Looking forward to the new journey ahead!

```rust
/// Keep calm & do good research!
impl<CS> Researcher<CS> for Me {
    // TODO: This method is far from complete.
    fn week(
        &mut self,
        pubs: Vec<&Paper<CS>>,
        proj: &mut Project<CS>,
        comm: Discussion<CS>, 
    ) -> Result<(), Box<dyn Error>> {
        let learning = pubs.collect()?.study()?;
        let progress = proj.hard_work()?;
        let insights = comm.make()?.summarize()?;
        self.meeting(learning, progress, insights)?;
        Ok(())
    }
}
```

If you don't mind wasting a few seconds of your life, please take a look at these projects:

- [Summerset](https://github.com/josehu07/summerset): a distributed, replicated, protocol-generic KV-store framework written in async Rust for unified state machine replication (SMR) research purposes. Summerset is generic to protocols; more are actively being added and evaluated.
- [MadKV](https://github.com/josehu07/madkv): template of a well-designed KV-store project series for the distributed systems course at my school. Use and extensions for teaching purposes elsewhere are very welcome.
- [Hux OS kernel](https://github.com/josehu07/hux-kernel): a weekend operating system kernel project built to be minimal and understandable. I documented my development of Hux into a complete set of [GitHub Wiki pages](https://github.com/josehu07/hux-kernel/wiki).
- [Garner](https://github.com/josehu07/garner): demonstrating hierarchical validation for optimistic concurrency control (OCC) on a B+-tree database index.
- [Codetective](https://josehu.com/apps/codetective): a purely client-side WASM app enabling code AI authorship detection and analysis in five clicks.

... and more on my [GitHub profile](https://github.com/josehu07) page!

<style>
  td.exp-time {
    text-align: center;
    width: 23%;
  }

  td.exp-title {
    text-align: left;
    width: 54%;
  }

  td.exp-place {
    text-align: left;
    width: 23%;
  }
</style>

### Work Experience

<table>
  <tbody>
    <tr>
      <td class="exp-time">2025.08 - 20??.??</td>
      <td class="exp-title">Applied Scientist at Amazon S3 <a href="https://www.amazon.science/tag/amazon-s3">↩︎</a></td>
      <td class="exp-place">Amazon, Seattle</td>
    </tr>
    <tr>
      <td class="exp-time">2024.05 - 2024.08</td>
      <td class="exp-title">Applied Scientist Intern at Amazon S3 <a href="https://aws.amazon.com/s3/">↩︎</a></td>
      <td class="exp-place">Amazon, Seattle</td>
    </tr>
  </tbody>
</table>

### Education

<table>
  <tbody>
    <tr>
      <td class="exp-time">2020.08 - 2025.0?</td>
      <td class="exp-title">Ph.D. Candidate in Computer Science <a href="https://research.cs.wisc.edu/adsl/">↩︎</a></td>
      <td class="exp-place">UW-Madison</td>
    </tr>
    <tr>
      <td class="exp-time">2019.09 - 2020.07</td>
      <td class="exp-title">Special Student Program <a href="https://registrar.mit.edu/registration-academics/registration-information/special-student-registration">↩︎</a></td>
      <td class="exp-place">MIT</td>
    </tr>
    <tr>
      <td class="exp-time">2019.07 - 2019.09</td>
      <td class="exp-title">Summer Research Intern <a href="http://systems.cs.ucla.edu">↩︎</a></td>
      <td class="exp-place">UCLA</td>
    </tr>
    <tr>
      <td class="exp-time">2016.09 - 2020.07</td>
      <td class="exp-title">B.Eng. in Computer Science</td>
      <td class="exp-place">ShanghaiTech</td>
    </tr>
  </tbody>
</table>

For my teaching experience and my services for the research community, please check out [my CV](/assets/file/Guanzhou_Hu_CV.pdf).

<!--
### Potpourri

I "waste" a lot of time sorting out and structuring my acquired knowledge and skills. This helps me identify the importance of what I am currently doing. You probably have different views on these fields and they may diverge from my understanding - *I totally agree.*

![Fields](/assets/img/knowledge-graph.png)

I know very little about these fields and am always willing to learn, explore, and contribute more.
-->

<p><strong>Please comment below anything you wanna say! 😉</strong></p>

<!-- For Utterance comments -->
<script src="https://utteranc.es/client.js"
        repo="josehu07/josehu07.github.io"
        issue-term="pathname"
        label="Utterances🔮"
        theme="github-light"
        crossorigin="anonymous"
        async>
</script>
