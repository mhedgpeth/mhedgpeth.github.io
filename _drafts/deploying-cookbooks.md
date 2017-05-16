# DEPLOYING COOKBOOKS

The Deploying Cookbooks badge is awarded when someone proves that they understand how to use Chef server to manage nodes and ensure they're in their expected state.

## Candidates must show:
• An understanding of the chef-client run phases.
• An understanding of using Roles and Environments.
• An understanding of maintaining cookbooks on the Chef server.
• An understanding of using knife.
• An understanding of using how bootstrapping works.
• An understanding of what policy files are.
• An understanding of what Chef solo is.
• An understanding of using search.
• An understanding of databags.

Here is a detailed breakdown of each area.

## ANATOMY OF A CHEF RUN 

### CHEF-CLIENT OPERATION

Candidates should understand:

**chef-client modes of operation**

- normal mode, against a chef server (just run `chef-client`)
- local mode with `chef-client -z`

**Configuring chef-client**
configured through the client.rb
also you can run it with command line arguments


### COMPILE VS EXECUTE

Candidates should understand:

**What happens during the 'compile' phase?**
A resource list is built

**What happens during the 'execute' phase?**
Each resource is tested and repaired (or converged)

**What happens when you place some Ruby at the start of a recipe?**
It happens at the start of compile time

**What happens when you place some Ruby at the end of a recipe?**
It happens at the end of compile time

**When are attributes evaluated?**
Before the client time, after OHAI. See https://docs.chef.io/chef_client.html

**What happens during a 'node.save' operation?"**
The node attributes are updated during compile time

### RUN_CONTEXT

Candidates should understand:

**How can you tap into the chef-client run?**
with [Chef handlers](https://docs.chef.io/resource_chef_handler.html)

**What is the `run_context` data structure?**
It is an object used withing Chef Handlers that have the following properties:
  `cookbook_collection`: the list of cookbooks used in the run
  `resource_collection`: the list of resources that were compiled and are running

**What is `run_status`?**
[An object](https://docs.chef.io/handlers.html#run-status-object) sent to handlers that tells you how the run went, so you can report on it in whatever way you need to.

**What is `run_state`?**
A global hash where one resource can pass data to another. Probably not a good practice.

**What is the `resource collection`?**

A list of the compiled resources that will converge.


### AUTHENTICATION

Candidates should understand:

**How does the chef-client authenticate with the Chef Server?**
Each request to the Chef server from knife and chef-client sign a special group of HTTP headers with the private key. The Chef server then uses the public key to verify the headers and verify the contents. (see [documentation](https://docs.chef.io/chef_client.html#authentication))

**Authentication and using NTP**
If you don't have NTP turned on and the chef server is at a different time than the client, the client won't be accepted.


### CHEF COMPILE PHASE

Candidates should understand:

**Do all cookbooks always get downloaded?**
Only changes are downloaded, but all cookbooks will be local after a run

**What about dependencies, and their dependencies?**
Dependencies are calculated by the chef-client resolver and then the resolver, including depedencies of dependencies

**What order do the following get loaded - libraries, attributes, resources/providers, definitaions, recipes?**
Libraries
Attributes
Resources/Providers
Definitions
Recipes

### CONVERGENCE

Candidates should understand:

**What happens during the execute phase of the chef-client run?**
Iterate through each resource in the resource collection and run a test/repair on it

**The test/repair model**
First test to see that the desired state matches the actual state, and if different "repair", or converge that resource on the node

**When do notifications get invoked?**
Notifications are invoked based on their declaration, either:

1. `:before`: will get run after test, but before repair of a node
2. `:immediately`: will get run after the repair occurs
3. `:delayed`: will run at the end after all resources are run 

**What happens if there are multiple start notifications for a particular resource?**
They run in order

**When is node data sent to the Chef Server?**
After a converge finishes

### WHY-RUN

Candidates should understand:

**What is the purpose of `why-run`**
To tell you what would run as a result of a converge without actually running.

**How do you invoke a `why-run`**
pass in `-W` or `--why-run` to the `chef-client` run

**What are limitations of doing a why run?**
It works well for systems that are *almost* converged. For example if a package installed a service that then should be started, why-run won't work because it won't install that package. In other words it doesn't work well with dependent resources. See [here](https://docs.chef.io/chef_client.html#about-why-run-mode).

## ENVIRONMENTS 

### WHAT IS AN ENVIRONMENT/USE CASES

Candidates should understand:

**What is the purpose of an Environments?**

1. for data that is different between different node groups
2. to preserve cookbook versions between different node groups

**What is the '_default' environment?**

The environment that everyone gets if they aren't using an environments.

**What information can be specified in an Environment?**

1. Attributes
2. Cookbook pinning

**What happens if you do not specify an Environment?**

A `_default` environment is used

**Creating environments in Ruby**

Have a ruby file like this:

```ruby
name 'environment_name'
description 'environment_description'
cookbook OR cookbook_versions  'cookbook' OR 'cookbook' => 'cookbook_version'
default_attributes 'node' => { 'attribute' => [ 'value', 'value', 'etc.' ] }
override_attributes 'node' => { 'attribute' => [ 'value', 'value', 'etc.' ] }
```

And then `knife environment from file` command

**Creating environments in JSON**

Create a json file like this:

```json
{
  "name": "dev",
  "default_attributes": {
    "apache2": {
      "listen_ports": [
        "80",
        "443"
      ]
    }
  },
  "json_class": "Chef::Environment",
  "description": "",
  "cookbook_versions": {
    "couchdb": "= 11.0.0"
  },
  "chef_type": "environment"
}
```

**Using environments within a search**

`knife search environment 'listen_ports:80'`

### ATTRIBUTE PRECEDENCE AND COOKBOOK CONSTRAINTS

Candidates should understand:

**What attribute precedence levels are available for Environments**

1. `default` - overrides a `cookbook` or `recipe` default but not a `role`
2. `override` - overrides a `cookbook` or `recipe` default and override but not a `role`

**Overriding Role attributes**

Do this with attribute precedence (above) or by using data bags

**Syntax for setting cookbook constraints.**

The syntax is the same as cookbook pinning in a `metadata.rb`:

`= 1.0.0` equal to 1.0.0
`>= 1.0` greater or equal to 1.0
`~> 2.0` greater than 2 but less than 3

**How would you allow only patch updates to a cookbook within an environment?**

By using the `~>` operator

### SETTING AND VIEWING ENVIRONMENTS

Candidates should understand:

**How can you list Environments?**

`knife environment list` (see [docs](https://docs.chef.io/knife_environment.html#list))

**How can you move a node to a specific Environment?**

[Lots of ways](https://docs.chef.io/environments.html#set-for-a-node):

1. By adding `chef_environment` to `client.rb`
2. By editing a node's `chef_environment` with `knife edit nodename1`
3. By `knife exec` (as below)

**Using `knife exec` to bulk change Environments.**

You do this with the [`knife exec`](https://docs.chef.io/environments.html#move-nodes) command:

```
knife exec -E 'nodes.transform("chef_environment:dev") { |n| n.chef_environment("production") }'
```

**Using 'chef_environment' global variable in recipes**

Just call `node.chef_environment` and you're done!

**Environment specific knife plugins, e.g. `knife flip`**

`knife flip` can be used to take a node and put it into a new environment.

**Bootstrapping a node into a particular Environment**

Just pass in `-E production` or `-environment production` to provide the environment name.

## ROLES 

### USING ROLES

Candidates should understand:

**What is the purpose of a Role?**

[A role](https://docs.chef.io/roles.html) will allow control over cookbooks and settings across nodes for a certain job or function.

**Creating Roles**

Create a ruby or json file and then run `knife role from file role.json`. (See [help topic](https://docs.chef.io/knife_role.html#from-file))

**Role Ruby & JSON DSL formats**

Ruby:

```ruby
name "webserver"
description "The base role for systems that serve HTTP traffic"
run_list "recipe[apache2]", "recipe[apache2::mod_ssl]", "role[monitor]"
env_run_lists "prod" => ["recipe[apache2]"], "staging" => ["recipe[apache2::staging]"], "_default" => []
default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }
override_attributes "apache2" => { "max_children" => "50" }
```

Json:

```json
{
  "name": "webserver",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "default_attributes": {
    "apache2": {
      "listen_ports": [
        "80",
        "443"
      ]
    }
  },
  "description": "The base role for systems that serve HTTP traffic",
  "run_list": [
    "recipe[apache2]",
    "recipe[apache2::mod_ssl]",
    "role[monitor]"
  ],
  "env_run_lists" : {
    "production" : [],
    "preprod" : [],
    "dev": [
      "role[base]",
      "recipe[apache]",
      "recipe[apache::copy_dev_configs]",
    ],
    "test": [
      "role[base]",
      "recipe[apache]"
    ]
  },
  "override_attributes": {
    "apache2": {
      "max_children": "50"
    }
  }
}
```

**Pros and Cons of Roles**

Pro: allows a team to control cookbooks that run everywhere so they feel like they have control
Cons: a single team could ruin all of your infrastructure with one change. Did they test this change? Good luck!

**The Role cookbook pattern**

It's better to include all the recipes you want in a single cookbook that is acting as including what the team wants. This is a better pattern.

**Creating Role cookbooks**

Just create a cookbook and do `include_recipe`. Just like normal.

**Using Roles within a search**

Do `knife search role 'name:pattern'` just like with others.


### SETTING ATTRIBUTES AND ATTRIBUTE PRECEDENCE

Candidates should understand:

**What attribute precedence levels are available for Roles**

1. `default` which overrides all other `default` attributes
2. `override` which overrides all other `override` attributes

**Setting attribute precedence**

By adding the attributes to `default_attributes` or `override_attributes` run lists.

### BASE ROLE & NESTED ROLES

Candidates should understand:

**What are nested roles?**

A role can have a role in its run list.

**Whats the purpose of a `base` role?**

A role that is used on all roles, guaranteeing that gets ran.

### USING KNIFE

Candidates should understand:

**The `knife role` command**

How you create delete edit a role (from file too). See [help](https://docs.chef.io/knife_role.html).

**How would you set the run_list for a node using `knife`?**

Add run list item: `knife node run_list add node1 'recipe[mycookbook::default]'`
Remove with the `remove` keyword
Set the entire thing with the `set` keyword

**Listing nodes**

`knife node list`

**View role details**

`knife role list` - to show all the roles
`knife role show security` - to show a specific role

**Using Roles within a search**

`knife search role 'attribute:pattern'`

## UPLOADING COOKBOOKS TO CHEF SERVER 

### USING BERKSHELF

Candidates should understand:

**The Berksfile & Berksfile.lock**

The `Berksfile` declares a supermarket and dependencies and the `Berksfile.lock` contains those resolved dependencies.

**`berks install` and `berks upload`**

`berks install` will install all cookbooks locally, and `berks upload` will upload all dependencies to the chef server.

**Where are dependant cookbooks stored locally?**

In `~/.berkshelf` folder

**Limitations of using knife to upload cookbooks**

1. it doesn't upload all cookbook dependencies
2. it doesn't freeze them

**Listing cookbooks on Chef Server using knife**

`knife cookbook list`

**What happens if you try to upload the same version of a cookbook?**

It will allow that unless you freeze it (`--freeze`), at which point you have to `--force` upload it

**How can you upload the same version of a cookbook?**

By using `--force`

**Downloading cookbooks from Chef Server**

`knife cookbook download apache`

**Bulk uploading cookbooks using knife**

1. to include dependencies use the `-d` flag
2. to upload all cookbooks pass in `-a` flag

## USING KNIFE 

### BASIC KNIFE USAGE

Candidates should understand:

**How does knife know what Chef Server to interact with?**

By using the `knife.rb` file in the `.chef` folder, either in the current folder, parent, or user folder whichever is found first.

**How does knife authenticate with Chef Server**

By using the `user.pem` file located in the `.chef` folder

**How/When would you use `knife ssh` & `knife winrm`?**

When you want to do something on a subset of nodes based on a chef search

**Verifying ssl certificate authenticity using knife**

`knife ssl check`

**Where can/should you run the `knife` command from?**

From a developer machine or a build agent.

### KNIFE CONFIGURATION

Candidates should understand:

**How/where do you configure knife?**

Through the [`knife.rb`](https://docs.chef.io/config_rb_knife.html) file in the `.chef` folder

**Common options - `cookbook_path`, `validation_key`, `chef_server_url`, `validation_client_name`**

`cookbook_path` where the cookbooks are located
`validation_key` where the validation pem is located to validate to the chef server when bootstrapping
`validation_client_name` the name of the client that will be used to bootstrap nodes
`chef_server_url` the full url including organization of where to find the chef server

**Setting the chef-client version to be installed during bootstrap**

With `--bootstrap-version 13.1.0`

**Setting defaults for command line options in knife`s configuration file**

With using the `knife[]` hash, like

```ruby
knife[:ssh_port] = 22
knife[:bootstrap_template] = 'ubuntu14.04-gems'
knife[:bootstrap_version] = ''
knife[:bootstrap_proxy] = ''
```

**Using environment variables and sharing knife configuration file with your team**

like this:

```ruby
current_dir = File.dirname(__FILE__)
  user = ENV['OPSCODE_USER'] || ENV['USER']
  node_name                user
  client_key               "#{ENV['HOME']}/chef-repo/.chef/#{user}.pem"
  validation_client_name   "#{ENV['ORGNAME']}-validator"
  validation_key           "#{ENV['HOME']}/chef-repo/.chef/#{ENV['ORGNAME']}-validator.pem"
  chef_server_url          "https://api.opscode.com/organizations/#{ENV['ORGNAME']}"
  syntax_check_cache_path  "#{ENV['HOME']}/chef-repo/.chef/syntax_check_cache"
  cookbook_path            ["#{current_dir}/../cookbooks"]
  cookbook_copyright       "Your Company, Inc."
  cookbook_license         "apachev2"
  cookbook_email           "cookbooks@yourcompany.com"

  # Amazon AWS
  knife[:aws_access_key_id] = ENV['AWS_ACCESS_KEY_ID']
  knife[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']

  # Rackspace Cloud
  knife[:rackspace_api_username] = ENV['RACKSPACE_USERNAME']
  knife[:rackspace_api_key] = ENV['RACKSPACE_API_KEY']
```

**Managing proxies**

with `http_proxy` and other settings.

### KNIFE PLUGINS

Candidates should understand:

**Common knife plugins**

`knife bootstrap`
`knife exec`
`knife node`
`knife search`
`knife data bag`
`knife ssl check`
`knife ssl fetch`

**What is 'knife ec2' plugin**

Allows you to control ec2 from knife: https://github.com/chef/knife-ec2

**What is 'knife windows' plugin**

Allows you to do winrm commands over nodes in chef

**What is `knife block` plugin?**

Allows for working with multiple chef servers (see [github](https://github.com/knife-block/knife-block))

**What is `knife spork` plugin?**

Allows for doing chef development like Etsy does but also includes bumping versions.

**Installing knife plugins**

Install with RubyGems (`gem install knife-spork`)

### TROUBLESHOOTING

Candidates should understand:

**Troubleshooting Authentication**

Run `knife ssl check` and then `knife ssl fetch` then `knife node list`

**Using `knife ssl check` command**

Checks that we can talk to the Chef Server

**Using `knife ssl fetch` command**

Retrieves ssl certificates from the Chef Server so they can be stored locally and trusted

**Using '-VV' flag**

Runs `chef-client` in verbose mode

**Setting log levels and log locations**

pass into the `chef-client` with `-l debug` or `--log-level debug`

for log location pass in:

`-L C:\chef\log.txt`

## BOOTSTRAPPING 

### USING KNIFE

Candidates should understand:

**Common `knife bootstrap` options - UserName, Password, RunList, and Environment**

`-x` user name
`-P` password
`-r` run list
`-E` environment

**Using `winrm` & `ssh`**

To run a winrm command against a set of nodes

**Using knife plugins for bootstrap - `knife ec2 ..`, `knife bootstrap windows ...`**

Usuallky do knife bootstrap and look it up

### BOOTSTRAP OPTIONS

Candidates should understand:

**Validator' vs 'Validatorless' Bootstraps**

Validatorless uses your own key to validate the node, validator uses a special validator key

**Bootstrapping in FIPS mode**

See [help](https://docs.chef.io/fips.html#id2)

Pass in the `--fips` flag and make sure the kernal has it turned on

**What are Custom Templates**

[Used](https://docs.chef.io/knife_bootstrap.html#custom-templates) to specify which place to download during the bootstrap.

### UNATTENDED INSTALLS 

Candidates should understand:

**Configuring Unattended Installs**

[Unattended installs](https://docs.chef.io/install_bootstrap.html#unattended-installs) are configured:

1. Attributes through passing in a json file to the `chef-client`: i.e. `chef-client -J attributes.json`. This should include a `run_list` or `policy_file`/`policy_name`.
2. Environment is set through `--environment` flag to the `chef-client`

**What conditions must exists for unattended install to take place?**

1. Must be able to log into a chef server with a `validator.pem`
2. Must be able to configure a run list
3. Unique node name

### FIRST CHEF-CLIENT RUN
Candidates should understand:

**How does authentication work during the first chef-client run?**

1. Validatorless - uses the `user.pem` that is located in the `.chef` directory
2. Validator (classic) - uses the `ORGANIZATION-validator.pem` to log into it

Validatorless is more secure because you have to keep track of one less file

**What is `ORGANIZATION-validator.pem` file and when is it used?**

See above and [help topic](https://docs.chef.io/install_bootstrap.html#validatorless-bootstrap).

**What is the `first-boot.json` file?**

A way to seed all of the attributes for that node.

## POLICY FILES 

### BASIC KNOWLEDGE AND USAGE
Candidates should understand:

**What are policy files, and what problems do they solve?**

A way to define a node's run list and dependencies in one place. Simplifies everything. It's the best.

**Policy file use cases?**

1. `chef install` will compile the policyfile
2. `chef push` will update the chef server


**What can/not be configured in a policy file?**

Can: run list, dependencies, data bags
Can not: roles, environments

**Policy files and Chef Workflow**

They aren't supported by Chef Workflow. :(

## SEARCH 

### BASIC SEARCH USAGE 
Candidates should understand:

**What information is indexed and available for search?**

[Search can be indexed by](https://docs.chef.io/knife_search.html#):
`client`, `node`, `role`, `environment`

**Search operators and query syntax**

Query is `attribute:value_pattern`
[Operators](https://docs.chef.io/knife_search.html#about-operators):
`AND`
`OR`
`NOT`

They are spelled out and must be in all caps

**Wildcards, range and fuzzy matching**




### SEARCH USING KNIFE AND IN A RECIPE
Candidates should understand:
Knife command line search syntax
Recipe search syntax
### FILTERING RESULTS 
Candidates should understand:
How do you filter on Chef Server
Selecting attributes to be returned

## CHEF SOLO 

### WHAT CHEF SOLO IS
Candidates should understand:
Advantages & disadvantages of Chef-solo vs Chef Server
Chef-solo executable and options
Cookbooks, nodes and attributes
Using Data Bags, Roles & Environments
Chef-solo run intervals
Retreiving cookbooks from remote locations
Chef-solo and node object

## DATA BAGS 

### WHAT IS A DATA_BAG
Candidates should understand:

**When might you use a data_bag?**

When you need to share data among multiple cookbooks

**Indexing data_bags**

It's indexed as a json object, so it can have any hierarchy it needs.

**What is a data_bag?**

A key/value nested hash of shared data

**Data_bag and Chef-solo**

With chef solo you need to bring the data bags with you and put them in the `data_bags` folder of your local `chef_repo`


### DATA_BAG ENCRYPTION
Candidates should understand:

**How do you encrypt a data_bag**

Pass in a `--secret-file` when creating the data bag and this file can be used to encrypt/decrypt the data bag

**What is Chef Vault**

A way to encrypt data bags per user key


### USING DATA_BAGS
Candidates should understand:

**How do you create a data_bag?**\

The best way to do it is from a file:

```
knife data bag from file data_bag.json
```

But you could also create it and then edit the contents with an editor.

```
knife data bag create cfc
```

You need to create the data bag before you create the item.

**How can you edit a data_bag**

Set your `EDITOR` environment variable and then run [`knife data bage edit name item`](https://docs.chef.io/knife_data_bag.html#edit)
