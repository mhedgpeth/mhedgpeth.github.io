---
layout: post
title: "Honeycomb and the Other Side of DevOps Transformation"
date: 2018-05-04T00:00:00+00:00
categories:
  - devops
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-honeycomb
show_related_posts: true
square_related: related-honeycomb
permalink: /honeycomb/
---
Recently I began researching ways we could increase the visibility of data within our operations in order to properly diagnose issues, answer questions for customers, and understand our opportunities for improvement.

Our key requirement is full integration of all products' data into one place. Our initial choice to help increase visibility of operations, ELK (short for ElasticSearch, LogStash, and Kibana), has struggled in this capacity. The best practice for ELK appears to be to isolate products into their own ELK clusters. This ultimately gives you islands of data with no visibility into the correlations between products.

My next research was in [NewRelic](https://newrelic.com/), largely because my boss liked it and I had a good experience with them years ago. I feel like NewRelic had too much of an "install our agent and all your problems will be solved...please give us lots of money" mentality. I don't think monitoring is that easy. There is no magic "make me see the truth" button. I don't want to pay a lot for something that will lack good outcomes, just so I could check off a hard problem with an easy solution. I need something better.

Then after a twitter RFP someone pointed me to [Honeycomb](https://honeycomb.io/). I met with Nick on their sales team on Friday and haven't gotten their approach out of my mind since then. I thought I would articulate what I heard here because I think it might be one of the most compelling, out of the box, but in retrospect _intuitive_ approaches to monitoring I've come across:

The beginning of the "DevOps" movement in retrospect was really about the fact that so many operational problems were really _engineering problems_, but that operations had told themselves that theirs was not the world of coding. Tools like [Puppet](https://puppet.com/) and [Chef](https://www.chef.io/) woke us up to the reality that traditional operational functions could be delivered through the same coded means that products were delivered. With that delivery, stability, speed, and security would all increase.

This process is painful for people without coding skills. People like me with over a decade of deep software engineering skills can create very powerful outcomes. Within the disruption those who have spent decades in operations scramble to retool their skillsets to meet the new demands.

This is all very good, and is one of the primary motivations for working with [my wife](http://www.anniehedgie.com/) to get into technology; I wanted to learn how to help people make that change. However, it would be a huge mistake to think that DevOps is about Operations taking on Development skills. There is another side to this that we are all missing:

What about the developers? What behaviors were they missing out on historically that have prevented speed, stability, and security?

The answer: while they have been great at coding, source control, continuous integration, unit testing, and integration testing (some of us might say ...maybe...), they have failed to create systems that tell us the reality of what's going on in the real world.

Their disconnection from the real world has atrophied their skillset for _caring about_ and _engineering_ solutions that iteratively observe and improve on the systems that they create.

The monitoring industry has accepted this reality as Gospel. "All you have to do is install our agent and _voila!_ you get monitoring! This path, we must admit, does not deliver monitoring that will enable the developers to make better software. No, it delivers monitoring that tells you simple stuff like "everything is broken go run and fix it." And it makes salespeople lots of money.

Then you have the good people at Honeycomb come along, and disrupt the monitoring status quo.

Honeycomb is saying rather than _accept_ that developers aren't going to care, and install yet another agent to cobble together as much of reality as possible, why don't we just get honest with everyone and say "Developers, here's a platform for you to answer questions about your system. Send us events and we'll let you answer questions." 

So Honeycomb isn't primarily about scraping logs. There are no regexes. They want an event in the form of json and they promise to let you search that event, at scale, to your heart's content.

This is a bit of a gamble. What if developers reject the higher bar to jump over? What if they say "we don't care about production because that's other people's jobs"?

You may remember that the same argument was made on the operations side. Those on the operations side who refuse to learn the best practices for automating their functions are in a dangerous spot. Even if they manage to institute their mindset in their company, they have put _their companies_ in a dangerous spot. This is not tenable because we are competing against the _market_, which is driving itself to higher and higher efficiency.

Put more simply: if your developers refuse to consider production _theirs_, then your competitors's developers will and you will lose.

I'm fascinated with where this journey toward deeper developer ownership will take us and the role that honeycomb can play in enabling that. Regardless of where this journey takes me, Honeycomb has done a service to us all within a long line of good DevOps tooling: rather than accept the status quo, they question it, dream of a world where inefficiencies are torn down, and show us the path to a better place. I'm impressed by the level of honesty and guts that took, and think that they will be rewarded for it.