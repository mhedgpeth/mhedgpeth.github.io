---
id: 940
title: My Advice For Chef in Large Corporations
date: 2015-09-23T11:21:34+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=940
permalink: /my-advice-for-chef-in-large-corporations/
snap_isAutoPosted:
  - 1
dsq_thread_id:
  - 4158265275
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:4:"doFB";i:0;}}";'
snapLI:
  - 's:289:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snapTW:
  - 's:318:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:62:"My advice to those who implement @chef in large corps - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"646721227445305344";s:5:"pDate";s:19:"2015-09-23 16:22:11";}}";'
categories:
  - insights
tags:
  - chef
  - devops
  - implementation
  - strategy
---
Here's my simple advice about [Chef](http://hedge-ops.com/intrinsic-motivators-leading-to-chef/) I wish I would have heard a year ago:

All of the stories about [the unicorns, rainbows, and fairies](http://www.itskeptic.org/content/devops-unicorns-horses-and-mules) that are doing absolutely amazing things with configuration automation are extremely inspirational. [Read about them](http://hedge-ops.com/customizing-chef-book-review/). Learn about them. Enjoy their talks. Enjoy their hipster vibe. Tell yourself that you are going to be cool like that one day.

And then forget everything they are talking about. Because what they are doing is likely too advanced for what you're trying to do, because you're not five years or more into your infrastructure automation initiative.

<!--more-->

Do this instead:

Create these four nodes in your Data Center, behind firewalls, with no outside connectivity whatsoever:

  1. A Chef Server
  2. A Chef Client with the [ChefDK](https://downloads.chef.io/chef-dk/) installed on it
  3. A Chef Analytics Server
  4. An Artifacts Server (like SFTP server)

Does your security team not allow connectivity between Production and UAT? Awesome! Build two environments! Does your security team segment audited environments from non-audited environments? Awesome! Build the above four servers in _every segmented environment you have. _

You heard that right. Now isn't the time to get into pissing matches about your "new devops vision of greatness" that will totally transform&#8230;EVERYTHING! No, now is the time to automate the things. Set up your servers and make it happen.

If this becomes political, then you are doing it wrong.

_But Michael, how am I going to maintain all those environments? _Well, thankfully you have the joy and pleasure of (1) probably having a bad system in place which is why you are looking at Chef, and (2) Policyfiles. So get over your perfectionism and implement this easy workflow for change management:

  1. [Use a policyfile](https://docs.chef.io/config_rb_policyfile.html) for every node in your infrastructure
  2. Save changes to policyfiles into Git where each team has their policyfiles in their own git repository separate from their cookbooks
  3. Use your CI [to automatically generate](https://docs.chef.io/ctl_chef.html#chef-install) your policyfile.lock.json files and check them into Git.
  4. Use your CI to [to package each policy into a file](https://docs.chef.io/ctl_chef.html#chef-export) with the [chef export](https://docs.chef.io/ctl_chef.html#chef-export) command. This has all cookbooks, policy, everything.
  5. [Get your updated policy archives to your Data Center](http://lmgtfy.com/?q=how+to+transfer+a+file+from+one+place+to+another). You should be good at this. You do this already.
  6. [Activate your archives](https://docs.chef.io/ctl_chef.html#chef-push-archive) on the Chef Server for the appropriate policy group with the [chef push-archive](https://docs.chef.io/ctl_chef.html#chef-push-archive) command

It's as easy as that. Have one or a hundred chef servers and you have those six steps above. You can save the absolutely mind blowing automation of step #5 and the simplification of everything later. That's not the most important thing.

Here's what's most important: an application team deploys an upgrade with zero outages and zero problems. Then they brag to their leadership about it because it never went this smoothly when they did it the old way.

Notice nobody cared about a stupid security argument about what ports are open between environments (there are none in the above proposal) or trying to be [like Etsy](https://codeascraft.com/) or Netflix. People saw the zero outage and zero problems and people said to themselves, &#8216;Holy Shit This Is Real.'

<img class="aligncenter" src="http://i.imgur.com/ON3nwXb.png" alt="" width="500" height="500" />

Multiply the "[Holy Shit This Is Real](http://imgur.com/ON3nwXb)" moments.

That's what you're trying to accomplish. Not a dream state. Not what a book said. You're fundamentally transforming your organization's ability to react to change, and that capability will be an absolute game changer.

So get out of the politics, get out of the arguments, document and implement the simple strategy above, and watch perceptions of what is possible rapidly change.