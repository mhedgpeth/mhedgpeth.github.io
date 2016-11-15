---
layout: post
title: "Policyfile Attributes"
date: 2016-11-14T08:00:00+00:00
categories: chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 20
feature_image: feature-policyfile-attributes
show_related_posts: true
square_related: related-policyfile-attributes
permalink: /policyfile-attributes/
---
When you start with [policyfiles](/policyfiles/) you quickly fall in love with the simplicity of the workflow and how easy it is to learn and teach. However, you're also faced with an apparent show-stopper to adoption: there are lots of community cookbooks out there that expect certain attributes to be in certain locations. It can be quite confusing; I'm sure it's kept a lot of people from adopting the feature. So let's get that one out of the way in this post.

We'll take the use cases from easiest to most difficult:

# Define Attributes within Policyfile

Many times you'll come across a community cookbook that expects attributes to be defined for it to properly run, like with the `apache` cookbook.

If the behavior of your cookbook doesn't change very often, you can declare those attributes in your `Policyfile.rb` if you want to:

```ruby
# in Policyfile.rb
default['apache2'] = {
    listen_ports: ['80', '443']
}
```

That will get you by for simple situations, but if you're dealing with a half a dozen or more policies that use this cookbook, this will get very repetitive, and therefore error prone. My rule is if you repeat yourself more than three times then [you need to do something about it](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

# Define Attributes within Wrapper Cookbook

In this case, I would create a wrapper cookbook called `mycompany-apache` and define the attributes there. Then I can use that recipe in my runlist for all of my policies.

```ruby
# in mycompany-apache/attributes/default.rb
default['apache2'] = {
    listen_ports: ['80', '443']
}
```

In fact, as a rule of thumb I generally try to keep attributes out of my policyfiles. It's great for smaller cases, and if you just have a few and are getting started, by all means do it, but it creates an unmaintainable mess if you have a lot of machines that need to run against the same attributes.

As time has gone on, I think of Policyfiles as defining *what* chef scripts should run on a node and something else to handle the configuration elements that those scripts need.

# Define Environment-specific Attributes in the Policyfile

With most if not all attributes now removed from my policyfiles, I come across a good reason to include them again: I need to have environment-specific settings that my cookbooks use. For example, let's say that I need to use `testdatabase` for my `qa` environment and `proddatabase` for my `production` environment.

You can do this pretty easily with Policyfiles:

```ruby
# in Policyfile.rb
default['qa']['myapplication']['database'] = 'testdatabase'
default['production']['myapplication']['database'] = 'productiondatabase'
```

Now in my recipe code I can simply write:

```ruby
# in recipes/default.rb
database = node[Chef::Config.policy_group]['myapplication']['database']
```

This is, frankly, how most of our applications work with Policyfiles. This has been good enough for us and therefore is what we went for. Since then, we've come across other use cases which cause us to go further:

# Define Environment-specfic Attributes in the Policyfile, Consume Them As Normal Attributes

One of the major drawbacks of the previous section is the need to change your code to deal with the `policy_group` within the hash to get to your value. This is fine if you're starting from scratch like I did, but that won't work for everyone. Thankfully [code ranger](https://coderanger.net/) and friends created the [poise-hoist](https://github.com/poise/poise-hoist) cookbook, which handles a lot of the translation for you.

In order to do this, just add `poise_hoist` to the `run_list` of your `Policyfile.rb`.

Then, assuming you have the structure from the previous section, you'll be able to get the database without using the `policy_group`:

```ruby
# in recipes/default.rb, now using poise_hoist
database = node['myapplication']['database']
```

If you were using environments before and that kept you from using Policyfiles, **you now no longer have any excuse.** Yes, that's right: **you can use Policyfiles without changing a line of code by using the `poise_hoist` cookbook!**

# Define Role-specific Attributes in the Policyfile, Consume Them As Normal Attributes

The same workflow we used above to migrate from environments can be used with our roles as well.

We should first understand that roles don't exist within policyfiles. To accomplish the same end, we use a wrapper cookbook that encapsulates everything we want that role to do.

For example you could have a base role that you want everything to follow by creating a `mycompany-platform` cookbook. Its default recipe could be something like this:

```ruby
# in mycompany-platform/recipes/default.rb
include_recipe 'logging_provider::default'
include_recipe 'chef-client::default'
```

In that same cookbook you could also define attributes that control your cookbooks:

```ruby
# in mycompany-platform/attributes/default.rb
default['chef-client']['interval'] = 3600
default['logging_provider']['url'] = 'http://insanely-expensive.io'
```

If you have some elements that change by environment, use the techniques above to do that: `poise-hoist` will merge those elements into the places that your recipes will expect to look. For example, for the above section of code, if you wanted to make it environment specific, you would write:

```ruby
# in Policyfile.rb
default['qa'] = {
  chef-client: {
      interval: 900
  }   
  logging_provider: {
      url: 'http://test-cheaply.io'
  }
}

default['production'] = {
    chef-client: {
        interval: 3600
    }
    logging_provider: {
        url: 'http://insanely-expensive.io'
    }
}
```

# Support Lots of Environments Across Lots of Policyfiles with Data Bags

The techniques outlined above work well for applications that have a minimal number of roles and environments. For example, we have one application with a web and application tier and three different environments. For that we have our attributes declared in the `application-webserver.rb` and `application-appserver.rb` policyfiles and then flow those policyfiles through our pipeline from `qa` to `uat` and finally to `production` policy groups.

This starts to fall apart when you need a lot of roles (or policyfiles) use environment-specific attributes. At first glance you might be tempted to create new policy groups, like:

```ruby
# probably not a good idea
default['qa'] = {
    my_application: {
        database: 'qaserver'
    }
 }
default['michael-performance'] = {
    my_application: {
        database: 'mhperdb'
    }
}
default['mary-testing'] = {
    my_application: {
        database: 'marydb'
    }
}
```

You'll encounter a huge problem right away in that you have to copy and maintain these complex structures across a lot of policyfiles. That's a recipe for something to go very wrong.

Instead, we will offload the attributes definitions here to [data bags](https://docs.chef.io/data_bags.html). So we'll have different data bags per environment:

```json
{
    "filename": "environment_michael-performance.json",
    "my_application": {
        "database": "mhperdb"
    }
}
```

In this example, we'll still keep `michael-performance` as the `policy_group` for the node, but we'll not define any of the attributes in the Policyfile, but instead define them in the `environment_michael-performance` data bag.

Before the application cookbook runs, we can merge what is in the data bag into our node attributes by borrowing what the [poise-hoist cookbook does](https://github.com/poise/poise-hoist/blob/master/lib/poise_hoist.rb#L38):

```ruby
# I haven't run this but hopefully you get the idea
environment = data_bag_item('myapplication', "environment-#{Chef::Config.policy_group}")
Chef::Mixin::DeepMerge.hash_only_merge!(node.role_default, environment)
```

This will, as before, make it so you can have Policyfiles and largely the same code as before because you were able to bring the environment data in from another source and merge it.

# Multi-Dimensional Attributes with Data Bags and Policyfiles

We have a couple of products that take this even further. You might have two dimensions of settings: in America, you one service and in Europe you use another. This is true for all environments, but the environments have their own distinct settings.

In this situation you can create two different types of data bags: `environment-uat` but also a `american-services` and `european-services`. Then you could have nodes know which environment they're in and load the appropriate settings.

You would have a couple of data bags:

```json
{
    "filename": "american-services",
    "weather": "american-weather-services.com"
}
{
    "filename": "european-services",
    "weather": "letempsenfrance.fr"    
}
```

Then you can merge that in as normal, based on timezone, or whichever element fits your situation:ß

```ruby
service = Time.now().gmt_offset < 0 ? 'american' : 'european'
service_settings = data_bag_item('my_application', "#{service}-services")
Chef::Mixin::DeepMerge.hash_only_merge!(node.role_default, service_settings)
```

The long term solution for much of this is to define it within Consul. But that requires learning and adopting another thing, which in my opinion slows you down. Get what you need to get done here, and then adopt other things that work for you one step at a time.

# Policyfile Nirvana - Infrastructure Versions Decoupled from Scripts

When we start with policyfiles, as with the first few use cases above, we tend to put a lot of information in the policyfiles themselves. As things get more complicated, we start to shy away from that because it creates maintainability problems. I've grown in my usage of policyfiles to think of **policyfiles as a mechanism for getting the right versions of the chef recipes on the node to simply run them.** That's where they really shine; they're an excellent dependency management/workflow simplification feature. They're NOT going to shine for the other things.

So when I have a version of a website change and therefore need for my scripts to change the file they're using to load that website onto a webserver, I shouldn't use the policyfile for that. Instead I can use the *same* policyfile (or version of scripts) to download and install a *new* version of my website.

In this case, I've probably moved to the data bags based definition of what that website is:

```json
{
    "filename": "environment-qa.json",
    "website": {
        "version": "1.0.2"
    }
}
```

If I'm going to upgrade that database, I probably want to just upgrade the data bag. The script remains the same.

This, to me, is a nirvana situation. I'm running stable scripts/recipes in all environments and am changing small elements of how they run to respect what environment they're in. I've avoided duplication and therefore increased operatability of the solution.

So, take a lesson from me, if you're dealing with a complex system with a lot of node types, decouple your application version from the scripts that are running. Your CI/CD pipeline will simplify and it will be simpler to know what changed, why, and how it affects your situation.

# Conclusion

If you follow the techniques outlined above, you'll have no issue with migrating to Policyfiles. You'll need to make sure that there is a solid business case for it. I think you'll find that the return from better change management and easier operatability will more than pay for the costs you'll incur from using the techniques above.

