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

I am a computer science Ph.D. student in the [ADSL lab](https://research.cs.wisc.edu/adsl/) at the [University of Wisconsin-Madison](https://www.wisc.edu/), advised by [Professor Andrea Arpaci-Dusseau](http://pages.cs.wisc.edu/~dusseau/) and [Professor Remzi Arpaci-Dusseau](http://pages.cs.wisc.edu/~remzi/). My research interest lies in **computer systems**, especially distributed storage systems and operating systems.

My current research focus is on modernizing distributed replication protocols for emerging workloads, such as data-heavy replication and wide-area replication. Previously, I have studied file systems and kernel storage stack technologies for new hardware such as persistent memory.

```rust
/// Keep calm & do good research!
impl<CS> Researcher<CS> for Me {
    // TODO: This method is far from complete.
    fn week(
        &mut self,
        paper: &Paper<CS>,
        project: &mut Project<CS>,
    ) -> Result<(), Box<dyn Error>> {
        let report = paper.read()?.note()?;
        let progress = project.exec()?;
        self.meeting(report, progress)?;
        Ok(())
    }
}
```

If you don't mind wasting a few seconds of your life, please take a look at these rather cool open-source projects I did!

- [The Summerset KV-store](https://github.com/josehu07/summerset): a distributed, replicated KV-store framework written in async Rust, mainly for state machine replication (SMR) research purposes. Summerset is generic to protocols; more protocols are actively being added.
- [The Hux OS kernel](https://github.com/josehu07/hux-kernel): a weekend operating system kernel project built to be minimal and understandable. I documented my development of Hux into a complete set of [GitHub Wiki pages](https://github.com/josehu07/hux-kernel/wiki).

For my teaching, research, and work experience, the awards and honors I received, and my services for the research community, please check out [my CV](/assets/file/Guanzhou_Hu_CV.pdf).

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
      <td class="exp-time">2024.05 - 2024.08</td>
      <td class="exp-title">Applied Scientist Intern (Storage Systems) <a href="https://aws.amazon.com/s3/">↩︎</a></td>
      <td class="exp-place">Amazon Seattle</td>
    </tr>
  </tbody>
</table>

### Education

<table>
  <tbody>
    <tr>
      <td class="exp-time">2020.08 - 20??.??</td>
      <td class="exp-title">Ph.D. Candidate in Computer Science <a href="https://research.cs.wisc.edu/adsl/">↩︎</a></td>
      <td class="exp-place">UW-Madison</td>
    </tr>
    <tr>
      <td class="exp-time">2019.09 - 2020.07</td>
      <td class="exp-title">Special Student Program</td>
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
