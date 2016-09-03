---
id: 1105
title: 'Test Kitchen: Required, not Optional'
date: 2016-02-26T08:00:21+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=1105
permalink: /test-kitchen-required-not-optional/
dsq_thread_id:
  - 4573697350
snap_isAutoPosted:
  - 1
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:289:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snapTW:
  - 's:355:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:99:"Using @chef without @kitchenci is like opening a restaurant without tasting the food first - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"703220558712819713";s:5:"pDate";s:19:"2016-02-26 14:10:21";}}";'
categories:
  - insights
tags:
  - chef
  - test kitchen
---
When I first started reading through [the Learning Chef book](http://hedge-ops.com/learning-chef-book-review/) I became quite fascinated and enamored by [Test Kitchen](http://kitchen.ci/). The community created such a wonderful way to introduce testing into their workflow. That's fantastic!

Integration and support of Test Kitchen was one of our reasons for [partnering with Chef](http://hedge-ops.com/technology-partnership/). We had a way to create a test-driven infrastructure, which would be essential to truly scaling our automation to fit our vision. But, I reasoned, for now we would leave it out of the picture so we can focus on the more important tasks like developing cookbooks and establishing a [change-management workflow](http://hedge-ops.com/my-advice-for-chef-in-large-corporations/) that fit our broader security model.

I now see that I was looking at this all wrong.<!--more-->

The choice to forego testing is a common one: teams often make sure then have a core idea that will work before they invest in testing. Then they pivot very hard into the testing direction when the core is there. This is the direction I took, largely because of how we couldn't easily get Windows, Test Kitchen and vagrant to work together.

I changed my mind when I recently tried to work with a group of 25 people to learn Chef. In the workshop I asked people to set up a virtual machine somewhere, copy stuff over, get it on a chef server (or run it in local mode directly) and then watched them struggle with the nonessential details and not get much done.

The reality then dawned on me:** Test Kitchen is the only efficient way to run your cookbooks.** It's not for testing first. It's for running first. If you are a developer, you're used to coding a little and running a little. The reality all developers discovered decades ago is that** you're not going to get very far with coding unless you are running your code frequently.**

Since chef runs on an infrastructure, it's much more difficult to run. You have to run it on a virtual machine. This is what Test Kitchen is for.**** 

Using chef without Test Kitchen is like opening a restaurant and inviting everyone to taste the food without practicing with your kitchen staff first. No one would do that because it would fail miserably. The restaurant would spend a massive amount of time getting feedback on a product that they can't trust is ready for external consumption.

So my next task is to get us up and running with Test Kitchen. I now know that it's not just a nice tool for testing; it's an essential part of coding with chef.