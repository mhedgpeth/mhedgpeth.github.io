---
layout: post
title: "Cafe Cookbook"
date: 2017-05-15T00:00:00+00:00
categories:
  - cafe
  - chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-cafe-cookbook
show_related_posts: true
square_related: related-cafe-cookbook
permalink: /cafe-cookbook/
---
With a [solid deployment pipeline](policyfile-deployment-with-cafe-and-psake) in place for running Chef that depends on [Cafe](/introducing-cafe/) for a safe, atomic, and controlled rollout of Chef [policy](/policyfiles/) changes, it has become more important than ever to utilize [cafe](/introducing-cafe/) to manage itself and Chef on a machine. The [`cafe` cookbook](https://github.com/mhedgpeth/cafe-cookbook) does just that.

The cafe cookbook makes it easy to ensure that Cafe is installed and configured properly on a machine and will manage Chef upgrades that happen outside of when Chef runs.

It does this very easily by giving you access to two resources:

## `cafe` resource

To install and configure Cafe, you should use the `cafe` resource, for example:

```ruby
cafe 'cafe' do
  download_source 'https://github.com/mhedgpeth/cafe/releases/download/0.9.2-beta/cafe-win10-x64-0.9.2.0.zip'
  download_checksum '75707978E48B51EC9564D209A9B6CA8F4B563AC4B128C34614435899FAD787C7'
  version '0.9.2.0'
  installer 'cafe-win10-x64-0.9.2.0.zip'
  cafe_install_root 'D:'
  chef_interval 1800
  service_port 59320
end
```

See the [Cafe Releases](https://github.com/mhedgpeth/cafe/releases) page to get the `download_source`, `version`, and `installer` that you need to use. You'll have to calculate your own checksum at the moment. The last three properties are configuration elements of Cafe itself; if you omit them, the resource will use sensible default values.

You should also notice that this resource is very friendly to air-gapped environments; you can use any URL you need to use here, as long as you get it downloaded and it matches the checksum. We use [artifactory](https://www.jfrog.com/artifactory/) for our artifacts and love it.

If you are introducing Cafe to existing Chef nodes because you want to manage Chef that way now, and your `cafe_install_root` is set to `D:`, it will dutifully install Cafe for the first time in `D:\chef`. On an upgrade, the `cafe` service asks its `cafe Updater` service friend to update `cafe` for it, because services can't update themselves. This all happens after the Chef run is finished, assuming that Cafe is running Chef.

## `cafe_chef`

You'll also want to keep the `chef-client` application up to date and consistent on all of your nodes. You'll want to make sure you do this when Chef is not running as well. Fortunately, Cafe has you covered in this regard. Simply declare what you want Chef to look like on the machine, and Cafe handles the rest:

```ruby
cafe_chef 'chef-client' do
  download_source 'https://packages.chef.io/files/stable/chef/13.0.118/windows/2012r2/chef-client-13.0.118-1-x64.msi'
  installer 'chef-client-13.0.118-1-x64.msi'
  download_checksum 'c594965648e20a2339d6f33d236b4e3e22b2be6916cceb1b0f338c74378c03da'
  version '13.0.118'
  cafe_install_root 'D:'
end
```

As with the scenario above, you can use any source you want from a private repository like artifactory. This is the equivalent of running `cafe chef download 13.0.118` and then `cafe install chef 13.0.118` but gives you more control to download the file.
 
Also, you can omit the `cafe_install_root` if you want to install everything on `C:`.

It's important to understand what exactly is happening here, because this is at the genesis of why Cafe exists. You would expect Cafe to be *running* Chef at this moment, so you don't want it to upgrade Chef immediately. So here we're **not** upgrading Chef, we're **requesting** that Cafe upgrade Chef after the Chef client runs. The _desired state_ of the system is "I want Cafe to make the Chef client be on version 13.0.118". Cafe handles the rest!

So you don't need to worry about timing here. Cafe runs **all** of its jobs sequentially because it knows that you don't want things stepping on other things. So sleep peacefully, my friend!

# Conclusion

I hope you're as excited as I am about the promise Cafe brings to the Chef runtime. With Cafe, you can still use Chef to manage itself and Cafe on an application, but you can trust that Cafe will handle this management with grace and no drama. If you're interested in deploying or contributing to Cafe, I'd love to hear from you about it. I think it addresses a critical need within the Chef ecosystem.
