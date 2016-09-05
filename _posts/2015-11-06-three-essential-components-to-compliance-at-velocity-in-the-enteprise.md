---
id: 914
layout: post
title: Three Essential Components to Compliance at Velocity in the Enteprise
date: 2015-11-06T08:00:26+00:00
categories: 
  - culture
  - chef
  - security
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-three-essential-components-to-compliance-at-velocity-in-the-enteprise 
show_related_posts: true 
guid: http://hedge-ops.com/?p=914
permalink: /three-essential-components-to-compliance-at-velocity-in-the-enteprise/
dsq_thread_id:
  - 4272696529
---
Security has been the most difficult part of [implementing chef](/intrinsic-motivators-leading-to-chef/) in my large organization. I recently spoke with Chef about this and had a great conversation with [Justin Arbuckle](https://twitter.com/dromologue) related to it. Chef is focusing this year on helping organizations like mine to achieve compliance at velocity.

Through the conversation and Justin's great advice, I realized that every Chef initiative must have these three elements to be sucessful:
  
<!--more-->

## **Focus on the Workflow**

At first I was focused on the technology and what talked to what, which commands would be used, and how awesome the outcome would be for our business. From a security perspective, however, this was worthless. Security and compliance are focused on _how we can safely make changes to this system. _This means that you don't accidentally bring production down by a cookbook change. It also means that you get approvals within a defined process before making _any _change. For us, this workflow didn't really take shape until we decided to fully adopt [the Policy feature](https://github.com/chef/chef-dk/blob/master/POLICYFILE_README.md) and workflow for change management. We then wrote extensive documentation and visio diagrams to explain every element of every step in the journey from a checkin to a production change.

It wasn't until we had this documented and clear that we started making progress with our security team. The lesson we learned was: _the technology is secondary to the workflow_. The workflow is most important. And, for you, if you're security conscious and you haven't looked at Policies yet, you really need to.

## **Make it Real**

Looking back at the last few months of our implementation, we've spent way too much time in visio and not enough time creating a real environment in order to demonstrate the changes we're talking about. I spent quite a lot of time trying to consolidate the chef ecosystem into something that someone could understand in an hour-long meeting, but that was ineffective. It turns out that: (1) chef is complicated and hard, that's why it's so powerful, and (2) people don't generally have time to wrap their minds around it like I have.

Knowing what I know today, I would have started by creating an environment that demonstrated what I was talking about and then showed every stakeholder the workflow (defined above) applied to a real work situation that I could control. This is what we have done: we migrated YouTrack management to Chef and will demonstrate a secure, repeatable workflow to our security stakeholders with that.

This will shift the conversation away from the abstract and into the implemented. It also means there are no unknowns to implementing the solution.

## **Empower Security**

Security people are used to hearing from people, "We want to do this cool thing that will make _our _lives easier but will make _your _lives more difficult." It's natural for them to  approach chef in the same way.

Fortunately, chef has made some amazing investments lately in features that enable a partnership with security rather than an impediment. The [audit mode features](https://www.chef.io/blog/2015/04/09/chef-audit-mode-cis-benchmarks/) recently released in Chef allow a security team to map the auditor's implementation of the security compliance into actionable requirements that can then be applied to the system.

So, all of the sudden, the crazy devops person who wants to make everything go faster is the person who will enable automated, reported compliance for PCI throughout our data center. The posture of the security group changes from being antagonistic into being a true partnership.

We're planning on taking some PCI requirements and writing audit cookbooks for them. We'll go into the auditing relationship with demonstratable proof that we are creating a more secure, auditable, and fast system for managing configuration in our hosted environment.

## **Conclusion**

Empathy is probably the most important aspect of any change. Begin with how a change will improve the effectiveness of your colleagues and the ultimate profitability of your company. Security is no different. Thanks to my friends at Chef, I have a more solid strategy for meeting those goals.