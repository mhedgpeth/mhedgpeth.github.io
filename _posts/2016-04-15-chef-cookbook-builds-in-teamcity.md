---
id: 1154
title: Chef Cookbook Builds in TeamCity
date: 2016-04-15T08:00:50+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=1154
permalink: /chef-cookbook-builds-in-teamcity/
dsq_thread_id:
  - 4670828786
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:353:"a:1:{i:0;a:11:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:12:"liMsgFormatT";s:18:"New Post - %TITLE%";s:2:"do";s:1:"1";s:11:"isPrePosted";s:1:"1";}}";'
snap_isAutoPosted:
  - 1
snapTW:
  - 's:334:"a:1:{i:0;a:10:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:60:"How we do @chef builds with @kitchenci in @teamcity - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:2:"do";s:1:"1";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"720960768225579008";s:5:"pDate";s:19:"2016-04-15 13:03:37";}}";'
categories:
  - tools
tags:
  - chef
  - chef spec
  - foodcritic
  - rubocop
  - teamcity
  - test kitchen
---
As more and more teams are [coming on board with Chef](http://hedge-ops.com/my-advice-for-chef-in-large-corporations/), I've began to standardize our pipeline and ensure that everyone meets quality gates for the infrastructure they are creating. This started with finally figuring out how to get [Test Kitchen working with Windows](http://hedge-ops.com/test-kitchen-required-not-optional/), then quickly migrated to getting it running in [TeamCity](http://hedge-ops.com/christmas-with-russians/). Our entire division uses TeamCity for configuration management, so it's something that I needed to plan out carefully in order to make the Chef pipeline _feel _like it's a part of a team's normal build process.<!--more-->

## Project Structure

With this in mind, we created a** Chef** [subproject](https://confluence.jetbrains.com/display/TCD9/Creating+and+Editing+Projects) _inside _of each team's _existing _project. We want them to have ownership when Chef infrastructure breaks and to take action on problems, just as if the problem happened in their own software build.

We then created a** Chef Cookbook** [build template](https://confluence.jetbrains.com/display/TCD9/Build+Configuration+Template) at the <Root Project> level that all cookbooks can use for their own builds. This template defines a cookbook parameter that enables the build steps below to know where the cookbook is in source.

## Version Control Settings

We're not really sure about how we approach testing at the moment when it comes to dependencies. If a cookbook is very young or if we are testing a lot of things at once, we might want to use relative path dependencies to other cookbooks. Or we might want to use data bags at some level. So we've decided on the build agent itself to mimic a chef repo and then test it that way. We do this [through a checkout rule](https://confluence.jetbrains.com/display/TCD9/Build+Checkout+Directory#BuildCheckoutDirectory-Customcheckoutdirectory), like this:

<pre>+:.=&gt;cookbooks/contributors

</pre>

This means that the contributors cookbook will go to the cookbooks/contributors repo relative to build working directory.

## Build Steps

### **1. Run Foodcritic**

We want to do Chef liniting first before we get into further testing, so we run [foodcritic](http://www.foodcritic.io/). This is done simply by creating a [Command Line runner](https://confluence.jetbrains.com/display/TCD9/Command+Line) with the foodcritic command:

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1.png" rel="attachment wp-att-1155"><img class="aligncenter wp-image-1157 size-full" src="http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1.png" alt="" width="875" height="661" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1.png 875w, http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1-300x227.png 300w, http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1-768x580.png 768w" sizes="(max-width: 875px) 100vw, 875px" /></a>

### **2. Run Rubocop**

Once foodcritic runs, we want to finish our cookbook linting with [rubocop](http://batsov.com/rubocop/):

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-foodcritic-1.png" rel="attachment wp-att-1157"><br /> </a> <a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-rubocop.png" rel="attachment wp-att-1158"><img class="aligncenter wp-image-1158 size-full" src="http://hedge-ops.com/wp-content/uploads/2016/03/run-rubocop.png" alt="run-rubocop" width="872" height="419" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/run-rubocop.png 872w, http://hedge-ops.com/wp-content/uploads/2016/03/run-rubocop-300x144.png 300w, http://hedge-ops.com/wp-content/uploads/2016/03/run-rubocop-768x369.png 768w" sizes="(max-width: 872px) 100vw, 872px" /></a>

### **3. Run Cookbook Unit Tests**

I'm not a huge fan of [ChefSpec](https://docs.chef.io/chefspec.html) because I believe they mock too much out and end up not adding a lot of value. But I do think having at least one there that ensures that your code will converge is immensely helpful. It's much better waiting the few seconds to ensure that code converges than the few minutes to wait for kitchen to tell you the same thing. So I put the step here:

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-chef-unit-tests.png" rel="attachment wp-att-1159"><img class="aligncenter size-full wp-image-1159" src="http://hedge-ops.com/wp-content/uploads/2016/03/run-chef-unit-tests.png" alt="run-chef-unit-tests" width="875" height="635" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/run-chef-unit-tests.png 875w, http://hedge-ops.com/wp-content/uploads/2016/03/run-chef-unit-tests-300x218.png 300w, http://hedge-ops.com/wp-content/uploads/2016/03/run-chef-unit-tests-768x557.png 768w" sizes="(max-width: 875px) 100vw, 875px" /></a>

_Update: actually just before this published, I removed this. The Chef Spec unit tests required too much ruby expertise to be helpful. Plus people are working well with kitchen and learn to rely on it instead. So as of yesterday, this step was removed._

### **4.** **Run Test Kitchen**

And now for the magic! I need to [run Test Kitchen](http://hedge-ops.com/test-kitchen-required-not-optional/). If I'm using vagrant, I need to have a physical build agent to do this on. [If I'm running azure](http://hedge-ops.com/tutorial-for-test-kitchen-with-azure/), I need to have some credentials set up on the build agent. All of that configuration is handled through chef itself, so at this point all I need to do is run the command itself:

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-test.png" rel="attachment wp-att-1160"><img class="aligncenter size-full wp-image-1160" src="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-test.png" alt="run-kitchen-test" width="878" height="666" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-test.png 878w, http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-test-300x228.png 300w, http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-test-768x583.png 768w" sizes="(max-width: 878px) 100vw, 878px" /></a>

Kitchen test will do a create, converge, and verify. It runs through the whole process. And I've tested that if it fails, the build will fail.

### **5. Kitchen Destroy**

If the above test fails, it's important to not keep the virtual machine running. This is especially true if I'm using the azure runner. So at the end I'll call kitchen destroy, and _always _call it, even if the previous command failed:

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-destroy.png" rel="attachment wp-att-1161"><img class="aligncenter size-full wp-image-1161" src="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-destroy.png" alt="run-kitchen-destroy" width="878" height="621" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-destroy.png 878w, http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-destroy-300x212.png 300w, http://hedge-ops.com/wp-content/uploads/2016/03/run-kitchen-destroy-768x543.png 768w" sizes="(max-width: 878px) 100vw, 878px" /></a>

## Build Agent Setup

As I mentioned earlier, our build agents are set up through Chef itself, so configuration of them is easy. Since we are creating our Chef Projects inside of the product's projects, we don't want to mix their build agents with the chef ones. We keep them separated because we let each team have their own build agents that they manage. To solve for the mix, we add the** Chef** subproject set up above to our own Chef build [agent pool](https://confluence.jetbrains.com/display/TCD9/Agent+Pools). Then in our template, we add a [build agent requirement](https://confluence.jetbrains.com/display/TCD9/Agent+Requirements):

<a href="http://hedge-ops.com/wp-content/uploads/2016/03/chef-cookbook-requirement.png" rel="attachment wp-att-1162"><img class="aligncenter size-full wp-image-1162" src="http://hedge-ops.com/wp-content/uploads/2016/03/chef-cookbook-requirement.png" alt="chef-cookbook-requirement" width="508" height="190" srcset="http://hedge-ops.com/wp-content/uploads/2016/03/chef-cookbook-requirement.png 508w, http://hedge-ops.com/wp-content/uploads/2016/03/chef-cookbook-requirement-300x112.png 300w" sizes="(max-width: 508px) 100vw, 508px" /></a>

In our recipe for the build agent, we set this environment variable, so this limits our cookbook builds to only run on build agents on which our chef recipe has run.

## Triggering

Finally, we want to trigger this cookbook build whenever something in the cookbook is checked in. We do this through adding a [VCS trigger](https://confluence.jetbrains.com/display/TCD9/Configuring+VCS+Triggers) with the default settings to the template.

## Conclusion

With the template in place, it takes about ten minutes to add a team's cookbook to be fully tested and built within their own environment. It feels very much like a software build, which is fantastic for everyone because it reminds us that the infrastructure code we are creating is like any other code; it should be subject to automation just like the rest.