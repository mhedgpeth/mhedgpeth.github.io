---
id: 823
layout: post
title: Is Continuous Delivery Needed in Our Organization?
date: 2015-02-13T08:00:49+00:00
categories: 
  - culture
  - process
author_name: "Michael Hedgpeth"
author_url: /author/michael
author_avatar: michael
show_avatar: true
read_time: 10
feature_image: feature-is-continuous-delivery-needed-in-our-organization 
show_related_posts: true 
guid: http://hedge-ops.com/?p=823
permalink: /is-continuous-delivery-needed-in-our-organization/
tags:
  - chef
  - Continuous Delivery
  - lean enterprise
  - Learn Chef
---
Continuous Delivery sounds wonderful when [you're at a conference](http://www.infoq.com/interviews/jez-humble-lean-enterprise). You hear about companies like [Netflix](http://www.infoq.com/presentations/netflix-continuous-delivery) that deploy to production many times per day. When [learning Chef](/learning-chef-book-review/), people often ask me if we really need something that will enable us to deploy that often. Some of them are on projects that take many months to deliver, and the customer would have it no other way.

I answer this problem by splitting it up into two questions:<!--more-->

**How quickly does a customer want a Severity 1 defect fixed in production?** 

I'd say the answer to this is usually, regardless of the tooling used, within a few hours. If there is a critical defect affecting operations, no one is talking about how we'll have that delivered in a few months. People are on phones, developers are doing what it takes to get done, and something happens. So I'd say in this situation it's a great investment to automate your delivery so the emergency situation is as tested as the non emergency situation.

**How quickly does a customer want a feature in production?**

This is a trickier question. We can separate the answer into what the customer _wants _and what the customer _expects. _The customer _wants _to have the feature in production right now. Otherwise they wouldn't have told you about it. I have never heard a user make a request for change in software and say, "I'm just letting you know, I'd rather have it six months from now." Now is always better.

However, our customers have a business to run, so they're not going to be foolish with updates. They want us to [fully test and properly deliver the software](/safety-net/). So I believe their answer to this question would be: **as quickly as you can safely get it to me.**

This is a flexible arrangement based on the trust we create from automating our delivery and testing process. The better job we do, the more they trust us and the quicker they get their software. It will probably never be _today _that they get updates, but also if we're taking this seriously it also shouldn't be a long time.

So even for us, with real customers that are paying us to get it right, there is room for continuous delivery and Chef.