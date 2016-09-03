---
id: 1017
title: Proof of Concept
date: 2016-01-29T08:00:45+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=1017
permalink: /proof-of-concept/
dsq_thread_id:
  - 4482832599
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:289:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snap_isAutoPosted:
  - 1
snapTW:
  - |
    s:309:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:53:"Don't skip the hard questions with your POC  - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"693072675409760256";s:5:"pDate";s:19:"2016-01-29 14:06:17";}}";
categories:
  - tools
tags:
  - chef
  - culture
  - Security
---
It's a classic scenario: a group of people [want to use a tool](http://hedge-ops.com/dont-start-with-tools/) but before they can, they do a proof of concept (or POC) with the technology as a means of showing that it will do what it says it will do. In the past the proof of concept was purely a technical issue: how does the tool act when working with the various use cases we've identified? We create a sandbox and show the value at a demo or two, then we're ready to move forward.

It's easy to stop there. But I've learned to take things further. The proof of concept should include at least two other aspects beyond technology:<!--more-->

**Culture:** can you **prove** (through an experiment or two) that the people who will be involved with the new tool or change will be engaged as expected? It's nice enough to have the person who is excited about the technology get it to provide value, but can an average person within the organization?

**Security:** how does your SecOps team feel about this change? Are they on board with it or resisting it? Will they cooperate to the extent that they can put it in production in a limited capacity?

For [our Chef initiative](http://hedge-ops.com/intrinsic-motivators-leading-to-chef/) both of these elements were concerns that were outside of the scope of our proof of concept. If I were to do things again, I would have put them in scope. That would have better clarified and added urgency to all elements that posed a risk to the change.

**A good test for a true proof of concept is whether you can get something running in production.** If the answer is yes, then you are probably ready to go. If the answer is no, then watch out for what you're buying and how easily you will be able to roll out the change you are promising.