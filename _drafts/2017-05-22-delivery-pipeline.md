---
layout: post
title: "Delivery Pipelines"
date: 2017-05-15T00:00:00+00:00
categories:
  - cafe
  - chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-delivery-pipelines
show_related_posts: true
square_related: related-delivery-pipelines
permalink: /delivery-pipelines/
---
Basic outline:

We think of pipelines as one-dimensional

But this isn't how *real* pipelines work. They are a series of processes with an input, processing steps, and an output

We should apply the same thing to our delivery pipelines

So have these:

- Product build. I: git, P: unit test, functional test, O: artifacts repository
- Chef cookbook. I: git, P: linting, kitchen, O: private supermarket
- Policyfiles. I: git, P: compile, O: artifacts repository
- Policyfile Deployment: I: artifacts repository, P: deploy, O: done!

You have a reverse tree where a lot of processes reverse-fan into one process at the end that brings it all together.

Twitter pic: https://twitter.com/michaelhedgpeth/status/862508182073217024
