---
id: 1207
layout: post
title: Orchestration Maturity Model with Chef
categories:
  - automation
  - chef
  - consul
date: 2016-04-22T08:00:44+00:00
author_name: "Michael Hedgpeth"
author_url: /author/michael
author_avatar: michael
show_avatar: true
read_time: 10
feature_image: feature-orchestration-maturity-model-with-chef 
show_related_posts: true 
square_related: related-orchestration-maturity-model-with-chef
guid: http://hedge-ops.com/?p=1207
permalink: /orchestration-maturity-model-with-chef/
dsq_thread_id:
  - 4767801652
---
One of our [earliest questions](http://hedge-ops.com/proof-of-concept/) about configuration management tools is how we would do orchestration with them. We realized early on that with chef the orchestration story was fairly weak, especially compared with something like [salt](http://saltstack.com/). But chef's [other benefits](http://hedge-ops.com/technology-partnership/) outweighed the weaknesses so we moved forward.

The whole time though I was confused about why Chef hadn't invested more in orchestration. Salt and Ansible has it as a first class citizen and Puppet was [actively adding it to its product](https://docs.puppet.com/pe/latest/app_orchestration_overview.html). I didn't really "get" it until I listened to Julian Dunn's [excellent presentation](https://www.youtube.com/watch?v=kfF9IATUask) on it at Ghent.

Chef, as a company, is more interested in giving you what will work for you than giving you what you're asking for. This is what makes them such a special partner for us. They're more of a coach and less of an enabler. This has led me to think of orchestration as a maturity journey through three phases:<!--more-->

## **Phase 1: Do it Like Before!**

The first phase of orchestration will be to model how you have been doing things before. OK, I need to stop services, copy files, start services. That's orchestration, right?

At a surface level this is fine, but it leaves out the edge cases that happen when you're dealing with a scaled infrastructure:

  * What happens when a node was down and didn't get the message to stop, and then comes back up in the middle of your upgrade, and starts?
  * What happens when a new node is added at a time when  you're not doing an upgrade? Are any of those orchestration commands critical to the node itself?
  * Are you splitting configuration management between your configuration management tool _and _your orchestration? If you are directly stopping a service, THEN running chef later, then your configuration management is leaking out of your system and into other places.

## **Phase 2: Declaratively Manage State**

If we're writing chef recipes and starting from the beginning with some infrastructure, why live with the limitations of Phase 1? Why don't we solve this problem? Thankfully with a tool like [consul](https://www.consul.io/) we can solve the problem by making some subtle changes:

  * Create a real-time shared data view of the state of your system (with consul, [zookeeper](https://zookeeper.apache.org/))
  * Using this shared data view, define _all _desired states of the system. So if you need to transition your web cluster from the states of: off, waiting, converged, set that in your key value store
  * Write your chef recipe to define the desired state (resources) that are compiled _based on the desired state defined in the shared data view_. So you have an if statement that says "if we want this thing to be off right now, there is a service resource with action of &#8216;off'"
  * Write an orchestrator that manages the state transitions between nodes in the environment _by updating the shared data view_.  With consul we can do a consul_exec on our nodes to force chef to run. Or take it even further. And the orchestrator itself can be written through chef.

This gives you a number of benefits over the earlier phase:

  * If a node isn't there when the state changes, it checks in and converges to the correct state, immediately! You _always _get the node at the right state in the process because they are sharing the latest up to date shared data view
  * If a node is added, it will also converge to the correct state. It checks in and catches up immediately. Now you don't have to worry about adding nodes and coordinating that with upgrades; things will just happen.
  * All configuration management are belong to chef. Simple.

## **Phase 3: Decouple the Nodes**

The unfortunate reality though, is that even after phase 2 you may not be ready for bursting and scale. In order for those capabilities to exist, you need to have services that are independent of each other. So it shouldn't matter that your web tier is on a particular version and the database hasn't caught up yet. The web tier should tolerate that reality. So you can then update them separately and not worry about it.

I still think there is a role for real-time orchestration to happen in order to manage the portions of your infrastructure to go through a little at a time until all is upgraded. But the complexities of having to turn one layer off so another layer can do its thing should largely go away.

Unfortunately this is really up to the software design itself to facilitate. Therefore, it's really a business decision on whether that infrastructure should be made burstable and thus truly cloud-enabled. In some cases, we'll only get as far as phase 2. In others we'll go all the way, but probably camp out at phase 2 while the software catches up. That's the way it should be: let's get there little by little. As long as we're going in the right direction, we're good.