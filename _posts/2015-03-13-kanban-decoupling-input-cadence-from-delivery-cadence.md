---
id: 838
layout: post
title: Kanban Decoupling Input Cadence from Delivery Cadence
date: 2015-03-13T08:00:45+00:00
categories: process
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-kanban-decoupling-input-cadence-from-delivery-cadence
show_related_posts: true 
guid: http://hedge-ops.com/?p=838
permalink: /kanban-decoupling-input-cadence-from-delivery-cadence/
dsq_thread_id:
  - 3592061290
tags:
  - Agile Software Development
  - David Anderson
  - Delivery Cadence
  - Input Queue
  - Kanban
  - Project Management
  - Scrum
---
For my entire career, I have approached software development project planning at the level of the release. In waterfall, you plan a six month release, the first phase of which is to design and estimate the requested features to determine how much can go into the release. You are supposed to plan the whole thing. In Scrum, you plan a three week release up front. The cadence is shorter, but the process very similar. [David Anderson's](http://www.djaa.com/) [Kanban book](http://amzn.to/1yaDiHw) provides another approach that separates [the input process](/defining-the-kanban-input-queue/) from the output process.<!--more-->

In Kanban, the input queue is largely there to serve the development machine. You want to have as many items in the queue as are needed to not have anyone waiting for new work. On a typical small team, that is probably five items. A product manager would manage this queue by creating a regular meeting for all stakeholders to collectively decide what needs to happen next. Anderson recommends that the meeting happen once a week. If the product is processing work at an agile pace, this should be enough to refill the most important 2-3 items.

It's easy to think that this means that there should be weekly releases. When you step back and think about it, the release cycle has its own set of constraints. Remember that the input queue's function is to provide the development team with the most valuable items to do next. The function of the delivery is to provide that value to the customers while minimizing delivery costs.

Let's say delivery of the software means that thousands of people need to be trained, materials need to be printed, and a marketing program needs to kick off. In this situation, the fixed costs of the delivery are high and thus it is desirable that they not happen as frequently. Can you imagine doing such a release every two weeks? That would be insane!

On the other hand, delivery of the software might be very cheap because of tools [like chef](/learning-chef-book-review/) and training is built into the product. In this case, it makes sense to release more often. Perhaps a daily release would be a great idea for this type of team.

A part of the lean movement focuses on taking a situation like the former one and turning it into the latter one. Lowered fixed costs of release means that value can flow more freely to customers, and ROI happens quicker. But that's a strategic choice. At the beginning, you get the release cycle you get, and continuously improve to a better one. But because we have decoupled the input side of the equation, we get a team that is focused, flowing the highest priority work quickly through the system. I think that this will be a gamechanger for how my teams do product management going forward.