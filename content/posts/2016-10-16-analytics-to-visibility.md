---
layout: post
title: "Migrating from Chef Analytics to Chef Visibility"
date: 2016-10-16T08:00:00+00:00
tags: chef
author: Michael
slug: analytics-to-visibility
---
<div class="full-width">
  <img src="/images/feature-analytics-to-visibility.jpg" alt="Analytics to Visibility" />
</div>

The other day I was at lunch with my customer architect at Chef. We were talking about our situation. Our reference architecture fits Chef's reference architecture from about a year ago, which consists of a Chef Server and an Analytics Server as the core solution. Change takes a while, so I had been delaying setting up a Chef Automate environment before I got some other things accomplished. 

However, at lunch we both were convinced that a [Chef Visibility node](https://docs.chef.io/visibility.html) could easily replace a Chef Analytics node and set our teams up better for where Chef is going. We would set the server up in a POC mode which would mean we had no real backup plan, but that's OK because we are not really using Chef Analytics in a useful way.

This strategy is pretty typical of one I've used lately: **let people see what you're talking about and interact with it, even if it's not in the "perfect final state"**. Then, with experience as a guide, take the next step to do it the "right" way. We will likely end up with a central Visibility server but I don't want to risk everything just to make that happen. So we set this up instead and move things forward.

After the discussion with my customer architect, [Thomas Cate](https://www.linkedin.com/in/thomas-cate-9b63a28) helped me come up with this guide. I wrote everything down and thought it might be good to share with the community, in case anyone else was thinking of going this way.

# Migration Steps

This will migrate an existing Chef Analytics Server to a Chef Visibility Server in POC mode.

## Back up your keys on the analytics server

We're getting ready to uninstall Analytics, but we want to keep the keys because we'll use them later.

* Find the key location in `/etc/opscode-analytics/opscode-analytics.rb`. The keys will likely be located in `/etc/pki/tls/certs` and `/etc/pki/tls/private`
* Back up the keys to `~/cert-backup`

## Clean and uninstall Chef Analytics

Let's get rid of analytics now:

* Run `opscode-analytics-ctl cleanse`
* Run `opscode-analytics-ctl stop`
* Remove the package `yum remove opscode-analytics`
* Run `sudo rm -rf /opt/opscode-analytics`
* Reboot server `sudo reboot now`

## Remove Analytics from the Chef Server

On the Chef Server,
* open `/etc/opscode/chef-server.rb` and comment out ocid for analytics
* run `chef-server-ctl reconfigure`

## Install Automate

* Navigate to the [downloads page](https://downloads.chef.io/automate/) and copy the appropriate link
* On the Analytics Server, wget that link to download it to the user home, for example: `wget https://packages.chef.io/stable/el/7/delivery-0.5.370-1.el7.x86_64.rpm` for my CentOS box
* Install the package, on CentOS: `sudo rpm -Uvh delivery-0.5.370-1.el6.x86_64.rpm`. When it asks you to configure the Delivery Server, say no

## Set up Licensing

You'll need to get a `delivery.license` from a friend at Chef. You also get your pem key for your Chef Server as a one-time use to authenticate to it and add workflow stuff. I'm not using that, so this was not really needed, but you know, we do it anyways.

* Run `sudo delivery-ctl setup --license ~/delivery.license --key ~/[your-name].pem --server-url https://[your-chef-server]/organizations/[your-org] --fqdn analytics.[your-domain].com`
* When it asks for an organization, use your company name. The organization can be the same for different visibility servers. In fact, one can argue in this situation it's quite useless; it's more for multitenancy.

You should probably copy the `server-url` from your `knife.rb` file.

## Finalize installation

* run `sudo delivery-ctl reconfigure`
* check that the settings in `/etc/delivery/delivery.rb` are good (especially the FQDN)

## Set up certificates

Now it's time to reuse your certificates that you backed up earlier.

* Put the ssl certs in place `/var/opt/delivery/nginx/ca` - **Important:** these files need to same name as what is there by default. So you should copy by name and change the file name of what you had before.
* Restart nginx `sudo delivery-ctl restart nginx`
* Make sure it's working with `delivery-ctl status`

## Set up an Admin User

* Run `delivery-ctl create-enterprise [enterprise] --ssh-pub-key-file=/etc/delivery/builder_key.pub`

This will generate user information that will be output to your command line:

```
Created enterprise: companyname
Admin username: admin
Admin password: blahblahblah
Builder Password: blahblahblah-2
Web login: https://analytics.mycompany.com/e/companyname/
```

Navigate to that web login and you should see the automate login. Login with "admin" and the password it gives you.

## Set up more users

At this point you can change the admin password to something you can remember and add users. This has to be separate from the Chef Server because there are many Chef Servers to one Visibility Server. Well, not in this case, but that's the design.

So you have two options:

1. Set up a bunch of users manually
2. Set up LDAP authentication following [these directions](https://docs.chef.io/integrate_delivery_ldap.html)

## Configure Data Collector on Chef Visibility server

Now I'm going to set up a token for configuring a data collector for my clients to talk to the Chef Visiblity server:

* Create a Guid (on PowerShell I ran: `[guid]::NewGuid()`)
* Add data collector configuration to `/etc/delivery/delivery.rb`: 
  `data_collector['token'] = 'my-guid-here'`
* Run `sudo delivery-ctl reconfigure`

## Configure Chef Server to report to Visibility

You'll also need [the Chef Server to report to Visibility](https://docs.chef.io/setup_visibility_chef_automate.html#configure-chef-server-to-send-server-object-data). To do this:

* Add the following settings to `/etc/opscode/chef-server.rb`:

```ruby
data_collector['root_url'] = 'https://my-automate-server.mycompany.com/data-collector/v0/'
data_collector['token'] = 'TOKEN'
```

## Configure Chef Client to report to Visiblity

You'll need to make sure your Chef-Client is on a fairly recent version. For me I need to update chef-client in my infrastructure to 12.15.19 for this to work properly. I had some problems on an earlier version.

Now that we're on the latest, let's configure the `data_collector` on the node in the `client.rb`:

```ruby
data_collector.server_url "https://analytics.yourcompany.ncr/data-collector/v0/"
data_collector.token "guid-from-previous-step"
```

## Configure Notification replacement for Analytics

We were taking advantage of the notifications in Chef Analytics and needed a replacement. My colleague has written [a slack notifier report handler](https://github.com/jkerry/SimpleSlackHandler) for Chef that we're now using.

# Initial Thoughts on Visibility

First of all, I'm really impressed with the Chef team for thinking out of the box and getting me on their new platform in a way that works for me. This underscores once again why they're a great partner: **Chef doesn't show up with an inflexible agenda; they listen, find the *right* solution, and then execute.**

My first impressions of the product are that it looks very nice and clean. I can tell Chef has hired some UX people. :) 

Visibility definitely has room to grow but it's an exciting start to a great platform for making Chef operable at scale within the enterprise. While some in the open source community might elect to roll their own reporting platform for Chef-related stuff, to us that's the path pain and discomfort, because we realize that we'll never have the funding that Chef has to deliver this. And they like hearing from people like me give them feedback. So to me that's the best of both worlds.

I don't like how the Visibility product is tied to workflow, though. I can understand how Chef wants to sell an all-in-one solution, but to me it's better to design your products with as little coupling as possible so they can be independent. From their perspective, it may make sense; keep things simple so your support can be focused in one direction.

I'm really glad I converted my Chef Analytics server to a Visibility server. Hopefully this helps you do the same.