---
title: Cookbook Development with Rakefiles
date: 2017-05-11T00:00:00+00:00
tags: chef
author: Michael
slug: cookbook-development-with-rakefile
---
<div class="full-width">
  <img src="/images/feature-cookbook-development-with-rakefile.jpg" alt="Cookbook Development Rakefile" />
</div>

When we [started Chef](/my-advice-for-chef-in-large-corporations/), we had a loose set of rules for everyone to follow and sent them on their way. We quickly realized, however, that we needed to standardize how a cookbook met quality standards before it got released. We would try to make a simple change to a cookbook and it didn't meet our coding standards. Or they forgot to [introduce kitchen](/test-kitchen-required-not-optional/). Or they remembered but they didn't do anything when their kitchen broke three weeks ago. It was chaos.

Essentially our cookbooks are like any other code product: they need a build process, automated testing, and a way to release them to the outside world. Without that, you'll have chaos and doom.

The best way I know of to do this is with `rake` (see [this example](https://github.com/mhedgpeth/cafe-cookbook/blob/master/Rakefile) on my `cafe` cookbook).

`rake` has several advantages:

1. It's all in one file, using a common framework that other Ruby developers use
2. It easily integrates within a chef environment using the `chef exec` commands
3. It integrates well into any existing pipeline or CI server

Its one disadvantage is that it can be difficult for non-ruby developers to understand, *however*, the benefits above far outweighs this advantage. We've found that with the simple `rakefile` below, most people don't even have to touch their rakefile and can just use it.

We use the same `rakefile` for every cookbook, located in the base folder of the cookbook in a dedicated git repository for that cookbook. Here's an example:

```ruby
task default: [:clean, :style, :test]
desc 'Removes any policy lock files present, berks lockfile, etc.'
task :clean do
  %w(
    Berksfile.lock
    .bundle
    .cache
    coverage
    Gemfile.lock
    .kitchen
    metadata.json
    vendor
    policies/*.lock.json
    commit.txt
    rspec.xml
  ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
end
desc 'Run foodcritic and cookstyle on this cookbook'

task style: 'style:all'
namespace :style do
  # Cookstyle
  begin
    require 'cookstyle'
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new(:cookstyle) do |task|
      # If we are in CI mode then add formatter options
      task.options.concat %w(
        --require rubocop/formatter/checkstyle_formatter
        --format RuboCop::Formatter::CheckstyleFormatter
        -o reports/xml/checkstyle-result.xml
      ) if ENV['CI']
    end
  rescue
    puts ">>> Gem load error: #{e}, omitting style:cookstyle" unless ENV['CI']
  end
  # Load foodcritic
  begin
    require 'foodcritic'
    desc 'Run foodcritic style checks'
    FoodCritic::Rake::LintTask.new(:foodcritic) do |task|
      task.options = {
        fail_tags: ['any'],
        progress: true,
      }
    end
  rescue LoadError
    puts ">>> Gem load error: #{e}, omitting style:foodcritic" unless ENV['CI']
  end
  task all: [:cookstyle, :foodcritic]
end

desc 'Run unit and functional tests'
task test: 'test:all'
namespace :test do
  begin
    require 'rspec/core/rake_task'
    desc 'Run ChefSpec unit tests'
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.rspec_opts = ENV['CI'] ? '--format RspecJunitFormatter --out rspec.xml' : '--color --format progress'
      t.pattern = 'test/unit/**{,/*/**}/*_spec.rb'
    end
  rescue
    puts ">>> Gem load error: #{e}, omitting tests:unit" unless ENV['CI']
  end

  begin
    require 'kitchen/rake_tasks'
    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
  rescue StandardError => e
    puts ">>> Kitchen error: #{e}, omitting #{task.name}" unless ENV['CI']
  end
  namespace :kitchen do
    desc 'Destroys all active kitchen resources'
    task :destroy do
      sh 'kitchen destroy'
    end
  end

  task all: ['test:unit', 'test:kitchen:all']
end

desc 'bumps the patch version and releases the cookbook to the supermarket'
task release: 'release:all'
namespace :release do
  begin
    require 'bump'
    require 'bump/tasks'
    desc 'tags and pushes a patch change'
    task tag: ['release:bump:patch'] do
      sh 'git pull'
      sh 'git push'
    end
  rescue
    puts ">>> Gem load error: #{e}, omitting release:bump*" unless ENV['CI']
  end

  begin
    require 'stove/rake_task'
    Stove::RakeTask.new

  rescue
    puts ">>> Gem load error: #{e}, omitting operational:tag" unless ENV['CI']
  end

  task all: ['release:tag', 'release:publish']
end
```

As I've said before, you don't really need to be able to understand every line of this `rakefile` in order to make good use of it. So let's get up to speed on that part:

## Setup

Before running the `rakefile` you'll need to set up some gems:

```
chef gem install stove bump
```

These gems are used for uploading to a supermarket and bumping a version, respectively. More on that below.

## Running Locally

| Function | Description                               | Command                 |
|----------|-------------------------------------------|-------------------------|
| Lint     | Ensures that code meets standards         | chef exec rake -t style |
| Test     | Ensures that code runs and is ready to go | chef exec rake -t test  |

We run our `rake` within the chef ruby environment, so we prepend it with `chef exec` which says "run this with chef's built-in ruby". That makes everything much more consistent and easy, especially considering we're using cookstyle and kitchen gems here.

To run your linting, just run `chef exec rake -t style`. This will run **both** [cookstyle](https://github.com/chef/cookstyle) and [foodcritic](http://www.foodcritic.io/) on your cookbooks. We've found both linting tools to be helpful. Cookstyle is an more sane wrapper around rubocop.

Another great pro tip on using `cookstyle` is that you can automatically fix easy to fix errors by running `cookstyle -a`. That saves a ton of time.

Once you get past the linting phase, you can run unit tests and kitchen with `chef exec rake -t test`. We consider [test kitchen](http://kitchen.ci/) to be an [absolutely critical](/test-kitchen-required-not-optional/) aspect of our coding process. Would you ever write code that you never ran before deploying it somewhere? If you're not using test kitchen, that's exactly what you're doing!

This `rakefile` will also allow you to bump your versions automatically (`release:bump:patch`) and upload to a supermarket (`release:publish`). You'll need the `stove` and `bump` gems installed with `chef gem install stove bump`. Also you'll need to add a `.stove` file to house the configuration of how to talk to the supermarket, with these contents:

```json
{
  "username": "yourusernametosupermarket",
  "key": "C:/Users/yourusername/.chef/yourusername.pem",
  "no-git": "true",
  "endpoint": "https://supermarket.yourcompany.com"
}
```

The bump and publish targets should be reserved for your CI agent most of the time.

## Running with CI

When you run this with a CI server, you'll need set the `CI` environment variable to `true` so your tests will report the "CI" way. Then simply run the targets as you need. I'll have a version of our `Jenkinsfile` in the next post.

## Why not Delivery though?

My friend Matt Stratton [suggests](https://www.mattstratton.com/post/getting-started-with-chef/) using Chef Delivery cookbooks to do this same thing. We didn't go in this direction for a few reasons:

1. **Ignorance**: we don't know delivery very well and there isn't a community around it that can get a local build up and running quickly. Most of delivery seems to be centered around getting Chef Workflow to work, which is not something we had plans to do.
2. **Training**: more people know rake than know delivery. So rake is the easier option
3. **Simplicity**: while rake does leave you a bit confused as to the particulars of what you're doing, it's all in one file and can be easily run. The delivery stuff is in a hierarchy of folders and therefore takes more to understand.

# Conclusion

Having a local cookbook build that is standard in all of our projects has become essential to our implementation of Chef at scale. I think the `Rakefile` I use above is an excellent choice for standardizing in a way that is both flexible and simple.
