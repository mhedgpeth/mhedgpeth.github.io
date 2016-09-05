---
id: 1047
layout: post
title: Putting Developers On Call
date: 2016-01-13T08:00:14+00:00
categories: culture
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-putting-developers-on-call 
show_related_posts: true 
guid: http://hedge-ops.com/?p=1047
permalink: /putting-developers-on-call/
dsq_thread_id:
  - 4483147614
---
Recently I read through the short but sweet book [Building a DevOps Culture](http://www.amazon.com/Building-DevOps-Culture-Mandi-Walls-ebook/dp/B00CBM1WFC/ref=sr_1_1?ie=UTF8&qid=1452554943&sr=8-1&keywords=building+devops+culture) by [Mandi Walls](https://twitter.com/lnxchk). In the book Mandi has an idea that I admit to having completely dismissed the moment I read it:

> One of the early controversial aspects of what became DevOps was the assertion that Engineering should be doing on-call rotations. In fact, this idea was presented in a way that made it sound like your developers would want to be on call if they were truly dedicated to building the best possible product, because they were the ones responsible for the code.

My immediate reaction was: "that would never work for us." Whenever I have that kind of reaction, it's a red flag. Never use the word never. So I asked myself why, thought about it, and dug a little deeper.<!--more-->

The main reason this would be a challenge for us is that for compliance reasons [we keep developers out of production](http://www.sans.edu/research/security-laboratory/article/it-separation-duties). So even if the developers were on call, they would not be able to do much because they couldn't access production.

So that's a bummer.

But wait, do they _have _to access production to be on call? What if they were on call _with _someone in operations that had the access. When there was an incident they could hop on to a screen sharing application and troubleshoot things together. In fact, this mirrors what happens when an incident is escalated: you have everyone get on a call and talk through an issue together, with operations having the power and control to make the changes.

If our developers were on call, they would accept more responsibility for creating a great product. They would then see the outcome of their good or bad design, and improve on it. Operations would feel like they're not on an island trying to make something work with no context. The good things that could come out of such an initiative surely outweigh the problems.

Now that I'm sold on this being something that could help us, I'm now going to bring it up as something to try. It will be interesting to see if the idea has legs.