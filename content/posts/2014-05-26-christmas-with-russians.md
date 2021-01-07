---
title: Christmas with Russians
date: 2014-05-26T08:00:28+00:00
tags:
  - culture
  - growth
  - teamcity
  - automation
  - career
  - Continous Integration
  - continuous integration
  - success
  - teamcity
  - tools
author: Michael
slug: christmas-with-russians
---
<div class="full-width">
  <img src="/images/feature-christmas-with-russians" alt="Christmas" />
</div>

It was Christmas 2008, and the world was going to end. We didn't know if there would be an economy or even civilization. And I had two weeks of vacation to end the year. I had an 18 month old who was mostly occupying himself with Christmas toys, and my wife was two months away from having my second child. I didn't really want to take the vacation, but the policy at the time was "use it or lose it", so I took it.

I could have done anything with those two weeks.

I chose to set up [Continous Integration](http://martinfowler.com/articles/continuousIntegration.html) for one of our largest products through [TeamCity](http://www.jetbrains.com/teamcity/).

This was something I was passionate about. I had [read the literature](http://www.amazon.com/gp/product/B0026772IS/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0026772IS&linkCode=as2&tag=hedgeopscom-20&linkId=RJ6US3SXFLCWDTR5) on how transformative Continuous Integration had been to organizations. This product was built twice a day by a homeade tool called bmcon.exe and some batch files. If the build broke, dozens of people stopped everything to try to get it working, with no clear feedback mechanism for knowing what went wrong, who did it, and whether it was being worked on.

It was my moral duty to fix this.

And it so happened that those working on TeamCity were going to take their Christmas holiday...[on January 7](http://en.wikipedia.org/wiki/Christmas_in_Russia). They were Russian. So I took it upon myself to monitor the email and get the build working over the Christmas holidays. I remember on Christmas day [I was conversing with](http://youtrack.jetbrains.com/issue/TW-6471) [Eugene Pentrenko](http://de.linkedin.com/in/jonnyzzz) across the world about how to deal with the complexities of TFS pulling thousands of files and then building them*.

Years later, almost all of our products build with TeamCity, and we have thousands of integration tests and tens of thousands unit tests that run on our 100+ build agents to make it happen. It is central to everything we do. And it all started one Christmas years ago when I had a "moral duty" to do something.

In the book "[Selling with Noble Purpose](http://www.amazon.com/gp/product/B008KPM424/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B008KPM424&linkCode=as2&tag=hedgeopscom-20&linkId=52YQPMBZ7Z4IMUKU)", [Lisa McLeod](http://www.mcleodandmore.com/what-is-selling-with-noble-purpose/) leads the reader through an exercise where the reader thinks about situations where one makes a difference with customers, in a different way than other people, while loving what they are doing. When I went through this exercise I was reminded of this story. Through the exercise I found my noble purpose:

**I share tools and insight for success**

This is what truly excites me, and why this blog exists. I want to share the tools and insights I've found to succeed. I want to help those who have given me tools and insights that have made me more effective by spreading them to others. And I want to properly define success so I can make sure to follow the path that will lead me there.

In the next few posts, I'll talk about key elements of _true_ success. Success is one of those things that seems easy to see in others, but never seems recognizable in ourselves. I think I've found a few reasons why this is.

_* You can't see it in the issue I link to above but Eugene was emailing me and went above and beyond, after his normal hours, to resolve the issue._