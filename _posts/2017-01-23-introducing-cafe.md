---
layout: post
title: "Introducing Cafe"
date: 2017-01-23T00:00:00+00:00
categories: cafe
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-introducing-cafe
show_related_posts: true
square_related: related-introducing-cafe
permalink: /introducing-cafe/
---
I was fortuntate enough to be at Chef Summit in Seattle last November and learned two very valuable things there: First, I learned that the core power of Chef is in its community and ecosystem. Within this ecosystem we can depart from the user customer/vendor relationship where you're at the mercy of a product team and may or may not have enough sway to get your stuff done. Instead you can work with the community to contribute your own stuff. This inspired me to be a contributor instead of just a taker.

The second thing I learned was that the Microsoft ecosystem was alive and well, but had a really hard time getting Chef to run in a consistent way on Windows. So I decided to do something about that over my holidays and a few long nights, and have come up with a new project I'm introducing today: [cafe](https://github.com/mhedgpeth/cafe).

Cafe exists to make running Chef in a windows environment easier. It takes my over two years of experience with Chef on Windows and simplifies and streamlines how I think it should go. And fortunately, I'm able to rely on my software development background to create a product that will feel like a easy to use, real product to people.

So if you're still reading, and I hope you are, let's go through a demo real quick, or if you're more visual [watch my demo on YouTube](https://www.youtube.com/watch?v=QxHi01vBkiw).

# Installation

Cafe is a standalone program that is fully operational by unzipping files into a folder and running `cafe.exe`. No ruby or .NET dependencies. It just works.

To install:

1. Unzip the installation package into a folder
2. Run `cafe init` if you want it added to the path (you'll need to reboot)
3. Run `cafe service register` to have the cafe server run in the background so it can do things for you

# Runtime

Cafe is lightweight. To run the service it takes around 20MB of memory and no CPU. This means that you can put cafe on all your nodes, then install and run chef as you want to.

# Walkthrough

After installation, let's work on getting chef bootstrapped on the machine. 

The first step is to download and install [inspec](http://inspec.io/):

```
cafe inspec download 1.7.1
```

Once the inspec installer is downloaded, let's install it:

```
cafe inspec install 1.7.1
```

Next we will do the same with the [Chef Client](https://docs.chef.io/ctl_chef_client.html):

```
cafe chef download 12.16.42
```

And then install it:

```
cafe chef install 12.16.42
```

Now that we've installed Chef, let's bootstrap it. You can do this two ways:

1. [The Policyfile](http://hedge-ops.com/policyfiles/) way:

```
cafe chef bootstrap policy: webserver group: qa config: C:\Users\mhedg\client.rb validator: C:\Users\mhedg\my-validator.pem
```

2. The Run List Way:

```
cafe chef bootstrap run-list: "[chocolatey::default]" config: C:\Users\mhedg\client.rb validator: C:\Users\mhedg\my-validator.pem
```

Both ways ask for a config file that will be your `client.rb` on the machine and a validator used to ask the chef server for validation.

Now that we've bootstrapped Chef, we can run it again on demand if we want to:

```
cafe chef run
```

We can even look at the `logs` directory and see that we have a rolling log that only has our chef-client runs in it. We can also see specific logging for our client and server.

We probably want to schedule Chef to run every 30 minutes or so. To do this we edit our `server.json`:

```json
{
    "ChefInterval": 1800,
    "Port": 59320
}
```

And restart the cafe service:

```
cafe service restart
```

At some point you may even want to pause chef on the node so you can manually check a node's state without fear of Chef changing anything. To do this, run:

```
cafe chef pause
```

And then when you're ready to rejoin the land of sanity, you can simply run:

```
cafe chef resume
```

# Conclusion

If you've spent any time getting chef to run on a Windows infrastructure, you should be pretty excited right now. If that's you, please try it out and let me know how it's going for you. I'd like to get a community around cafe to become the standard for how we manage Chef in a windows environment.