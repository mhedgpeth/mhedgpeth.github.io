---
id: 1111
title: Tutorial for Test Kitchen with Azure
date: 2016-03-04T08:00:20+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=1111
permalink: /tutorial-for-test-kitchen-with-azure/
snap_isAutoPosted:
  - 1
dsq_thread_id:
  - 4633727194
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:214:"a:1:{i:0;a:8:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:289:"a:1:{i:0;a:9:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:11:"isPrePosted";s:1:"1";}}";'
snapTW:
  - 's:344:"a:1:{i:0;a:9:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:88:"Thanks to @StuartPreston I finally got @kitchenci working with @chef and @Azure - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"705758543949930498";s:5:"pDate";s:19:"2016-03-04 14:15:24";}}";'
categories:
  - insights
tags:
  - azure
  - chef
  - test kitchen
---
As I wrote in <a href="http://hedge-ops.com/test-kitchen-required-not-optional/ ‎" target="_blank">the last post</a>, Test Kitchen as one of the <a href="http://hedge-ops.com/learning-chef-book-review/" target="_blank">things that attracted me to Chef</a>. There was a problem, though: running Windows on virtual machines automatically is difficult.

I've spent quite a bit of time trying to create a vagrant image <a href="http://www.hurryupandwait.io/blog/creating-windows-base-images-for-virtualbox-and-hyper-v-using-packer-boxstarter-and-vagrant" target="_blank">using Matt Wrock's excellent blog</a> as a resource, and haven't quite gotten it there yet. Plus, if I go the vagrant route, people have to have powerful machines on which to run test kitchen. The more I worked through that option, the more I because discouraged and dismayed that this may just never work for us.

And then I discovered azure.<!--more-->

Don't get me wrong: I'm not a Microsoft fanboy. But there are some great advantages to going this route:

  1. Through my Microsoft-friendly workplace I get a MSDN Subscription, <a href="https://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits/" target="_blank">with which I get $50/month credit to use azure</a>. So this is free, and I can run test kitchen on not-my compute resources.
  2. Microsoft by definition is going to get Windows images right. So I don't have to fight it anymore. I can just use it. It just works, just like it should.
  3. <a href="http://stuartpreston.net/" target="_blank">Stuart Preston</a> wrote a plugin for me that gets anyone past the learning curve very quickly. With this plugin you don't have to really know anything about azure to use it for test kitchen

These reasons are so compelling, this is what our teams will be going with in the coming months. It's critical that everyone be able to run test kitchen easily, and azure gives us the best shot at doing that without a lot of drama.

Setting up was easy:

  1. <a href="http://blogs.msdn.com/b/msgulfcommunity/archive/2014/09/15/how-to-activate-azure-benefit-for-msdn-subscribers.aspx" target="_blank">Activate your subscription from your MSDN account</a>
  2. <a href="https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/" target="_blank">Install the Azure CLI for Windows</a>
  3. Follow the directions <a href="https://github.com/pendrica/kitchen-azurerm" target="_blank">on the kitchen-azurerm main page</a> to set up a Security Principal, Tenant, Password, and configure it in your user directory
  4. In a simple cookbook, create [a simple kitchen.yml file](https://gist.github.com/mhedgpeth/a70ef0a7edf01d9c7ed2) like this:

<pre>---
driver:
 name: azurerm

driver_config:
 subscription_id: &lt;%= ENV['AZURE_SUBSCRIPTION_ID'] %&gt;
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
 attributes:</pre>

It's really that simple. Now I can run test kitchen commands:

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default " border="0">
    <tr>
      <th >
        command
      </th>
      
      <th >
        description
      </th>
    </tr>
    
    <tr>
      <td >
        kitchen create
      </td>
      
      <td >
        creates azure infrastructure for running, powers on machines
      </td>
    </tr>
    
    <tr>
      <td >
        kitchen converge
      </td>
      
      <td >
        does kitchen create if needed, will converge the node using chef
      </td>
    </tr>
    
    <tr>
      <td >
        kitchen verify
      </td>
      
      <td >
        does create and converge if needed, runs the tests that you've written
      </td>
    </tr>
    
    <tr>
      <td >
        kitchen test
      </td>
      
      <td >
        does everything: create, converge, verify
      </td>
    </tr>
    
    <tr>
      <td >
        kitchen destroy
      </td>
      
      <td >
        don't forget this one; it removes the resources
      </td>
    </tr>
  </table>
</div>

There you have it, go through those easy steps and you have Kitchen working with Azure.