---
id: 823
title: Is Continuous Delivery Needed in Our Organization?
date: 2015-02-13T08:00:49+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=823
permalink: /is-continuous-delivery-needed-in-our-organization/
snap_isAutoPosted:
  - 1
dsq_thread_id:
  - 3430198767
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:362:"a:1:{i:0;a:12:{s:4:"doFB";s:1:"1";s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:35:"10152471133176268_10152570688351268";s:5:"pDate";s:19:"2015-02-13 14:22:18";}}";'
snapLI:
  - 's:540:"a:1:{i:0;a:13:{s:4:"doLI";s:1:"1";s:10:"AttachPost";s:1:"1";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:19:"5972006648762417152";s:7:"postURL";s:124:"https://www.linkedin.com/updates?discuss=&amp;scope=16659297&amp;stype=M&amp;topic=5972006648762417152&amp;type=U&amp;a=JQiN";s:5:"pDate";s:19:"2015-02-13 14:22:19";}}";'
snapTW:
  - 's:278:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:22:"%TITLE% - %SURL% #chef";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"566240963224297472";s:5:"pDate";s:19:"2015-02-13 14:22:20";}}";'
categories:
  - tools
tags:
  - chef
  - Continuous Delivery
  - lean enterprise
  - Learn Chef
---
Continuous Delivery sounds wonderful when <a title="Jez Humble on Lean Enterprise - Great Discussion" href="http://www.infoq.com/interviews/jez-humble-lean-enterprise" target="_blank">you're at a conference</a>. You hear about companies like <a title="Continuous Delivery at Netflix" href="http://www.infoq.com/presentations/netflix-continuous-delivery" target="_blank">Netflix</a> that deploy to production many times per day. When <a title="Learning Chef Book Review" href="http://hedge-ops.com/learning-chef-book-review/" target="_blank">learning Chef</a>, people often ask me if we really need something that will enable us to deploy that often. Some of them are on projects that take many months to deliver, and the customer would have it no other way.

I answer this problem by splitting it up into two questions:<!--more-->

**How quickly does a customer want a Severity 1 defect fixed in production?** 

I'd say the answer to this is usually, regardless of the tooling used, within a few hours. If there is a critical defect affecting operations, no one is talking about how we'll have that delivered in a few months. People are on phones, developers are doing what it takes to get done, and something happens. So I'd say in this situation it's a great investment to automate your delivery so the emergency situation is as tested as the non emergency situation.

**How quickly does a customer want a feature in production?**

This is a trickier question. We can separate the answer into what the customer _wants _and what the customer _expects. _The customer _wants _to have the feature in production right now. Otherwise they wouldn't have told you about it. I have never heard a user make a request for change in software and say, "I'm just letting you know, I'd rather have it six months from now." Now is always better.

However, our customers have a business to run, so they're not going to be foolish with updates. They want us to <a title="Safety Net" href="http://hedge-ops.com/safety-net/" target="_blank">fully test and properly deliver the software</a>. So I believe their answer to this question would be: **as quickly as you can safely get it to me.**

This is a flexible arrangement based on the trust we create from automating our delivery and testing process. The better job we do, the more they trust us and the quicker they get their software. It will probably never be _today _that they get updates, but also if we're taking this seriously it also shouldn't be a long time.

So even for us, with real customers that are paying us to get it right, there is room for continuous delivery and Chef.