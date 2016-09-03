---
id: 840
title: Initial Tracked Metrics for Kanban Adoption
date: 2015-03-16T08:00:39+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=840
permalink: /initial-tracked-metrics-for-kanban-adoption/
dsq_thread_id:
  - 3562432260
snap_isAutoPosted:
  - 1
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:362:"a:1:{i:0;a:12:{s:4:"doFB";s:1:"1";s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:35:"10152471133176268_10152629684496268";s:5:"pDate";s:19:"2015-03-16 13:08:22";}}";'
snapLI:
  - 's:292:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:10:"AttachPost";s:1:"1";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snapTW:
  - 's:272:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"577456384058339328";s:5:"pDate";s:19:"2015-03-16 13:08:25";}}";'
categories:
  - insights
tags:
  - Cumulative Flow
  - David Anderson
  - Initial Quality
  - Kanban
  - Metrics
  - Throughput
---
One of the reasons I've read through <a title="David Anderson's consulting site" href="http://www.djaa.com/" target="_blank">David Anderson</a>&#8216;s <a title="Kanban book" href="http://amzn.to/1ywImb4" target="_blank">Kanban</a> book is the need for metrics. I was inspired by <a title="Lean Enterprise" href="http://amzn.to/1CEMvHL" target="_blank">Lean Enterprise</a> to <a title="The One Metric That Matters" href="http://hedge-ops.com/?p=779" target="_blank">become more metric-driven</a> and <a title="Measure for Reality" href="http://hedge-ops.com/measure-for-reality/" target="_blank">make measurement</a> more of the foundation of my management approach. Anderson did not disappoint. He devotes a w<!--more-->hole chapter to which metrics to track on an 

<a title="Kanban Decoupling Input Cadence from Delivery Cadence" href="http://hedge-ops.com/kanban-decoupling-input-cadence-from-delivery-cadence/" target="_blank">initial Kanban initiative</a>.

**Cumulative Flow**

Kanban is focused on limiting work in progress to create flow, so it's only natural to create a cumulative flow diagram. This should tell us a lot about the nature of flow in the project. Here is one from a recent release from <a title="YouTrack" href="https://www.jetbrains.com/youtrack/" target="_blank">YouTrack</a> that I only looked at today:

<div id="attachment_841" style="width: 510px" class="wp-caption aligncenter">
  <a href="http://hedge-ops.com/wp-content/uploads/2015/01/cumulative.png"><img class="wp-image-841" src="http://hedge-ops.com/wp-content/uploads/2015/01/cumulative.png" alt="Cumulative Flow Diagram from YouTrack" width="500" height="282" srcset="http://hedge-ops.com/wp-content/uploads/2015/01/cumulative.png 980w, http://hedge-ops.com/wp-content/uploads/2015/01/cumulative-300x169.png 300w" sizes="(max-width: 500px) 100vw, 500px" /></a>
  
  <p class="wp-caption-text">
    A cumulative flow diagram from a YouTrack project
  </p>
</div>

You can see that we had a lot in Ready for QA and nothing flowing to "Done". But then at the end of the release, many of them drop off. Did they go to the next release? Why? Why weren't they finished? The Developing features were staying constant, so it looks like that isn't a problem. The analysis is bunched up at the start of the release, but isn't occurring toward the end of the release. Is this a problem? There are so many actionable ideas that are coming out of viewing this chart. For now on, this chart will be at the forefront of any metrics my teams provide.

**Lead Time**

In a Kanban system, lead time is important because it is the basis of actions in the system. If the lead time is 20 days, you're asking your stakeholders the question, "What X items will you want 20 days from now?" Also, when determining whether something needs to be rushed through a system, we _have _to know lead time. In other words, if a stakeholder needs something in 30 days, is it possible? Without a lead time metric, that's not known.

Anderson stresses the importance of lead time distribution over mean lead time, because it will help the team understand the certainty with which commitments can be made. I wasn't able to generate lead time from YouTrack, but I created a mock one in Excel fairly easily:

[<img class="aligncenter size-medium wp-image-842" src="http://hedge-ops.com/wp-content/uploads/2015/01/lead-time-distribution-300x175.png" alt="Lead Time Distribution" width="300" height="175" srcset="http://hedge-ops.com/wp-content/uploads/2015/01/lead-time-distribution-300x175.png 300w, http://hedge-ops.com/wp-content/uploads/2015/01/lead-time-distribution.png 496w" sizes="(max-width: 300px) 100vw, 300px" />](http://hedge-ops.com/wp-content/uploads/2015/01/lead-time-distribution.png)

This tells us that we can easily promise a lead time of 10 days on the project. Many items will go much faster than that.

**Throughput**

Throughput is the measurement of how many items go through the system over a fixed period of time, usually months. Ideally throughput should be high. Here is the throughput on one of my projects from the last part of 2014:

[<img class="aligncenter size-medium wp-image-843" src="http://hedge-ops.com/wp-content/uploads/2015/01/throughput-300x220.png" alt="Kanban Throughput per Month" width="300" height="220" srcset="http://hedge-ops.com/wp-content/uploads/2015/01/throughput-300x220.png 300w, http://hedge-ops.com/wp-content/uploads/2015/01/throughput.png 474w" sizes="(max-width: 300px) 100vw, 300px" />](http://hedge-ops.com/wp-content/uploads/2015/01/throughput.png)

This tells us that there was a huge spike of productivity in October. Why was that? To be honest, it was because there was an important deadline to meet and I worked overtime on the project to get it done. Another observation from this data is that throughput is by no means consistent. Why is this? It can probably be seen in the cumulative flow diagram above if we view it for all months.

Continuous improvement goals should be to increase throughput.

**Initial Quality**

We want to make sure we don't motivate the team to speed up without regard for quality issues they are creating. So we need quality to be one of our core metrics. Anderson talks about the metric being defects per feature, but I disagree. I want to just track straight defects that are found by customers:[<img class="aligncenter size-medium wp-image-844" src="http://hedge-ops.com/wp-content/uploads/2015/01/defects-found-300x221.png" alt="Defects Found on a project" width="300" height="221" srcset="http://hedge-ops.com/wp-content/uploads/2015/01/defects-found-300x221.png 300w, http://hedge-ops.com/wp-content/uploads/2015/01/defects-found.png 474w" sizes="(max-width: 300px) 100vw, 300px" />](http://hedge-ops.com/wp-content/uploads/2015/01/defects-found.png)

Wow, October was busy! This makes me wonder whether all that productivity was worth it. November and December trended downward (but there was vacation in those months as well).

A good metric is one that initiates action, and, as you can see here, these metrics are a great start to seeing the health of a project and ideas for improvement. They will be the basis of project management going forward.

&nbsp;