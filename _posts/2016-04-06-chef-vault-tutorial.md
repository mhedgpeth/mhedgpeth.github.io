---
id: 1181
title: chef-vault Tutorial
date: 2016-04-06T00:00:32+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=1181
permalink: /chef-vault-tutorial/
dsq_thread_id:
  - 4724864294
snap_isAutoPosted:
  - 1
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:231:"a:1:{i:0;a:9:{s:4:"doFB";i:0;s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:2:"do";s:1:"1";}}";'
snapLI:
  - 's:308:"a:1:{i:0;a:10:{s:4:"doLI";s:1:"1";s:8:"postType";s:1:"A";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:12:"liMsgFormatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";s:2:"do";s:1:"1";s:11:"isPrePosted";s:1:"1";}}";'
snapTW:
  - 's:336:"a:1:{i:0;a:10:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:62:"An up to date tutorial on using chef-vault with @chef - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:2:"do";s:1:"1";s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"717813294635986944";s:5:"pDate";s:19:"2016-04-06 20:36:40";}}";'
categories:
  - tools
tags:
  - chef
  - chef-vault
  - encrypted data bags
  - hashicorp
  - vault
---
This week I researched <a href="https://github.com/chef/chef-vault" target="_blank">chef-vault</a> and struggled quite a bit <a href="https://docs.chef.io/chef_vault.html" target="_blank">with the documentation</a>, so I thought I would write a bit of a tutorial on the technology for those who are interested in quickly understanding how it might work for their organizations.

## Why chef-vault?

<a href="https://docs.chef.io/data_bags.html#encrypt-a-data-bag-item" target="_blank">Encrypted data bags</a> force you to copy the shared secret that is used for decryption to your infrastructure. It's very easy to take that secret file and nefariously decrypt the data from somewhere else without anyone knowing about it. Chef-vault makes this much more difficult by giving both nodes and chef server users expressed permission to decrypt certain data. With chef-vault you don't have to share a secret file with all of your nodes. This is a step up that simplifies everything.

The solution isn't without its drawbacks. The main one is if you add nodes, you have to rerun something on the server to get that node to be able to decrypt the data bag. With <a href="https://www.hashicorp.com/blog/vault.html" target="_blank">Hashicorp's vault</a> you get better control over that, and better lease management, and credentials creation. To me, encrypted data bags are an unreliable used car, chef-vault is a nice mid-size sedan, and Hashicorp's vault is like a luxury car.

So now that we know where the tool sits within our choices, let's look at the basics:<!--more-->

## Setup

To get started with chef-vault, have the latest <a href="https://downloads.chef.io/chef-dk/" target="_blank">ChefDK</a> installed (0.12 or greater) and install the <a href="https://rubygems.org/gems/chef-vault/versions/2.8.0" target="_blank">chef-vault gem</a>:

<pre class="lang:default highlight:0 decode:true ">chef gem install chef-vault</pre>

And then ensure you have a .chef directory that connects to a chef server.

## Creation

Creating a vault is easy:

<pre class="lang:default highlight:0 decode:true">knife vault create passwords root -S "policy_name:webserver" -A "michael" -J root.json -M client
</pre>

For whatever reason the <span class="lang:default highlight:0 decode:true crayon-inline ">knife vault</span>  command doesn't default to talk to a chef server. So to create a knife vault, you have to specify <span class="lang:default highlight:0 decode:true crayon-inline">-M client</span>  at the end. Or you can make your life easier going forward by adding this line to your knife.rb:

<pre class="lang:default decode:true ">knife[:vault_mode] = 'client'</pre>

For the command, I used this root.json:
  
``

<pre class="lang:js decode:true">{
"username": "mhedgpeth",
"password": "myPassword"
}
</pre>

Let's review the options:

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default " border="0">
    <tr>
      <th >
        Flag
      </th>
      
      <th >
        Value
      </th>
      
      <th >
        Description
      </th>
    </tr>
    
    <tr>
      <td >
      </td>
      
      <td >
        passwords
      </td>
      
      <td >
        the data bag the vault should be a part of, which will be created if it does not yet exist
      </td>
    </tr>
    
    <tr>
      <td >
      </td>
      
      <td >
        root
      </td>
      
      <td >
        the name of the item to save under the data bag
      </td>
    </tr>
    
    <tr>
      <td >
        -S
      </td>
      
      <td >
        policyname:webserver
      </td>
      
      <td >
        the search criteria for the nodes that can use this vault. If it works with <span class="lang:default highlight:0 decode:true crayon-inline ">knife node search</span> , it will work in this
      </td>
    </tr>
    
    <tr>
      <td >
        -A
      </td>
      
      <td >
        michael
      </td>
      
      <td >
        the administrators who can read and edit the vault, comma delimited
      </td>
    </tr>
    
    <tr>
      <td >
        -J
      </td>
      
      <td >
        root.json
      </td>
      
      <td >
        the file that represents the data bag to be stored
      </td>
    </tr>
    
    <tr>
      <td >
        -M
      </td>
      
      <td >
        client
      </td>
      
      <td >
        that you want this to be run against your chef server
      </td>
    </tr>
  </table>
</div>

This uploads two data bag items to a data bag called "passwords":

  1. <span class="lang:default highlight:0 decode:true crayon-inline ">root</span>  which has the data above
  2. **<span class="lang:default highlight:0 decode:true crayon-inline ">root_keys</span>**  which stores the metadata about which clients can read and edit this data bag (as you specified above in the search criteria and administrators list.

### Making it Even More Secure

[Noah Kantrowitz](https://coderanger.net/) helped me understand the vulnerabilities of the above approach using the <span class="lang:default decode:true crayon-inline ">-S</span>  flag. With that flag, you give the nodes the ability to define the criteria by which they are allowed to decrypt the vault. So if you say I want nodes that have <span class="lang:default decode:true crayon-inline ">&#8216;policy_name:webserver'</span>  to decrypt this data, all it takes is someone saying they are <span class="lang:default decode:true crayon-inline ">&#8216;policy_name:webserver'</span>  and they will be granted the keys.

A better way to handle this is through specifying each node explicitly through the -A flag. So your command would be:

<pre class="lang:default highlight:0 decode:true">knife vault create passwords root -A "michael,webserver1,webserver2" -J root.json -M client</pre>

## Viewing a Vault

Now that we have created a vault, let's view it:

<pre class="lang:default highlight:0 decode:true">knife vault show passwords root -M client</pre>

which will output:

<pre class="lang:default decode:true ">id: root
password: myPassword
username: mhedgpeth</pre>

It lets me view it in cleartext because I am one of the administrators on the vault itself. If I want, I can even view it in JSON if you want to move the file to another chef server:

<pre class="lang:default highlight:0 decode:true">knife vault show passwords root -M client -Fjson</pre>

## Viewing Encrypted Version

To view the encrypted version of the vault, you can simply use the normal commands for viewing data bag, just realizing that the vault data bag also has a _keys one too:

<pre class="lang:default highlight:0 decode:true">knife data bag show passwords root</pre>

and

<pre class="lang:default highlight:0 decode:true">knife data bag show password root_keys</pre>

Will show you lots of encrypted goodness which I will not show. The keys is helpful to see what clients are connected to it.

## Adding nodes

Probably the weakest part of chef-vault is what to do when you add nodes. If you have an elastic situation this can be dicey, because when you add nodes, you have to run this command to generate keys for those nodes to read the encrypted data:

<pre class="lang:default highlight:0 decode:true">knife vault refresh passwords root --clean-unknown-clients</pre>

This updates the <span class="lang:default highlight:0 decode:true crayon-inline ">root_keys</span>  encrypted data bag with information on the nodes that now match the search criteria. So it's  important to know that the nodes that can read a vault is a snapshot in time based on the search criteria, not a dynamic list.

## Rotating keys

You might want to rotate the key that encrypts the data in the data bag. The way this works is the clients use their own key as a private key to combine with the public key on the chef server to decrypt the data bag's key. That key encrypts the real data bag. This command will change that key:

<pre class="lang:default highlight:0 decode:true ">knife vault rotate all keys</pre>

## Cookbook Development

What use is a data bag without using it in a cookbook? To be able to deal with this data bag in the cookbook, include the <span class="lang:default decode:true crayon-inline ">chef-vault::default</span>  recipe in your runlist. Then you will have the <span class="lang:default decode:true crayon-inline ">chef_vault_item</span>  method that you can call like this:

<pre class="lang:default decode:true">item = chef_vault_item("passwords", "root")
password = item['password']</pre>

Using <span class="lang:default decode:true crayon-inline ">chef_vault_item</span>  will make your cookbook more testable by test kitchen (see below).

## Version Control

With data bags, we like to have a data_bags repository that we use to promote shared data and version control changes. This kind of thing doesn't work with chef-vault. Instead you get a small team that can update the vault and then have them manually do it. This isn't ideal, but secrets are hard and, as I wrote above, using a dedicated secrets management tool like Hashicorp Vault will keep you from that level of work.

## Kitchen Support

To make this work in kitchen, just put a cleartext data bag in the data\_bags folder that your kitchen run refers to (probably in test/integration/data\_bags). Then the vault commands fall back into using that dummy data when you use <span class="lang:default decode:true crayon-inline ">chef_vault_item</span>  to retrieve it.

## Conclusion

The chef-vault functionality is compelling enough for serious consideration. Hopefully this walkthrough will help you decide if it is right for you.