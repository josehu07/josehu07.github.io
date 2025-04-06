---
layout: main
title: "Blogs"
permalink: /blogs.html
---

<p class="navigation-bar">
  <a href="/index.html">About Me</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/publications.html">Publications</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <b>Blogs</b>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/notes.html">Notes</a>
</p>

# Blogs

Occasionally, I write down what I learned, what I thought, what surprised me, and what I wanted to remember. I've been sloppy on these blogs, but still trying my best to keep up!

<div id="subscribe-to-rss">
  <a class="btn-rss" href="/feed.xml" target="_blank">
    <b>Subscribe to my RSS feed <img class="subscribe-rss" src="/assets/img/RSS-icon.svg" /></b>
  </a>
</div>

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
