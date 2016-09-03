---
id: 852
title: Kanban Prioritization with Cost of Delay
date: 2015-05-01T08:00:12+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=852
permalink: /kanban-prioritization-with-cost-of-delay/
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:292:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:10:"AttachPost";s:1:"1";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snap_isAutoPosted:
  - 1
snapTW:
  - 's:272:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"594124420156825600";s:5:"pDate";s:19:"2015-05-01 13:01:14";}}";'
dsq_thread_id:
  - 3728222810
categories:
  - insights
---
We have established an <a title="Defining the Kanban Input Queue" href="http://hedge-ops.com/defining-the-kanban-input-queue/" target="_blank">input queue</a> and defined <a title="The One Metric That Matters" href="http://hedge-ops.com/the-one-metric-that-matters/" target="_blank">the one metric that matters</a> for our Kanban project. Our standups are <a title="Kanban Standup Meetings" href="http://hedge-ops.com/kanban-standup-meetings-a-way-out-of-standup-hell/" target="_blank">more focused than ever before</a>. Now we need to focus on how to prioritize items that go into our input queue. <a title="Lean Enterprise" href="http://amzn.to/1LfPSL8" target="_blank">Lean Enterprise</a> outlines an interesting way of doing this: prioritize items by their cost of delay.

On an immature product, you might prioritize in order of who is screaming the loudest. This creates an unhealthy competition among stakeholders to see who can be the most dramatic when asking for a change.

Slightly more mature projects might look to the Hippo: the highest paid person's opinion. This can lead to a strategy that is out of touch with what customers want, because the highest paid person usually talks only to other highly paid people and their direct subordinates.

A functional Kanban project looks to return on investment. How much money will we get from this endeavor, and how quickly will we pay off the cost to create the change?

This is great, but the problem comes about in software when you have a lot of options on the table that would have a healthy return on investment. _What then? _<!--more-->

This is when the cost of delay calculation comes in handy. From _Lean Enterprise:_

> To use Cost of Delay, we begin by deciding on the metric we are trying to optimize across our value stream. For organizations engaged in product development, this is typically lifecycle profit&#8230;When presented with a decision, we look at all the pieces of work affected by that decision and calculate how to maximize our One Metric That Matters given the various options we have. For this, we have to work out, for each piece of work, **what happens to our key metric when we delay that work** (hence, "cost of delay").

Tomorrow morning I'm meeting with stakeholders for one of my projects and will prioritize tasks with this in mind. The project is focused on adding quality to our products, so the one metric that matters for this project is the rate of adoption of new features by our customers.

With that in mind we'll have a few options:

  * we can  invest in a large, new feature that we have evidence has prevented higher adoption
  * we can work on decreasing the defect rate of the automation effort itself, as there are currently more defects being reported than there are being fixed within the automation product itself
  * we can enhance the automation application by adding an undo feature which will make people more efficient at creating automated scripts

These are all important feature requests. I can name individuals who would choose a different answer as to the most important. When evaluated through the cost of delay paradigm, however, things become clear:

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default " border="0">
    <tr>
      <th >
        Effort
      </th>
      
      <th >
        What Happens to Adoption When We Delay The Work
      </th>
    </tr>
    
    <tr>
      <td >
        Adding Test Coverage to Large Feature
      </td>
      
      <td >
        It continues to suffer. This is the main inhibitor to adoption.
      </td>
    </tr>
    
    <tr>
      <td >
        Fix Defect Rate
      </td>
      
      <td >
        It will suffer slowly over time as the automation product becomes more and more unusable. For now, there won't be much of an effect on the adoption rate of products.
      </td>
    </tr>
    
    <tr>
      <td >
        Add Undo
      </td>
      
      <td >
        Over time, people should be quicker at creating scripts and coverage will go up, which should affect adoption in a positive way. If we delay this, we delay a more efficient test adoption.
      </td>
    </tr>
  </table>
</div>

Doing this exercise makes it clear to me what our next priority should be. It will be interesting to see if the cost of delay method can be easily understood and adopted by others. We are early in our adoption of Kanban, so we are building this ship as we sail it. I suppose I'll see soon enough.