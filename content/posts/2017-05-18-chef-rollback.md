---
title: Chef Rollback with Policyfiles and Cafe
date: 2017-05-18T00:00:00+00:00
tags:
  - cafe
  - chef
author: Michael
slug: chef-rollback
---
<div class="full-width">
  <img src="/images/feature-chef-rollback.jpg" alt="Failure Masquerading as Success" />
</div>

When we first looked at application release automation tools, one of the first things people told me we needed was a solid rollback mechanism. One of my colleagues even insisted without satisfying his rollback scenarios, it was silly even looking at a tool for application release automation. I can definitely understand the sentiment; when you're doing a change and that change goes badly you really want to have a mechanism to get out of that bad situation.

It would be fantastic if we had a time machine and were able to simply tell ourselves "stop!" But in lieu of that, we have to devise a plan for when we need to get out of a change we made, we are able to do so safely.

# Policyfiles Simplify Rollback

Fortunately, we have the [policyfiles](/policyfiles/) feature at our disposal which makes **everything** in this area so much simpler. In the classical Chef model, your rollback might be a rollback change to an environment pin, or a role, or a cookbook, or a combination of all of these. And if you, like most people in a panic, made some on the fly changes to any of these, good luck with getting out of that mess.

With policyfiles, rollback of your Chef code is quite easy; you simply upload the old version of the policy to the Chef server and reconverge your nodes. That's it. It's virtually impossible to get yourself into a mess where you can't somehow "remember" what your rollback was.

# With a Defined Deployment Its Even Simpler

And, now that I've shown you how you can do a controlled, atomic deployment with a [policyfile deployment](/policyfile-deployment-with-cafe-and-psake/), things get even easier! You **just** went to Jenkins and uploaded policy `1.0.32` for your nodes related to product X. Things went south. Now go back to that same place and enter in `1.0.31` and roll out that new policy to all your nodes, safely and immediately with [cafe](/introducing-cafe/).

# Sometimes a Data Bag will Suffice

If you're just dealing with whether you're going to deploy version `A` or `B` of your application, with Chef you can just store which version you're on in a Data Bag. If your Chef code doesn't need to change, a "rollback" is simply an update of your Data Bag and then a convergence with cafe. I've found it a best practice to decouple my Chef code, wrapped in policies, with what version my application is on, stored in Data Bags.

# Code a Rollback in Critical Situations

It would be silly of me to suggest merely rolling back chef code and product code are enough to satisfy a true rollback. In some situations that isn't sufficient. Let's say we have a situation like this:

```
Version 1.0
website myweb exists

Version 2.0
website myweb exists
website newmicroservice exists
```

And let's say you went from version `1.0` to version `2.0`. And things went south, so you rolled back. In this situation, with Chef you would still have `newmicoservice` there. So to facilitate this kind of change, you'll want to do this:

```
Version 1.0
website myweb exists

Version 1.1
website myweb exists
website newmicroservice DOES NOT exist

Version 2.0
website myweb exists
website newmicroservice exists
```

Here you're giving your Chef code an ability to roll back and undo stuff you plan on doing in the future. This is smart planning. I recommend it for any time a product adds new features; always add a version of the cookbook (or better yet, an attribute to a cookbook) that will turn that thing off, so if you need to roll back you can roll back safely.

# Conclusion

Hopefully by now you can see that the rollback mechanisms offered by Chef Policyfiles are an excellent alternative to the coded rollback in other application release automation tools. In addition to this, you get all of the fantastic elements of infrastructure as code with Chef and infrastructure testing with InSpec. The holistic approach is what gets you a full solution that will create the velocity you're looking for.
