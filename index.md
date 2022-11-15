---
layout: main
title: "Guanzhou (Jose) Hu"
permalink: /
---

<p class="navigation-bar">
  <b>About Me</b>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/publications.html">Publications</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/blogs.html">Blogs</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/notes.html">Notes</a>
</p>

# About Me

I am a computer science Ph.D. student in the [ADSL lab](https://research.cs.wisc.edu/adsl/) at the [University of Wisconsin-Madison](https://www.wisc.edu/), advised by [Professor Andrea Arpaci-Dusseau](http://pages.cs.wisc.edu/~dusseau/) and [Professor Remzi Arpaci-Dusseau](http://pages.cs.wisc.edu/~remzi/). My research interest lies in **computer systems**, especially in operating system kernel, file systems, and distributed storage systems.

Currently, I am focusing on distributed replication protocols, database transaction processing, and their implications on storage.

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

Say hello to [the Hux OS kernel](https://github.com/josehu07/hux-kernel)! It is a weekend operating system kernel project built to be minimal and understandable. I documented my development of Hux into a complete set of [GitHub Wiki pages](https://github.com/josehu07/hux-kernel/wiki) - please do check them out!

### Education

<table>
  <tbody>
    <tr>
      <td style="text-align: center">2020.08 - 20??.??</td>
      <td style="text-align: left">Ph.D. student in Computer Science</td>
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
