# LOCAL COOKBOOK DEVELOPMENT BADGE TOPICS
The Local Cookbook Development badge is awarded when someone proves that they 
understand the process of developing cookbooks locally. Candidates must show:
• An understanding of authoring cookbooks and setting up the local environment.
• An understanding of the Chef DK tools.
• An understanding of Test Kitchen configuration.
• An understanding of the available testing frameworks.
• An understanding of troubleshooting cookbooks.
• An understanding of search and databags.
Here is a detailed breakdown of each area.

## COOKBOOK AUTHORING AND SETUP THEORY 

### REPO STRUCTURE - MONOLITHIC VS SINGLE COOKBOOK

Candidates should understand:
The pros and cons of a single repository per cookbook
The pros and cons of an application repository
How the Chef workflow supports monolithic vs single cookbooks
How to create a repository/workspace on the workstation

### VERSIONING OF COOKBOOKS

Candidates should understand:
Why cookbooks should be versioned
The recommended methods of maintaining versions (e.g. knife spork)
  `knife spork bump alohaupdate`

How to avoid overwriting cookbooks
  by Freezing it with the `knife cookbook upload alohaupdate --freeze` or `berks upload` which freezes
Where to define a cookbook version
  in `metadata.rb`
Semantic versioning
  `MAJOR.MINOR.PATCH` or `BreakingChanges.BackwardsCompatibleChanges.BackwardsCompatibleBugfixes`
Freezing cookbooks
Re-uploading and freezing cookbooks
  Use `knife cookbook upload alohaupdate --force`

### STRUCTURING COOKBOOK CONTENT

Candidates should understand:

Modular content/reusability
Best practices around cookbooks that map 1:1 to a piece of software or functionality vs monolithic cookbooks
How to use common, core resources

### HOW METADATA IS USED

Candidates should understand:

How to manage dependencies
Cookbook dependency version syntax
  inside of `metadata.rb` put `depends 'alohaupdate'` or for a version constraint, `depends 'alohaupdate', '> 2.0'`
  the operators are `=, >=, >, <, <=, and ~>`. That last operator will go up to the next biggest version.
What information to include in a cookbook - author, license, etc

Local Cookbook Development Page 2 v1.0.3
Metadata settings

```ruby
name 'alohaupdate'
maintainer 'Michael Hedgpeth'
maintainer_email 'my@email.com'
source_url 'github.com'
```

What 'suggests' in metadata means
  Same thing as depends, but that you suggest a cookbook be there
What 'issues_url' in metadata means
  The URL to go to the issues, used for supermarket

### WRAPPER COOKBOOK METHODS

Candidates should understand:

How to consume other cookbooks in code via wrapper cookbooks
  Add `depends 'cookbook'` to `metadata.rb` and then either use `include_recipe 'cookbook'` or one of the cookbook's custom resources
How to change cookbook behavior via wrapper cookbooks
  Set the attributes of the cookbook with `node.default['attribute'] = 'overridden_value'` and use `include_recipe`
Attribute value precedence
  [later overrides earlier](https://docs.chef.io/attributes.html):
  Attribute -> Recipe -> Environment -> Role
  Default -> Normal -> Override -> OHAI

  declared in:
  attribute: `default['attribute'] = value`, `normal['attribute'] = value`, `override['attribute'] = value`
  cookbook: `node.default['attribute'] = value`, `node.normal['attribute'] = value`, `node.override['attribute'] = value`
  environment: `default_attributes({ 'attribute' => 'value'})`, `override_attributes({'attribute' => 'value'})`
  role: `default_attributes({ 'attribute' => 'value'})`, `override_attributes({'attribute' => 'value'})`

How to use the `include_recipe` directive
  add `depends 'cookbook_name'` to `metadata.rb` and then add `include_recipe 'cookbook_name::recipe_name'` to a recipe in your runlist
What happens if the same recipe is included multiple times
  only the first inclusion is processed and any subsequent inclusions are ignored.
How to use the 'depends' directive
  see above

### USING COMMUNITY COOKBOOKS

Candidates should understand:

How to use a public and private Supermarket
How to use community cookbooks
How to wrap community cookbooks
How to fork community cookbooks
How to use Berkshelf to download cookbooks
  run `berks install` with a valid `Berksfile`
How to configure a Berksfile
  `source` should point to a supermarket (and the first one gets precedence, so you could use a private then public supermarket)
  always include a `metadata` line to get all the `depends` attributes
  if your cookbook comes from another location than the supermarket, specify it, as in: `cookbook "alohaupdate", git: "http://github.com/mhedgpeth/alohaupdate'"`
How to use a Berksfile to manage a community cookbook and a local cookbook with the 
same name
  By using a private supermarket or specifying the exact location of that cookbook on your private git server, thus making it ignore the supermarket as a default source

### USING CHEF RESOURCES VS ARBITRARY COMMANDS

Candidates should understand:

How to shell out to run commands.
  Use the `shell_out` (when errors don't matter) or `shell_out!` (raises error when command fails)
When/not to shell out
  As read-only, not to change state
How to use the `execute` resource
```
  execute '/usr/sbin/apachectl configtest'
```
When/not to use the 'execute' resource
  When you are changing the state of the system
How to ensure idempotence
  By using notifies or the `not_if`/`only_if` clauses

## CHEF DK TOOLS

### 'CHEF' COMMAND

Candidates should understand:

What the 'chef' command does
What 'chef generate' can  create
How to customize content using 'generators’
The recommended way to create a template
How to add the same boilerplate text to every recipe created by a team
The 'chef gem' command

### FOODCRITIC

Candidates should understand:

What Foodcritic is
  Chef-specific linting of cookbooks
Why developers should lint their code
  Consistency
Foodcritic errors and how to fix them
  They all start with `FC001`, you can google that to get to the exact rule
Community coding rules & custom rules
Foodcritic commands
  Just run `foodcritic .` to do a scan from the cookbook folder. Add `--epic-fail` to make it fail when foodcritic fails.
Foodcritic rules 
How to exclude Foodcritic rules
  For the entire cookbook, add `FC###` to the `.foodcritic` file in the root of the cookbook folder
  For single line of code, add the comment at the end of the line: `# ~FC003`

### BERKS

Candidates should understand:

How to use berks to work with upstream dependencies
  by using the supermarket for dependencies, or by doing version pinning
How to work with GitHub & Supermarket
  in the `Berksfile` you can state the `git:` location or have another supermarket listed as your `source:` (or even multiple ones if you want public to be a backup)
How to work with dependent cookbooks
  Most of the time it works with `metadata.rb` inclusion, but you can extend it with the `cookbook` line (by including further version pinning and overriding location)
How to troubleshoot berks issues **(???)**
How to lock cookbook versions
  cookbooks are frozen by default with a `berks upload`
How to manage dependencies using berks
berks commands
  `berks install` loads dependencies locally
  `berks upload` uploads dependencies to chef server
  `berks info alohaupdate` will display information for that cookbook
  `berks list` will list cookbooks and their dependencies
  `berks apply production Berksfile.lock` - will apply the settings in berksfile to the provided environment

### RUBOCOP

Candidates should understand:

How to use RuboCop to check Ruby styles
  `rubocop .` command from the cookbook folder
RuboCop vs Foodcritic
  Rubocop is for ruby style, Foodcritic is for chef style linting
RuboCop configuration & commands
  `--fail-fast` a good option for CI
Auto correction
  `-a` or `--auto-correct` to auto-correct offenses
How to be selective about the rules you run
  add exclusions to `.rubocop.yml` or inline as `# rubocop:disable RuleName`

### TEST KITCHEN

Candidates should understand:

Writing tests to verify intent
How to focus tests on critical outcomes
How to test each resource component vs how to test for desired outcomes
Regression testing

## TEST KITCHEN 

### DRIVERS

Candidates should understand:

Test Kitchen provider & platform support
  drivers include vagrant (where platforms come from atlas), docker which has built-in image mapping for many platforms, or you can configure the image

How to use .kitchen.yml to set up complex testing matrices
  set up suites, map those to platforms, add a run list and attributes

How to test a cookbook on multiple deployment scenarios
  with suites
How to configure drivers
  with settings under the drivers

### PROVISIONER

Candidates should understand:
The available provisioners
  `chef_zero`, `chef_solo`
How to configure provisioners
```yml
  provisioner: chef_zero
    client_rb: 'alternative-client.rb'
    json_attributes:
      message: Hello!
```
When to use chef-client vs. chef-solo vs. Chef
  for test kitchen, always use `chef_zero`. Use the Chef one if you're needing to use a chef server
How to use the shell provisioner  
  shell provisioner calls `bootstrap.sh` or `bootstrap.ps1`, depending on whether `powershell_shell` is set to true

### SUITES

Candidates should understand:
What a suite is
  A scenario for running a test
How to use suites to test different recipes in different environments
  1) edit their run lists, and 2) define a platform for the suite in the `platforms` setting
Testing directory for InSpec
  by default, this is in the `./test/integration/suite-name` folder
How to configure suites
  they'll have `attributes` under them, etc.

### PLATFORMS

Candidates should understand:

How to specify platforms
  in the `platforms:` section
Common platforms
  `ubuntu-x`, `centos-x`, `debian-x`, `windows`
How to locate base images
  On the bento organization on Atlas: https://atlas.hashicorp.com/bento
Common images and custom images

### KITCHEN COMMANDS

Candidates should understand:

The basic Test Kitchen workflow
  create -> converge -> verify -> destroy
'kitchen' commands
  `kitchen create`
  `kitchen converge`
  `kitchen verify`
  `kitchen test` <- does everything
  `kitchen destroy`
When tests get run
  during converge
How to install bussers **(??)**
What 'kitchen init' does
  creates a `.kitchen.yml` file

## COOKBOOK COMPONENTS 

### DIRECTORY STRUCTURE OF A COOKBOOK

Candidates should understand:

What the components of a cookbook are
What siblings of cookbooks in a repository are
  `roles`, `environments`, `data_bags`
The default recipe & attributes files
Why there is a 'default' subdirectory under 'templates’
  it is the fallback of where to go for templates. Templates can also be platform specific, where the platform would be the directory. Or you can specify the group in the recipe code, which would be configurable
Where tests are stored
  inspec: `tests/integration/default`
  serverspec: `spec` directory

### ATTRIBUTES AND HOW THEY WORK 

Candidates should understand:

What attributes are
Attributes as a nested hash
How attributes are defined
How attributes are named
How attributes are referenced
Attribute precedence levels
  **see above**
What Ohai is
  discovers data about the machine and adds it to the node object
What the 'platform' attribute is
  tells what platform chef is running on
How to use the 'platform' attribute in recipes
  `if node['platform'] == 'ubuntu' ...`

### FILES AND TEMPLATES - DIFFERENCE AND HOW THEY WORK, WHEN TO USE EACH

Candidates should understand:

How to instantiate files on nodes
  using the resources listed below
The difference between 'file', 'cookbook_file', 'remote_file', and 'template'
  `file`: writes a file out directly or sets its attributes
  `cookbook_file`: a file from the cookbook, contents exact
  `remote_file`: a file from the internet or other remote location
  `template`: a file from the cookbook, whose values are configurable by the recipe
How two teams can manage the same file
  if they can share the same cookbok, then by overriding attributes on the same cookbook. Otherwise use partial templates (see below)
How to write templates
```ruby
template '/var/chef/file.txt'
  source 'file.txt.erb'
  variables({
    message: 'Michael was here'
  })
end
```
and in the template:
```
message = <%= message %>
```
What 'partial templates' are
  an ability to separate writing a single file. Uses the `render` method
Common file-related resource actions and properties
ERB syntax
  it's just ruby in between `<% -%>` and when outputting data, it's `<%= %>`

### CUSTOM RESOURCES - HOW THEY ARE STRUCTURED AND WHERE THEY GO
Candidates should understand:
What custom resources are
How to consume resources specified in another cookbook
Naming conventions
How to test custom resources

### LIBRARIES 
Candidates should understand:
What libraries are and when to use them
Where libraries are stored

## AVAILALABLE TESTING FRAMEWORKS 

### INSPEC
Candidates should understand:
How to test common resources with InSpec
InSpec syntax
How to write InSpec tests
How to run InSpec tests
Where InSpec tests are stored

### CHEFSPEC
Candidates should understand:
What ChefSpec is
The ChefSpec value proposition
What happens when you run ChefSpec
ChefSpec syntax
How to write ChefSpec tests
How to run ChefSpec tests
Where ChefSpec tests are stored
Local Cookbook Development Page 6 v1.0.3

### GENERIC TESTING TOPICS
Candidates should understand:
The test-driven development (TDD) workflow
Where tests are stored
How tests are organized in a cookbook
Naming conventions - how Test Kitchen finds tests
Tools to test code "at rest" 
Integration testing tools
Tools to run code and test the output
When to use ChefSpec in the workflow  
When to use Test Kitchen in the workflow
Testing intent
Functional vs unit testing

## TROUBLESHOOTING 

### READING TEST-KITCHEN OUTPUT
Candidates should understand:
Test Kitchen phases and associated output

### COMPILE VS. CONVERGE
Candidates should understand:
What happens during the compile phase of a chef-client run
What happens during the converge phase of a chef-client run
When pure Ruby gets executed
When Chef code gets executed

## SEARCH AND DATABAGS 

### DATA BAGS
Candidates should understand:
What databags are
Where databags are stored
When to use databags
How to use databags
How to create a databag
How to update a databag
How to search databags
Chef Vault
The difference between databags and attributes
What 'knife' commands to use to CRUD databags

### SEARCH
Candidates should understand:
What data is indexed and searchable
Local Cookbook Development Page 7 v1.0.3
Why you would search in a recipe
Search criteria syntax
How to invoke a search from the command line
How to invoke a search from within a recipe