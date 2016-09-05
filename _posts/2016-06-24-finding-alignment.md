---
id: 1270
layout: post
title: "Finding Alignment"
date: 2016-06-24T08:00:59+00:00
categories: culture
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-finding-alignment 
show_related_posts: true
square_related: related-finding-alignment
guid: http://hedge-ops.com/?p=1270
permalink: /finding-alignment/
dsq_thread_id:
  - 4935557197
---
I've got a lot of things on my plate right now, but let me be clear: I'm not going to stand in the way of what the business wants to do.";

I've been told this many times before. In the early days of trying to create alignment for initiatives that are important to our strategy, I would have taken it as a sign of support. Instead, I translate it into what this same person would say to her boss about this same subject.

"Michael came and talked to me about [Awesome Initiative]. (Sigh) He says it's going to really change things for us. Are we really going to waste our time with this crap or are we going to serve our customers? I'll do whatever, but fair warning: this project has &#8216;disaster' written all over it, and you won't get that feature you've been asking for either, you can kiss that goodbye for this year.";

That's quite a different story, isn't it?

So how to respond? I've been tempted in the past to write people off and try to do it anyways. I've found over the years though that this is a mistake, because a sufficiently motivated individual _can_ and _will_ destroy your project if they don't feel listened to.

I've found that the keys are** respect** and** empathy**.<!--more-->

**Respect** can't be faked. I can't _really_ only respect my opinion, or those of the consultants I'm working with, and then merely try to get _you_ on board with _my_ project. That doesn't work. People see past that. Instead, I need to walk into the relationship with the understanding and true belief that you are a smart person with real needs that may be solvable by what I'm working on. This is a discovery of where your needs meet my solutions. I'm open to changing my solution because I cannot possibly predict all of your needs without your iterative interaction.

**Empathy** is key because I really need to _feel_ what you're feeling, from a business perspective, and even from a personal perspective. What makes you excited or happy? What are you afraid of? What is painful for you? How does that affect you? Is there anything I can do to help you with that?

Following this pattern has led me to understand that, at a generic level, different groups have a natural alignment and misalignment with DevOps:

| Team        | Natural Alignment                                                                   | Natural Misalignment                                |
|-------------|-------------------------------------------------------------------------------------|-----------------------------------------------------|
| Development | Faster Delivery of features                                                         | Have to be engaged in operations, more "work" to do |
| Operations  | Less fires, more consistency                                                        | Have to learn a new skillset and be a beginner      |
| Security    | More consistency, compliance                                                        | Automation can cause unknown vulnerabilities        |
| Business    | Faster ROI for development, lower cost for operations, and a scale model that works | Takes ongoing investment in culture and tools       |

As I focus on respect and empathy I can find the natural alignment and mitigate the natural misalignment with each group.

**For developers** we can help them deliver features faster and thus get a truly agile feedback loop. But we can also help them culturally begin to share the ownership of the operatability of their product with the operations team. The key is ensuring that their desire for consistency and velocity outweighs their disdain for caring about how it works in production. We do this by finding their pain points in operations, catch them _blaming_ operations for those pain points, then show them that they actually can do something about their problem.

**For QA** we can help them deliver features more safely by minimizing the amount of time they spend creating environments and ensuring that they have consistent, hardened environments. This is all exciting, but they must engage the other teams to define infrastructure and they must be willing to not be lazy and just "click the damn checkbox"; in IIS when they want something changed. Culturally they shouldn't have a problem with this, but in reality QA always gets changes at the end of a release or sprint and is under a time crunch to ensure quality. So we work with them to show them how much time they are spending on this and how we can use automation to get them focused on the important stuff: ensuring quality in a way that computers can't or writing automation against production-like environments.

**For Operations** we can help them avoid the unexpected problems that come about without good automated configuration management. But to them, it comes at a cost. Many of the things that made them successful (incident resolution, working crazy hours, following directions) aren't compatible with creating and engaging with automation. So they have to be fine with starting from scratch and building themselves back up. They have to see a payoff if they're going to take that kind of career and time risk. The payoff in my mind is that they get to do more valuable work for the business by automating things and that value will translate into a more rewarding job for them.

**For Security** we can help them achieve the consistency and compliance at all levels that has alluded them. Yes they have controls defined and exercised in production. But they struggle with other teams thinking of them as a blocker to progress. Also, as we automate more, they're afraid that we are going to take [this nice shiny devops Ferrari and wreck it into a wall.](http://www.dailymail.co.uk/news/article-3022707/Worst-valet-Hapless-garage-attendant-destroys-300-000-Ferrari-599-GTO-bringing-round-owners-hit-accelerator-instead-brake.html) So we work on automating compliance and on developing a change management process that ensures proper control and separation of duties into production. We don't fight them. We work with them to achieve _their_ goals. Once this happens, the perceived "blocker"; becomes a champion and driver of our changes.

**For Management** they get the benefits outlined above. But they also have to lead a cultural transformation. We can't do it the easy way when that means "just running the command"; or "clicking that checkbox over there";. We have to be committed to a repeatable, auditable process for change. So we need to train the people we have with new skills and be patient as they figure this out. We need to be OK with someone spending a little while on automating that thing, because the payoff will be huge over the next few years. And we need to be OK with absorbing the cost of tooling and vendor partnerships to realize the dream.

Once we see the lay"way, it's much easier to get everyone to the goal together. While I can't guarantee that one won't encounter the statement at the beginning of the post, I can guarantee that following this model will give someone something _constructive_ to do afterwards.