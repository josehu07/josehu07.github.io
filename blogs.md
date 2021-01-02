---
layout: main
title: "Blogs"
permalink: /blogs.html
---

# Blogs

<p class="navigation-bar">
  <a href="/index.html">About Me</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/publications.html">Publications</a>&nbsp;&nbsp;|&nbsp;&nbsp;
  <b>Blogs</b>&nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="/notes.html">Notes</a>
</p>

Sometimes, I write down what I learned, what I thought, what suprised me, and what I wanted to remember.

<div style="text-align: center; padding-bottom: 10px;">
  <style>
    a.btn-rss {
      color: #EC7063;
      opacity: 0.8;
      display: inline-block;
    }
    a.btn-rss:hover, a.btn-rss:focus {
      opacity: 1;
    }
    img.subscribe-rss {
      height: 24px;
      vertical-align: middle;
      padding-left: 3px;
    }
  </style>
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
