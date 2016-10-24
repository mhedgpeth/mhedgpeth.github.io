---
layout: post
title: "Chef with Windows"
date: 2016-10-24T08:00:00+00:00
categories: chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 20
feature_image: feature-chef-with-windows
show_related_posts: true
square_related: related-chef-with-windows
permalink: /chef-with-windows/
---
Recently [Peter Burkholder asked in the community](https://discourse.chef.io/t/chef-in-a-windows-monoculture-success-examples/9733/7) whether anyone was doing Chef at scale in a Windows environment and what lessons were learned along the way to make that happen. While we at NCR are certainly *not* the first windows-oriented business to utilize Chef at scale, [we are doing it](https://www.youtube.com/watch?v=ZG3OZologLU&t=45s) and I have a lot of experience and ideas that could  be helpful to others. Many of those ideas have been solidified as [my wife](http://www.anniehedgie.com) has been recently working with a lot of Microsoft-oriented people and I've had to explain the culture to her.

At first adopting a non-Microsoft technology can feel daunting. No matter where you go within the Microsoft landscape there is either a competing Microsoft-endorsed technology or one that is rumored to be in existence. So you get a lot of people who will see that something isn't from them and just dismiss it outright.

Another hurdle to overcome is that people within this culture view open source as chaotic and expensive. Many people outside of the Microsoft ecosystem view open source as a driver for innovation and thus tolerate the chaos that happens when trying to get it to work. People who have spent their careers with Microsoft technologies don't think that way; they want it to work, be intuitive, documented, and they want to get someone on the phone if something goes wrong.

For these reasons, in an organization that has heavily invested in Microsoft, I would **not** start with the awesomeness of the technology. This will get you nowhere. Instead, **it all boils down to the business case for the proposed change**. Do we need to do configuration management with Chef or do we need to use System Center or some other related technology? It's a great question and probably one that should be considered through deep investigation.

Find the business case by demonstrating that the current process isn't working either by keeping costs high (usually labor) or delaying business opportunities (usually new development). The more you can get on the right side of that business case, the better time everyone will have.

So if the business is using GPOs for managing configuration state on the active directory, then do a compliance scan against your nodes and see how they line up with the CIS benchmark for Windows Server 2012. Oh wait...it's total chaos. Why? Hint: people are using remote desktop to make your system unmanageable by making one-off changes...everywhere. Another hint: this is absolute insanity.

Keep digging.

Can you get a machine up and running quickly? Why not? Would chef help with that?

If you need to configure a third party tool like monitoring or logging, can you do that effectively? Sure it's great when all you do is Microsoft and it all fits together nicely, but is that realistic?

What happens to your operations costs when we take away the UI when looking at the Microsfot stack (or even Windows Server 2016)? They will go way down, but you're not going to get there without automation.

Do you want to go to Azure? Do you realize that going to azure without an automation plan is like buying a tank, driving around a city (your business) and pushing random buttons? It's going to cause damage if you don't have a radical change towards automation. In other words, the problems you have been facing related to scale do not have anything to do with the fact that you had to call Dell before to get hardware racked. It's everything after that too! So will System Center help you there?

The answers to all these questions, as with many technologies, is...maybe Microsoft is the best way, but usually not. That's another quite irritating aspect of Microsoft stuff. It can do everything. It solves everyone's problems. So when you're in this environment look at the results! Don't let the Microsoft sales person or the single excited Microsoft-solves-all-problems person get you sucked into ignoring common sense for your business. **If the tools you are using don't drive you to the outcomes you want, then consider changing the tools and the culture behind those tools (the people).**

The real question is **what level of support do you need to get these things done?** I think Microsoft is a fantastic platform for enterprise-level development and they have an excellent cloud solution for enterprises. But they also have a long legacy and entire culture centered around the message that you can do IT with little training and a few button clicks. By the way, [this is the exact culture that Jeffrey Snover has fought for years and years](https://www.youtube.com/watch?v=3Uvq38XOark). Snover has done great things, but it's important to remember that the culture he fought still exists, is going strong, and, even worse, is feeling threatened right now.

So as a business who do you want to align with? Sure, you have a strong and great history with Microsoft and an entire staff that knows about it. But you also need a partnership with another company to get you to where you want to be in above opportunities. Chef is an excellent choice in this regard. You have a whole group of people at Chef Inc. who really get Microsoft (like [Matt Wrock](http://www.hurryupandwait.io/), [Steve Murawski](http://stevenmurawski.com/), and [Stuart Preston](http://stuartpreston.net/) (a partner), [Jessica DeVita](http://www.theubergeekgirl.com/), [Trevor Hess](https://twitter.com/trevorghess?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor) (a partner) to name a few). This core brings Windows into the Chef ecosystem as a first class citizen. They advocate for DSC and align themselves with PowerShell/Snover. It's a fantastic Windows configuration management platform.

Also for a large 100+ node organization the other sell is that having a relationship with Chef gets you access to those best practices and people to accelerate the transformation. The consulting I've gotten from Chef regarding my approach is probably more valuable than the software itself because it has been absolutely critical to get us to the point where we can take advantage of the software.

Now that we've covered the most important thing, the outcomes, let's talk a little about technology: what about linux?

If you focus on the business outcomes, create an early adopter groundswell of support, then the linux question should solve itself. If it doesn't [someone is being an asshole](/the-technical-asshole-curse/). If that's true take them to lunch and understand their needs, then incorporate that into your overall strategy. If they still don't listen then by this point they're clearly being an asshole, so make that reality visible to leadership and work towards getting around that person. The fact of the matter is that a company whose leadership is incapable of taking advantage of fantastic strategic and ROI business opportunities because of a few people who can't handle learning another OS is not one with a bright future. Someone at some level should be able to see this.

If they fail to see it after all that, then you are indeed on a sinking ship. That would be quite depressing if there weren't so many non-sinking ships all around you that will embrace and love what you're doing. In fact, [you should come work with me at NCR](https://www.ncr.com/careers). :)
