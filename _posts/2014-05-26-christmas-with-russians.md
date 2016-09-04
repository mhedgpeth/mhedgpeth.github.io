---
id: 16
title: Christmas with Russians
date: 2014-05-26T08:00:28+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=16
permalink: /christmas-with-russians/
dsq_thread_id:
  - 2790122782
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:218:"a:1:{i:0;a:8:{s:4:"doFB";s:1:"1";s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:265:"a:1:{i:0;a:8:{s:4:"doLI";s:1:"1";s:10:"AttachPost";s:1:"1";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapTW:
  - 's:146:"a:1:{i:0;a:5:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";}}";'
categories:
  - insights
  - success
  - tools
tags:
  - career
  - Continous Integration
  - continuous integration
  - success
  - teamcity
  - tools
---
It was Christmas 2008, and the world was going to end. We didn't know if there would be an economy or even civilization. And I had two weeks of vacation to end the year. I had an 18 month old who was mostly occupying himself with Christmas toys, and my wife was two months away from having my second child. I didn't really want to take the vacation, but the policy at the time was "use it or lose it", so I took it.

I could have done anything with those two weeks.<!--more-->

I chose to set up <a href="http://martinfowler.com/articles/continuousIntegration.html" target="_blank">Continous Integration</a> for one of our largest products through <a title="TeamCity" href="http://www.jetbrains.com/teamcity/" target="_blank">TeamCity</a>.

This was something I was passionate about. I had <a href="http://www.amazon.com/gp/product/B0026772IS/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0026772IS&linkCode=as2&tag=hedgeopscom-20&linkId=RJ6US3SXFLCWDTR5" target="_blank">read the literature</a> on how transformative Continuous Integration had been to organizations. This product was built twice a day by a homeade tool called bmcon.exe and some batch files. If the build broke, dozens of people stopped everything to try to get it working, with no clear feedback mechanism for knowing what went wrong, who did it, and whether it was being worked on.

It was my moral duty to fix this.

And it so happened that those working on TeamCity were going to take their Christmas holiday…<a href="http://en.wikipedia.org/wiki/Christmas_in_Russia" target="_blank">on January 7</a>. They were Russian. So I took it upon myself to monitor the email and get the build working over the Christmas holidays. I remember on Christmas day <a href="http://youtrack.jetbrains.com/issue/TW-6471" target="_blank">I was conversing with</a> <a href="http://de.linkedin.com/in/jonnyzzz" target="_blank">Eugene Pentrenko</a> across the world about how to deal with the complexities of TFS pulling thousands of files and then building them*.

Years later, almost all of our products build with TeamCity, and we have thousands of integration tests and tens of thousands unit tests that run on our 100+ build agents to make it happen. It is central to everything we do. And it all started one Christmas years ago when I had a "moral duty" to do something.

In the book "<a href="http://www.amazon.com/gp/product/B008KPM424/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B008KPM424&linkCode=as2&tag=hedgeopscom-20&linkId=52YQPMBZ7Z4IMUKU" target="_blank">Selling with Noble Purpose</a>",<a href="http://www.mcleodandmore.com/what-is-selling-with-noble-purpose/" target="_blank">Lisa McLeod</a> leads the reader through an exercise where the reader thinks about situations where one makes a difference with customers, in a different way than other people, while loving what they are doing. When I went through this exercise I was reminded of this story. Through the exercise I found my noble purpose:

**I share tools and insight for success**

This is what truly excites me, and why this blog exists. I want to share the tools and insights I've found to succeed. I want to help those who have given me tools and insights that have made me more effective by spreading them to others. And I want to properly define success so I can make sure to follow the path that will lead me there.

In the next few posts, I'll talk about key elements of _true_ success. Success is one of those things that seems easy to see in others, but never seems recognizable in ourselves. I think I've found a few reasons why this is.

_* You can't see it in the issue I link to above but Eugene was emailing me and went above and beyond, after his normal hours, to resolve the issue._