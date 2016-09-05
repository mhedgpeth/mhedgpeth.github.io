---
id: 847
layout: post
title: How to Apply Kanban to a Large Project with High Feature Variability
date: 2015-03-23T08:00:01+00:00
categories: process
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-how-to-apply-kanban-to-a-large-project-with-high-feature-variability 
show_related_posts: true 
guid: http://hedge-ops.com/?p=847
permalink: /how-to-apply-kanban-to-a-large-project-with-high-feature-variability/
---
I was introducing some ideas I've learned recently about [throughput management](/initial-tracked-metrics-for-kanban-adoption/) to a friend of mine who is on a large project. The question came up, how to make throughput a useful metric when there are some very small features that go through the system and others that can take months with a large team.

Let's review a bit: throughput is the measurement of number of items you process through a system over a period of time. So you would say that you did fifteen features and bugs last month, and ten the month before.

If you had no control or process in place to deal with the fact that a new customer might want its killer feature, which is months of work for you, then this metric will quickly become meaningless. What to do?

There is a simple way to handle this and a complicated way. I suppose the complicated way will be what's needed for my friend's project, but the simple way is good enough for my project.<!--more-->

**The Simple Way: Break Things Down into MMFs**

On a simpler project, you can simply break a large request down into a [Minimal Marketable Feature](http://www.netobjectives.com/minimum-marketable-features-mmfs-explained). The team asks the question, what is the minimal value we can deliver to the customer in a way that they both understand it and accept it as adding value to them? It's not something like "the database column is added to the database" but it's also not "your killer feature is delivered."

When you break things down into outcomes that the customer cares about, you end up with a lot of smaller issues and variability is much smaller.

This is what I would try first. But what if that doesn't work? What if the customer doesn't care about your breakdown and just wants the feature?

**The Complicated Way: Break Epics into Stories**

The more complicated way I got from [the Kanban book](http://amzn.to/1GgXlcU) is to continue to allow the customer to define things _their _way. Those items, when they are too big to break down, are called Epics and won't be counted as throughput. The Epics are broken down into stories that are still testable outcomes. In other words, we are still avoiding the "database column is added" story. Your throughput metric will track the number of stories that are processed through the system.

I've seen mixed success from teams that are trying to break things down. People tend to want to break things down into layers and not into testable outcomes for end users. Once that skill is mastered, however, the team has a good way to track throughput through the system.

**But what about Story Points?**

Another way to track throughput is through story points. I don't like this. I've read evidence that when velocity by story points are managed to increase, the team simply begins to increase their story point estimates. We want to make sure we manage elements of the system that cannot be doctored, either subconsciously or consciously.

Also the Kanban book adds to the disdain of story point estimates by bemoaning the waste associated with getting an entire team together for the estimation.

So the exercise to measure throughput starts with ensuring that items flowing through the system are of a predictable size. Either way above would work, even for my friend on the large, established project.