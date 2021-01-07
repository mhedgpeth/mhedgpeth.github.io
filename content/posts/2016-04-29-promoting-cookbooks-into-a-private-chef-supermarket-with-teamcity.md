---
title: Promoting Cookbooks into a Private Chef Supermarket with TeamCity
date: 2016-04-29T08:01:34+00:00
tags:
  - automation
  - chef
  - teamcity
author: Michael
slug: promoting-cookbooks-into-a-private-chef-supermarket-with-teamcity
---
<div class="full-width">
  <img src="/images/feature-promoting-cookbooks-into-a-private-chef-supermarket-with-teamcity.jpg" alt="Promoting Cookbooks" />
</div>

[We want the ability to control](http://hedge-ops.com/my-advice-for-chef-in-large-corporations/) which versions of which cookbooks we rely on and that those cookbooks are available to us even if the author removes them from GitHub. In fact with [the recent craziness on dependency management](http://www.theverge.com/2016/3/24/11300840/how-an-irate-developer-briefly-broke-javascript) and after listening to [an episode on availability on Arrested DevOps,](https://www.arresteddevops.com/availability/) I'm starting to think that this isn't just for large organizations like mine.

So to protect ourselves from that kind of craziness, we have created a [private chef supermarket](https://www.chef.io/blog/2015/12/31/a-supermarket-of-your-own-running-a-private-supermarket/) that we host all dependencies on. Then in our policyfiles, we specify that private supermarket as our default source for finding cookbooks.

At first, to get us started, we manually uploaded the cookbooks we needed and got to working. Then as we scaled we got tired of people asking us to upload another version. On top of that we want to have a good, clean process for approving external cookbooks/code into our blessed environment. Here's how we implemented it:

## 1: Synchronize GitHub with internal Git server

We have an internal, corporately blessed git server we use, so we needed to get what was in GitHub into that Git server. For each of the cookbooks, we create a TeamCity [build configuration](https://confluence.jetbrains.com/display/TCD9/Build+Configuration) (that's based on a [template](https://confluence.jetbrains.com/display/TCD9/Build+Configuration+Template)) that does just this with a simple [Command Line runner](https://confluence.jetbrains.com/display/TCD9/Command+Line) (that runs in Windows only at the moment):

<pre class="lang:default decode:true ">mkdir %Repository Name%.git
git clone --mirror %Github Clone URL%
cd %Repository Name%.git
git remote add stash %Stash Clone URL%
git push --all stash
git push --tags stash</pre>

There are three variables that are [defined as parameters](https://confluence.jetbrains.com/display/TCD9/Configuring+Build+Parameters) here:

  1. Repository Name: the name of the git repository, like <span class="lang:default decode:true crayon-inline ">chef-client</span>
  2. Github Clone URL: the URL to clone the git on GitHub, like <span class="lang:default decode:true crayon-inline ">https://github.com/chef-cookbooks/chef-client</span>
  3. Stash URL: the URL to push the code to internally

I had to go into our internal Git server and create a repo with the same name as the GitHub one so something could be pushed.

I then [schedule this to run every day](https://confluence.jetbrains.com/display/TCD9/Configuring+Build+Triggers), and let it do its thing. If I got crazy I could make it run everytime there was a checkin on github, but the model doesn't _have_ to have immediacy to it. My repository internally will be reasonably up to date.

## 2: Create an internally approved branch based on a tag

The next thing we do is create a new branch on our internal git server that outlines what we have code reviewed and have approved to be a part of our infrastructure. During the first setup, we first clone the repo on our local machine with the internal git server:

<pre class="lang:default decode:true ">git clone http://mycompanygitserver.com/chef-client.git</pre>

Then we simply run these commands:

<pre class="lang:default decode:true ">git checkout -b mycompany-approved v4.3.2
git push origin mycompany-approved</pre>

This creates our "safe" branch, from which our promotion can occur.

## 3: Run cookbook build just as with other cookbooks

The cookbook build will run as I outlined in [a different post](http://hedge-ops.com/chef-cookbook-builds-in-teamcity/). The only difference is the VCS Root that I pull will be off of the <span class="lang:default decode:true crayon-inline ">mycompany-approved</span>  branch created above.

## 4: Promote cookbook to supermarket

Then I promote a cookbook to the supermarket using a TeamCity template that I use for all cookbook promotions, which is basically this command:

<pre class="lang:default decode:true ">knife supermarket share %cookbook_name% "Other" -o .</pre>

I had to ensure that the <span class="lang:default decode:true crayon-inline ">knife-supermarket</span>  gem was installed on my build server (of course, configured by chef as well). Also I parameterized the cookbook name so this could be inside of a template that can be reused everywhere.

The cookbook also has a [snapshot dependency](https://confluence.jetbrains.com/display/TCD9/Snapshot+Dependencies) to the cookbook build above, ensuring that it is only released to our supermarket when it passes the build. That keeps everyone honest.

## 5: Merge into approved branch as people request

People will still request that we merge into the approved branch, which is locked down so that a smaller team can approve of the changes. We can use a pull request model to review and audit how this happens.

## Conclusion

Doing it this way gave us the most control over which changes go into our infrastructure. It avoids the public supermarket alltogether, because we found that the packages posted on that server cannot be pushed to another supermarket. Even if that problem were fixed, this way is superior because it gives us the ability to code review and audit every dependency we have going into our system.