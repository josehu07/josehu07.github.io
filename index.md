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

My current focus is on distributed replication protocols, database transaction processing, and their implications on modern storage systems. Previously, I have studied file systems and kernel storage stack technologies for emerging hardware such as persistent memory.

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

- [The Hux OS kernel](https://github.com/josehu07/hux-kernel): a weekend operating system kernel project built to be minimal and understandable. I documented my development of Hux into a complete set of [GitHub Wiki pages](https://github.com/josehu07/hux-kernel/wiki).
- [The Summerset KV-store](https://github.com/josehu07/summerset): a distributed replicated KV-store framework, written in async Rust, mainly for state machine replication (SMR) research purposes. Summerset is generic to protocols; more protocols are actively being added.

### Education

<table>
  <tbody>
    <tr>
      <td style="text-align: center">2020.08 - 20??.??</td>
      <td style="text-align: left">Ph.D. candidate in Computer Science</td>
      <td style="text-align: left">UW-Madison</td>
    </tr>
    <tr>
      <td style="text-align: center">2016.09 - 2020.07</td>
      <td style="text-align: left">BEng. in Computer Science</td>
      <td style="text-align: left">ShanghaiTech</td>
    </tr>
    <tr>
      <td style="text-align: center">2019.09 - 2020.06</td>
      <td style="text-align: left">Special student program</td>
      <td style="text-align: left">MIT</td>
    </tr>
    <tr>
      <td style="text-align: center">2019.07 - 2019.09</td>
      <td style="text-align: left">Summer research intern <a href="http://systems.cs.ucla.edu">↩︎</a></td>
      <td style="text-align: left">UCLA</td>
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
