---
id: 1111
layout: post
title: Tutorial for Test Kitchen with Azure
date: 2016-03-04T08:00:20+00:00
categories:
  - automation
  - chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-tutorial-for-test-kitchen-with-azure
show_related_posts: true 
guid: http://hedge-ops.com/?p=1111
permalink: /tutorial-for-test-kitchen-with-azure/
---
As I wrote in [the last post](/test-kitchen-required-not-optional/), Test Kitchen as one of the [things that attracted me to Chef](/learning-chef-book-review/). There was a problem, though: running Windows on virtual machines automatically is difficult.

I've spent quite a bit of time trying to create a vagrant image [using Matt Wrock's excellent blog](http://www.hurryupandwait.io/blog/creating-windows-base-images-for-virtualbox-and-hyper-v-using-packer-boxstarter-and-vagrant) as a resource, and haven't quite gotten it there yet. Plus, if I go the vagrant route, people have to have powerful machines on which to run test kitchen. The more I worked through that option, the more I because discouraged and dismayed that this may just never work for us.

And then I discovered azure.<!--more-->

Don't get me wrong: I'm not a Microsoft fanboy. But there are some great advantages to going this route:

  1. Through my Microsoft-friendly workplace I get a MSDN Subscription, [with which I get $50/month credit to use azure](https://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits/). So this is free, and I can run test kitchen on not-my compute resources.
  2. Microsoft by definition is going to get Windows images right. So I don't have to fight it anymore. I can just use it. It just works, just like it should.
  3. [Stuart Preston](http://stuartpreston.net/) wrote a plugin for me that gets anyone past the learning curve very quickly. With this plugin you don't have to really know anything about azure to use it for test kitchen

These reasons are so compelling, this is what our teams will be going with in the coming months. It's critical that everyone be able to run test kitchen easily, and azure gives us the best shot at doing that without a lot of drama.

Setting up was easy:

  1. [Activate your subscription from your MSDN account](http://blogs.msdn.com/b/msgulfcommunity/archive/2014/09/15/how-to-activate-azure-benefit-for-msdn-subscribers.aspx)
  2. [Install the Azure CLI for Windows](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/)
  3. Follow the directions [on the kitchen-azurerm main page](https://github.com/pendrica/kitchen-azurerm) to set up a Security Principal, Tenant, Password, and configure it in your user directory
  4. In a simple cookbook, create [a simple kitchen.yml file](https://gist.github.com/mhedgpeth/a70ef0a7edf01d9c7ed2) like this:

```yml
---
driver:
 name: azurerm

driver_config:
 subscription_id: <%= ENV['AZURE_SUBSCRIPTION_ID'] %>
 location: 'South Central US'
 machine_size: 'Standard_D1'

provisioner:
 name: chef_zero

verifier:
 name: inspec

platforms:
 - name: windows2012-r2
 driver_config:
 image_urn: MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:latest
 transport:
 name: winrm
 - name: centos71
 driver_config:
 image_urn: OpenLogic:CentOS:7.1:latest

suites:
 - name: default
 run_list:
 - recipe[contributors::default]
 attributes:
```

It's really that simple. Now I can run test kitchen commands:

<table>
  <tr>
    <th>
      command
    </th>
    <th>
      description
    </th>
  </tr>
  <tr>
    <td>
      kitchen create
    </td>
    <td>
      creates azure infrastructure for running, powers on machines
    </td>
  </tr>
  <tr>
    <td>
      kitchen converge
    </td>
    
    <td>
      does kitchen create if needed, will converge the node using chef
    </td>
  </tr>
  <tr>
    <td>
      kitchen verify
    </td>
    <td>
      does create and converge if needed, runs the tests that you've written
    </td>
  </tr>
  <tr>
    <td>
      kitchen test
    </td>
    <td>
      does everything: create, converge, verify
    </td>
  </tr>
  <tr>
    <td>
      kitchen destroy
    </td>
    <td>
      don't forget this one; it removes the resources
    </td>
  </tr>
</table>

There you have it, go through those easy steps and you have Kitchen working with Azure.