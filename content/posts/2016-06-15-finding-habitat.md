---
title: Finding Habitat
date: 2016-06-15T07:39:22+00:00
tags:
  - automation
  - chef
author: Michael
slug: finding-habitat
---
<div class="full-width">
  <img src="/images/feature-finding-habitat.jpg" alt="Finding Habitat" />
</div>

A few months ago I caught up with Julian Dunn in Ghent about what he was up to. His [talk on orchestration](https://www.youtube.com/watch?v=kfF9IATUask) was instrumental in forming [our approach](/orchestration-maturity-model-with-chef/) to solving the problem with Consul and his [blog post on docker](http://www.juliandunn.net/2015/12/04/the-oncoming-train-of-enterprise-container-deployments/) showed me he was thinking deeply and critically about some interesting topics. I reached out to him to learn more about what he was up to and spent some time with him to learn about Habitat.

When I learned that Fletcher Nichol was also working on the project, I got even more excited. Fletcher's work on [Test Kitchen](http://kitchen.ci/) has [revolutionized our workflow](/test-kitchen-required-not-optional/). Recently, I saw it lower the barrier to entry for [my wife](http://www.anniehedgie.com/) to learn Chef. There really is a "before Kitchen" and "after Kitchen" epoch in her learning. It's that revolutionary. And to see that Fletcher was focusing on this problem as well was quite exciting.

[Adam Jacob's blog post ](https://www.chef.io/blog/2016/06/14/introducing-habitat/) left me both intrigued me and a little confused. I wanted to understand what Habitat was and how it fit into Chef's infrastructure and strategy. So I watched the event and got on twitter and had a fun time figuring it out.

It was clear to me even from my early talks with Julian that Habitat was a disruptive technology. This is yet another reason why [Chef is such a good partner for us](/technology-partnership/). I can trust them to prioritize _the right solution_ for me over whether this will help their sales numbers this quarter. That trust drives sales higher than other companies because navigating this journey is difficult and we need people on our side who will tell us the hard truths on how to arrive at our destination. So kudos to Chef and its leadership for being so brave to make this step that says "there's another aspect to the problem that could be better, here's what we think"

Unfortunately, the initial message of Habitat didn't resonate with me. I feel that it suffered from a few flaws that hurt it's ability to resonate with enterprise customers like me:

  * **You're doing it wrong**. I reread the narrative about the siloed enterprise and the big web and am still struggling to understand it. What I felt initially is "how you have been approaching the problem of configuration management is all wrong." I'm honestly not sure whether that should have been the feeling I got because honestly I still don't understand the narrative they were going for. I do know that a good pitch to enterprise people _should not_ start with the message "your organization is fundamentally improperly structured" People don't like to hear that. And even if they agree, there is nothing they can do about it. The message (intended or not) isn't necessary because Habitat doesn't ask you to change any of that (see my revised message below).
  * **Here is a Cool Solution.** And it is. You put some really great people on this project for months or more, I expect it to be cool. But from an enterprise perspective its coolness carries little weight on whether it will help us solve the problems we are having. I would have preferred some discussion on what outcomes the team was able to accomplish as they partnered with an early customer, preferably from the enterprise. What did they do? Is it better? Why? Without this context it was difficult to put the solution in context.
  * **Context?** This was the part I struggled with the most. How does Habitat fit into the Chef ecosystem? Where does it start and Chef begin? What problems does it solve that _both_ products could solve? Why would I choose one over the other? It was difficult to understand, especially over the medium of twitter where characters are limited and tone isn't easily communicated.

Am I still excited about Habitat? Absolutely! After talking with a few people and with Julian for 15 minutes or so, I can now think about it in terms that make sense to me that I can share with others in our organization. In the spirit of providing alternatives when sharing problems, **here's the pitch I would give if someone in my organization would ask me about it today**:

> Chef's has done an outstanding job with configuration management of infrastructure. This is why they are our partner. They have built upon that core competency with a reporting product to see what's happening and a delivery product to manage changes. On top of that (and most importantly for us), they even help make your infrastructure more secure by helping you scan your infrastructure for security vulnerabilities and use Chef to remediate them. With Chef it is very easy to get a secure, hardened infrastructure configured for your business.
> 
> That's not all you want to do, though. You want applications _running_ on that infrastructure. And it turns out when you start down this path, things get complicated quickly. You face problems that aren't _really_ configuration management problems like orchestration or service discovery. You have to figure out how to scale. And you have an application team that wants to focus on _those issues_ rather than configure a specific machine to run. They might even insist on _not_ running a production-like machine for their development by insisting that they use docker to speed up development. How do you engage the application team in a way that helps them own their solution and use it, then deliver that automation to a broader ecosystem in a meaningful way?
> 
> Enter Habitat. With Habitat, your application team can define availability, upgrade, red/green deployments, and other application-level-concerns and package that _with the application_ and deliver it to their target environments. This means that Chef can focus what it's good at: configuration management of the infrastructure. A habitat package can live as a docker container on a development machine, a minimal QA environment, or as a full-blown linux node which was also configured using Chef.
> 
> It's tempting to try to find the one solution that will solve all of your problems. Many times that leaves you doing _a lot of work_ as you try to solve a problem with a solution that was not meant to solve those types of problems. Instead, it's totally fine to have a solution to the application's problems and a different solution for the infrastructure problems. As long as both solutions start with code, are tested early and often, and meet together very quickly, we can take advantage of their differentiated power.

This, to me is Habitat's story and is what makes me so excited for its future and so happy that I'm a partner with Chef.
