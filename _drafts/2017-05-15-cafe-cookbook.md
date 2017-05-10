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
With a [solid deployment pipeline](policyfile-deployment-with-cafe-and-psake) in place for running Chef that depends on [Cafe](/introducing-cafe/) for a safe, atomic, and controlled rollout of chef changes, it has become more important than ever to utilize cafe to manage itself and chef on a machine. The [`cafe` cookbook](https://github.com/mhedgpeth/cafe-cookbook) does just that.

The cafe cookbook makes it easy to ensure that cafe is installed and configured properly on a machine and will manage chef upgrades that happen outside of when chef runs.

It does this very easily by giving you access to three resources:

## `cafe_installed`

To install and configure cafe, you can use the `cafe_installed` resource, for example:

```ruby
cafe_installed '0.5.4-beta' do
  download_source 'https://github.com/mhedgpeth/cafe/releases/download/0.9.1-beta/cafe-win10-x64-0.9.1.0.zip'
  download_checksum '75707978E48B51EC9564D209A9B6CA8F4B563AC4B128C34614435899FAD787C7'
  version '0.5.4.0'
  installer 'cafe-win10-x64-0.9.1.0.zip'
  cafe_install_root 'D:'
  chef_interval 1800
  service_port 59320
end
```

See the [Cafe Releases](https://github.com/mhedgpeth/cafe/releases) page to get the `download_source`, `version`, and `installer` that you need to use. You'll have to calculate your own checksum at the moment. The last three are configuration elements of cafe itself; if you omit them, the resource will use sensible default values.

You should also notice that this resource is very friendly to air-gapped environments; you can use any URL you need to use here, as long as you get it downloaded and it matches the checksum.

If you are introducing cafe to existing chef nodes because you want to manage chef that way now, it will dutifully install cafe for the first time in `D:\chef` (based on your `cafe_install_root`). On an upgrade, `cafe` asks its `cafe Updater` service friend to update `cafe` for it, because services can't update themselves. This all happens after the chef run is finished, assuming that `cafe` is running chef.

## `cafe_chef_staged`

You'll also want to keep the chef application up to date and consistent on all of your nodes. You'll want to make sure you do this when chef is not running as well. Fortunately, `cafe` has you covered in this regard. The first thing you'll want to do is stage the chef installation with `cafe`:

```ruby
cafe_chef_staged 'chef-client staged for 13.0.118' do
  source 'https://packages.chef.io/files/stable/chef/13.0.118/windows/2012r2/chef-client-13.0.118-1-x64.msi'
  installer 'chef-client-13.0.118-1-x64.msi'
  checksum 'c594965648e20a2339d6f33d236b4e3e22b2be6916cceb1b0f338c74378c03da'
  cafe_install_location 'D:/cafe'
end
```

As with the scenario above, you can use any source you want from a private repository. This is the equivalent of running `cafe chef download 13.0.118` but gives you more control to download the file.

## `cafe_chef_installed`

Once you have staged the chef installation, it's time to say that you want it to be installed. You'll do this with the `cafe_chef_installed` resource:

```ruby
cafe_chef_installed 'chef-client 13.0.118' do
  version '13.0.118'
  cafe_install_location 'D:/cafe'
end
```
 
You can omit the `cafe_install_location` if it is in the default `C:/cafe` location.

It's important to understand what exactly is happening here, because this is at the genesis of why cafe exists. You would expect cafe to be *running* chef at this moment, so you don't want it to upgrade chef immediately. So here we're **not** upgrading chef, we're **requesting** that cafe upgrade chef after the chef client runs. The _desired state_ of the system is "I want cafe to make the chef client be on version 13.0.118". Cafe handles the rest!

So you don't need to worry about timing here. Cafe runs **all** of its jobs serially because it knows that you don't want things stepping on other things. So sleep peacefully! 

# Conclusion

I hope you're as excited as I am about the promise cafe brings to the Chef runtime. With cafe, you can still use chef to manage itself and cafe on an application, but you can trust that cafe will handle this management with grace and no drama. If you're interested in deploying or contributing to cafe, I'd love to hear from you about it. I think it addresses a critical need within the Chef ecosystem.
