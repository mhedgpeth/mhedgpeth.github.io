---
id: 852
layout: post
title: Kanban Prioritization with Cost of Delay
date: 2015-05-01T08:00:12+00:00
categories:
  - process
author_name: "Michael Hedgpeth"
author_url: /author/michael
author_avatar: michael
show_avatar: true
read_time: 10
feature_image: feature-kanban-prioritization-with-cost-of-delay 
show_related_posts: true 
guid: http://hedge-ops.com/?p=852
permalink: /kanban-prioritization-with-cost-of-delay/
---
We have established an [input queue](/defining-the-kanban-input-queue/) and defined [the one metric that matters](/the-one-metric-that-matters/) for our Kanban project. Our standups are [more focused than ever before](/kanban-standup-meetings-a-way-out-of-standup-hell/). Now we need to focus on how to prioritize items that go into our input queue. [Lean Enterprise](http://amzn.to/1LfPSL8) outlines an interesting way of doing this: prioritize items by their cost of delay.

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

| Team        | Natural Alignment                                                                   | Natural Misalignment                                |
|-------------|-------------------------------------------------------------------------------------|-----------------------------------------------------|
| Development | Faster Delivery of features                                                         | Have to be engaged in operations, more "work" to do |
| Operations  | Less fires, more consistency                                                        | Have to learn a new skillset and be a beginner      |
| Security    | More consistency, compliance                                                        | Automation can cause unknown vulnerabilities        |
| Business    | Faster ROI for development, lower cost for operations, and a scale model that works | Takes ongoing investment in culture and tools       |

Doing this exercise makes it clear to me what our next priority should be. It will be interesting to see if the cost of delay method can be easily understood and adopted by others. We are early in our adoption of Kanban, so we are building this ship as we sail it. I suppose I'll see soon enough.