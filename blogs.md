---
layout: main
title: "Blogs"
permalink: /blogs.html
---

# Blogs

<p class="navigation-bar">
  <a href="/index.html">About Me</a> | 
  <a href="/publications.html">Publications</a> | 
  <b>Blogs</b> | 
  <a href="/notes.html">Notes</a>
</p>

Sometimes, I write down what I learned, what I thought, what suprised me, and what I wanted to remember.

### Memorandum

- [Research (Conference) Paper Writing Streamline](/assets/file/paper-writing.pdf)
- [Basic GDB Usage Cheatsheet](/assets/file/gdb-usage.pdf)
- [Operating Systems History Summary in an XMind Tree](https://www.xmind.net/m/2cpqNJ/)

<ul>
  {% for category in site.categories %}
    {% if category[0] == "Memo" %}
      {% for post in category[1] %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a><br>
          {{ post.date | date_to_string }} - {{ post.author }}<br>
          <small>{{ post.excerpt }}</small>
        </li>
      {% endfor %}
    {% endif %}
  {% endfor %}
</ul>

### Technical

<ul>
  {% for category in site.categories %}
    {% if category[0] == "Technical" %}
      {% for post in category[1] %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a><br>
          {{ post.date | date_to_string }} - {{ post.author }}<br>
          <small>{{ post.excerpt }}</small>
        </li>
      {% endfor %}
    {% endif %}
  {% endfor %}
</ul>

### Personal

<ul>
  {% for category in site.categories %}
    {% if category[0] == "Personal" %}
      {% for post in category[1] %}
        <li>
          <a href="{{ post.url }}">{{ post.title }}</a><br>
          {{ post.date | date_to_string }} - {{ post.author }}<br>
          <small>{{ post.excerpt }}</small>
        </li>
      {% endfor %}
    {% endif %}
  {% endfor %}
</ul>