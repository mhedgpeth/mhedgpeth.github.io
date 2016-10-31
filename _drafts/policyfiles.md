---
layout: post
title: "Policyfiles"
# date: 2016-09-09T08:00:00+00:00
categories: chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 45
feature_image: feature-policyfiles
show_related_posts: true
square_related: related-policyfiles
permalink: /policyfiles/
---
Recently at the [Chef Community Summit](https://summit.chef.io/seattle/), I proposed a topic on [Policyfiles](https://docs.chef.io/policyfile.html). Policyfiles are a new way to handle dependency management and change management for your Chef infrastructure. During the session it became clear that there wasn't enough information out there on how it works and why to use them. I realized that an introduction to Policyfiles for the Chef Community was far overdue.

# Why Policyfiles?

Early on in my Chef adoption, [it became clear that I couldn't deliver on the strict change management controls within the legacy Chef workflow without a lot of work](/my-advice-for-chef-in-large-corporations/). With the traditional Chef workflow, you can update a cookbook in production and all of the sudden everything is updated. Was it tested? Well let's hope so! Let's hope so doesn't cut it when you're dealing with an enterprise as large and complicated as NCR. Our entire business rests on the trust our customers put into us to securely handle their financial transactions.

**With Policyfiles you can guarantee that the exact same cookbooks that ran in earlier environments will run in later environments.** You get real change management that is inuitive and doesn't leave you trying to explain the intricacies of Chef dependency management in an outage call. **It just works.**

Another benefit we get out of Policyfiles is **it makes Chef easy to learn**. Rather than burdening the user with a complex structure of roles, cookbooks, environments, and pinning, I can simply show them a Policyfile and show them the workflow I outline below. I've found that this greatly speeds up onboarding with Chef. I challenge the Chef veterans who are reading this to explain Chef to someone using the workflow outlined below and watch the magic: you'll see that they really get it at the end, and they went from nothing to a working solution far more quickly than you're used to.

That adoption cost has a real effect on the future of Chef. If there are less people in the community due to high barriers to entry, there are less cookbooks and less opportunities for Chef Inc. to monetize the platform and therefore invest more into it. So, even if you have already defined complicated workarounds that address the deficiencies in the legacy workflow, I encourage you to adopt and support it in situations it makes sense. Keep an open mind.

# Policyfile Workflow

The best way to understand the Policyfile feature is by walking through an example. We'll configure a webserver for one of our apps with Policyfiles.

## Policyfile.rb file

The first thing we'll start with is the `Policyfile.rb` itself. **A Policyfile declares the name, run list, sources, and attributes for a node or group of nodes.**


The file can be named whatever it needs to. On our projects, there are usually many Policyfiles: we could have `myapp-webserver.rb` and `myapp-database.rb`. The name that you use has to be unique in your Chef server.

If you're just starting out, the Policyfile will go in your application's cookbook repo. As you advance, you'll probably want to separate it into its own repository, because the rapid updating of the lock file outlined below will clutter up your history. At this point we have about half and half Policyfiles in cookbooks vs. their own repository.

### Creating the Policyfile

It's always good to start out with a generated policyfile to make the adoption a little easier. There are two ways to do this:

First you could generate the Policyfile directly:

```
chef generate policyfile Policyfile.rb
```

Or you can add the `-P` flag to the `chef generate cookbook` command:

```
chef generate cookbook myapp -P
```

Either way you have a Policyfile generated and ready to go.

### Basic Contents

Once the Policyfile is generated, it should look like this:

```ruby
name 'webserver' # will be used later in Client.rb on the Node
default_source :supermarket, 'https://supermarket.mycompany.com' # this uses only internally approved cookbooks
 
run_list 'recipe[myapp::webserver]' # the run list of recipes; won't contain roles

cookbook 'myapp', git: 'https://git.mycompany.com/devops/myapp' # declaration of where to find cookbooks that are outside of the default_source
```

Let's go over the elements:

<table>
  <tr>
    <th>Element</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>name</td>
    <td>used to reference this policyfile on the Chef server and it must be unique. As I said above, you probably want to come up with a naming convention for your Policies. We use applicationname-role.rb for ours (like myapp-webserver).</td>
  </tr>
  <tr>
    <td>default_source</td>
    <td>This is where we get all of our cookbooks if they're not specifically declared in the lower section. This will usually be a supermarket.</td>
  </tr>
  <tr>
    <td>run_list</td>
    <td>In this model you don't declare a run_list on the client itself. This maintains consistency between environments.</td>
  </tr>
  <tr>
    <td>cookbook</td>
    <td>declares the non-default location where chef can find this cookbook. In this case we'll find it on the git server.</td>
  </tr>
</table>


### Environment-specific settings

Pretty quickly you'll run into situations where you have environment specific settings. This is better avoided if at all possible; one possible solution is [to use Consul](https://youtu.be/TEvElu6Wnbc) to deal with environment-specific settings. However, it's also important to make progress, so you'll probably want to declare the settings in a structure that includes the `policy_group`.

```ruby
# in the Policyfile:
default['myapp'] = {
  qa: {
    database: 'qaserver01'
  },
  uat: {
    database: 'uatdbsrv32'
  },
  production: {
    database: 'proddbsrv62'
  }
```
Then in our recipe code we can reference the `policy_group` and easily get to our setting:

```ruby
database = node['myapp'][Chef::Config.policy_group]['database']
```

## Creation of the Policyfile.lock.json file

Now that you have a declaration of what you want to run on a machine, it's time to create a point in time snapshot of *specific* dependencies Chef will use on a node. This is your actual policy and it is stored in your `Policyfile.lock.json` file. This is the file that your node will read to pull dependencies down and run them locally.

To generate your `Policyfile.lock.json` file, run:

```
chef install Policyfile.rb 
```

This generates the following important attributes at the top of the file:

```json
"revision_id": "6156a875a7c0eb06ce9gdc9e3d4f19809752942efd6dd20888ddd9fd8bbbd43b5",
"name": "platform",
"run_list": [
  "recipe[platform::default]"
],
```

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>revision_id</td>
    <td>This is a **very** important field, that will tell you what version of the policy you are running on the chef server and during your chef run. By committing the <pre>Policyfile.lock.json</pre> file to source, you'll always be able to view **exactly** what runs on the node by referring back to the version of this file by this revision.</td>
  </tr>
  <tr>
    <td>name</td>
    <td>The policy name, which you will use in the client.rb to declare which policy the node uses. This is the "logical" connection to the policy.</td>
  </tr>
  <tr>
    <td>run_list</td>
    <td>A fully expanded list of recipes that will run. With this generation there is no doubt over what will run. This is a major benefit of this over using roles or environments, where there can be a doubt, and thus confusion and potential disaster.</td>
  </tr>
</table>

Later down the file, we can see the output for one of our cookbooks:

```json
"windows": {
  "version": "1.40.0",
  "identifier": "54a9b2515c853919c4953893997899584d4cefba",
  "dotted_decimal_identifier": "23830481377985849.7253019596134776.168604533059514",
  "cache_key": "windows-1.40.0-supermarket.mycompany.com",
  "origin": "https://supermarket.mycompany.com:443/api/v1/cookbooks/windows/versions/1.40.0/download",
  "source_options": {
    "artifactserver": "https://supermarket.mycompany.com:443/api/v1/cookbooks/windows/versions/1.40.0/download",
    "version": "1.40.0"
  }
}
```

You can see here that there is a very specific declaration of the dependency for the cookbook. This is in the policyfile so if we wanted to regenerate all dependencies from this `Policyfile.lock.json`, we can do so as long as we still have connectivity to the repositories on which the dependencies are stored. It's important to also note that the `identifier` here *also* doubles as a checksum of the cookbook contents. If the contents change, but **nothing else** changes, then `chef-client` will refuse to run the policy. This is a tamper-proof mechanism that increases your ability to predict what code will run on your servers.

Remember, we are running this code with elevated privileges, so if you're running in production, it's incredibly important to predict what will happen. You can't easily predict outcomes without policyfiles.

## Pushing it to the Chef Server

Now that we have a lockfile built, if our nodes, Chef Server, and development machine are all on the same network, we can simply push the policy to the Chef Server:

```
chef push qa Policyfile.rb
```

This will push the policy and all dependencies declared in the lockfile to the Chef Server for the `qa` policy group. Once you run this command, you can guarantee that you can run it on a node. No more remembering to upload a specific dependency; it's simply there for you to run and will include the exact same cookbooks that are in the lockfile.

The `qa` above is your policy group. A policy group is a logical group of nodes that you want to have the same policy. Since many times you'll be using the same Chef Server to manage multiple environments, you'll want to split your nodes into different policy groups so you can make sure that you are flowing policy changes through a pipeline before they get to production.

## Setting up Chef Client

To run this on a node, the `client.rb` needs to have the following attributes set:

```ruby
# client.rb
policy_name      'webserver' # corresponds to the 'name' in Policyfile.rb and Policyfile.lock.json
policy_group     'qa' # arbitrary name, similar to environments
```

The idea here is that you create a `policy_group` for your different environments. You might have `development` then `qa` then `uat` then `production`. Each `policy_group` will have a specific `Policyfile.lock.json` associated with it. 

## Packaging it for Air Gapped environments

You're not always going to have a connected Chef Server available and may need to transfer your policy to an Air-Gapped environment. Policyfiles make this process incredibly easy because they package up reproducible dependencies. To do this, start by running:

```
chef export Policyfile.rb . -a
```

This will export the contents of the `Policyfile.lock.json` that you created into an archive that contains **all** cookbook dependencies. Now you can transfer this file to the air-gapped environment however you are used to doing so. Once you're there, to load it up on the Chef Server, you can run:

```
chef push-archive qa Policyfile-6156a875a7c0eb06ce9gdc9e3d4f19809752942efd6dd20888ddd9fd8bbbd43b5.tar.gz
```

Again, we're declaring a policy group here, but this is pretty much the same as the `chef push` command above. Your policy is active for that policy group on the Chef Server, and you can rest assured that all cookbooks are there ready to be used.

## Pipeline management

We're going to want to add this workflow to a pipeline that we can manage in Jenkins or TeamCity. The process will roughly consist of:

1. Cookbook builds, which include running Test Kitchen, ChefStyle linting, etc.
2. Promotion to an internal supermarket (if you have one)
3. Updating pinned versions of those cookbooks in the Policyfile or in specific cookbooks through a pull request
4. Whenever the Policyfile.rb changes, or on demand, or when dependencies complete, rebuild the `Policyfile.lock.json` file and check it in
5. Push the `Policyfile.lock.json` file to the Chef Server for locally available resources. If there is a pipeline, push to one policy group at a time and make sure they work before pushing out even further.
6. If there isn't a Chef Server connected to your build environment, post the policyfile archive to be loaded by your air-gapped environment. Much of this can be automated, but you'll find that there is a step where you have to physically deal with the air-gapped environment (by definition).

# Conclusion

The Chef Community should adopt policyfiles because they are easier to learn than the legacy workflow, give you better change management control, and are more flexible for security-concious implementations. Hopefully this blog post will serve as an impetus for broader adoption of the feature and eventual inclusion into the Automate product suite. 