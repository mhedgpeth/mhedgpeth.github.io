---
title: chef-vault Tutorial
date: 2016-04-06T00:00:32+00:00
tags:
  - automation
  - chef
  - security
author: Michael
slug: chef-vault-tutorial
---
<div class="full-width">
  <img src="/images/feature-chef-vault-tutorial.jpg" alt="Vault Tutorial" />
</div>

This week I researched [chef-vault](https://github.com/chef/chef-vault) and struggled quite a bit [with the documentation](https://docs.chef.io/chef_vault.html), so I thought I would write a bit of a tutorial on the technology for those who are interested in quickly understanding how it might work for their organizations.

## Why chef-vault?

[Encrypted data bags](https://docs.chef.io/data_bags.html#encrypt-a-data-bag-item) force you to copy the shared secret that is used for decryption to your infrastructure. It's very easy to take that secret file and nefariously decrypt the data from somewhere else without anyone knowing about it. Chef-vault makes this much more difficult by giving both nodes and chef server users expressed permission to decrypt certain data. With chef-vault you don't have to share a secret file with all of your nodes. This is a step up that simplifies everything.

The solution isn't without its drawbacks. The main one is if you add nodes, you have to rerun something on the server to get that node to be able to decrypt the data bag. With [Hashicorp's vault](https://www.hashicorp.com/blog/vault.html) you get better control over that, and better lease management, and credentials creation. To me, encrypted data bags are an unreliable used car, chef-vault is a nice mid-size sedan, and Hashicorp's vault is like a luxury car.

So now that we know where the tool sits within our choices, let's look at the basics:

## Setup

To get started with chef-vault, have the latest [ChefDK](https://downloads.chef.io/chef-dk/) installed (0.12 or greater) and install the [chef-vault gem](https://rubygems.org/gems/chef-vault/versions/2.8.0):

```bash
chef gem install chef-vault
```

And then ensure you have a .chef directory that connects to a chef server.

## Creation

Creating a vault is easy:

```
knife vault create passwords root -S "policy_name:webserver" -A "michael" -J root.json -M client
```

For whatever reason the `knife vault`  command doesn't default to talk to a chef server. So to create a knife vault, you have to specify `-M client`  at the end. Or you can make your life easier going forward by adding this line to your knife.rb:

```
knife[:vault_mode] = 'client'
```

For the command, I used this root.json:
  
```
{
"username": "mhedgpeth",
"password": "myPassword"
}
```

Let's review the options:


| Team        | Natural Alignment                                                                   | Natural Misalignment                                |
|-------------|-------------------------------------------------------------------------------------|-----------------------------------------------------|
| Development | Faster Delivery of features                                                         | Have to be engaged in operations, more "work" to do |
| Operations  | Less fires, more consistency                                                        | Have to learn a new skillset and be a beginner      |
| Security    | More consistency, compliance                                                        | Automation can cause unknown vulnerabilities        |
| Business    | Faster ROI for development, lower cost for operations, and a scale model that works | Takes ongoing investment in culture and tools       |

This uploads two data bag items to a data bag called "passwords":

  1. `root` which has the data above
  2. **`root_keys`**  which stores the metadata about which clients can read and edit this data bag (as you specified above in the search criteria and administrators list.

### Making it Even More Secure

[Noah Kantrowitz](https://coderanger.net/) helped me understand the vulnerabilities of the above approach using the `-S`  flag. With that flag, you give the nodes the ability to define the criteria by which they are allowed to decrypt the vault. So if you say I want nodes that have `policy_name:webserver`  to decrypt this data, all it takes is someone saying they are `'policy_name:webserver'`  and they will be granted the keys.

A better way to handle this is through specifying each node explicitly through the -A flag. So your command would be:

```
knife vault create passwords root -A "michael,webserver1,webserver2" -J root.json -M client
```

## Viewing a Vault

Now that we have created a vault, let's view it:

```
knife vault show passwords root -M client
```

which will output:

```
id: root
password: myPassword
username: mhedgpeth
```

It lets me view it in cleartext because I am one of the administrators on the vault itself. If I want, I can even view it in JSON if you want to move the file to another chef server:

```
knife vault show passwords root -M client -Fjson
```

## Viewing Encrypted Version

To view the encrypted version of the vault, you can simply use the normal commands for viewing data bag, just realizing that the vault data bag also has a _keys one too:

```
knife data bag show passwords root
```

and

```
knife data bag show password root_keys
```

Will show you lots of encrypted goodness which I will not show. The keys is helpful to see what clients are connected to it.

## Adding nodes

Probably the weakest part of chef-vault is what to do when you add nodes. If you have an elastic situation this can be dicey, because when you add nodes, you have to run this command to generate keys for those nodes to read the encrypted data:

```
knife vault refresh passwords root --clean-unknown-clients
```

This updates the `root_keys`  encrypted data bag with information on the nodes that now match the search criteria. So it's  important to know that the nodes that can read a vault is a snapshot in time based on the search criteria, not a dynamic list.

If you aren't using a search criteria, you'll need to add nodes to the administrators list itself:

```
knife vault update passwords root -A 'newnode,newnode2'
```

## Rotating keys

You might want to rotate the key that encrypts the data in the data bag. The way this works is the clients use their own key as a private key to combine with the public key on the chef server to decrypt the data bag's key. That key encrypts the real data bag. This command will change that key:

```
knife vault rotate all keys
```

## Cookbook Development

What use is a data bag without using it in a cookbook? To be able to deal with this data bag in the cookbook, include the `chef-vault::default`  recipe in your runlist. Then you will have the `chef_vault_item`  method that you can call like this:

```
item = chef_vault_item("passwords", "root")
password = item['password']
```

Using `chef_vault_item`  will make your cookbook more testable by test kitchen (see below).

## Version Control

With data bags, we like to have a data_bags repository that we use to promote shared data and version control changes. This kind of thing doesn't work with chef-vault. Instead you get a small team that can update the vault and then have them manually do it. This isn't ideal, but secrets are hard and, as I wrote above, using a dedicated secrets management tool like Hashicorp Vault will keep you from that level of work.

## Kitchen Support

To make this work in kitchen, just put a cleartext data bag in the data\_bags folder that your kitchen run refers to (probably in `test/integration/data_bags`). Then the vault commands fall back into using that dummy data when you use `chef_vault_item`  to retrieve it.

## Conclusion

The chef-vault functionality is compelling enough for serious consideration. Hopefully this walkthrough will help you decide if it is right for you.