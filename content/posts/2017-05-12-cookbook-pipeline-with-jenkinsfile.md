---
title: Cookbook Pipeline with Jenkinsfile
date: 2017-05-12T00:00:00+00:00
tags: chef
author: Michael
slug: cookbook-pipeline-with-jenkinsfile
---
<div class="full-width">
  <img src="/images/feature-cookbook-pipeline-with-jenkinsfile.jpg" alt="Pipeline with Jenkinsfile" />
</div>

Now that we have a [local cookbook build](/cookbook-development-with-rakefile/) ready to go, it's time to get that in a CI environment. I have been a fan of [TeamCity](https://www.jetbrains.com/teamcity) and my friends at Chef have a done a great job with [Chef Workflow in Automate](https://docs.chef.io/workflow.html). For us, however, [Jenkins](https://jenkins.io/) is our tool of choice with managing our deployment pipelines, for a few reasons:

1. Jenkins is **free**. We are able to get done what we need inside of the free version, so it's nice that we don't have or need a license or support.
2. Jenkins is **flexible**. We have complicated requirements around security, and Jenkins has been easy to bend to those requirements without requiring a lot of fuss.
3. Jenkins is **friendly to a pipeline mindset**. Compared to TeamCity, Jenkins is much better at laying out a workflow and walking through the various stages of that workflow, defined in a single file.
4. Jenkins is **recommended by expensive consultants**. In a large enterprise that's important. If you go with a tool that the high-powered consultants don't put on a "here's what people are doing" list, you end up fighting an uphill battle. Choose those battles wisely; you'll likely lose them unless you have a *very* compelling use case.

So now that we've decided on Jenkins as our CI of choice, let's talk about how we would implement that.

# Jenkinsfile Example

First, in your cookbook repository in git you would have a `Jenkinsfile`. Ours looks like this (just scroll down if you don't care; it's ok):

```groovy
#!/usr/bin/env groovy
// COOKBOOK BUILD SETTINGS

// name of this cookbook
def cookbook = 'cafe'

// SUPERMARKET SETTINGS
// the branch that should be promoted to supermarket
def stableBranch = 'master'
// the current branch that is being built
def currentBranch = env.BRANCH_NAME

// OTHER (Unchanged)
// the checkout directory for the cookbook; usually not changed
def cookbookDirectory = "cookbooks/${cookbook}"

// Everything below should not change unless you have a good reason :slightly_smiling_face:
def building_pull_request = env.pullRequestId != null

def notify_stash(building_pull_request){
  if(building_pull_request){
    step([$class: 'StashNotifier',
      commitSha1: "${env.sourceCommitHash}"])
  }
}

def execute(command){
  ansiColor('xterm'){
    bat command
  }
}

def rake(command) {
  execute("chef exec rake -t ${command}")
}

def fetch(scm, cookbookDirectory, currentBranch){
  checkout([$class: 'GitSCM',
    branches: scm.branches,
    doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
    extensions: scm.extensions + [
      [$class: 'RelativeTargetDirectory',relativeTargetDir: cookbookDirectory],
      [$class: 'CleanBeforeCheckout'],
      [$class: 'LocalBranch', localBranch: currentBranch]
    ],
    userRemoteConfigs: scm.userRemoteConfigs
  ])
}

stage('Lint') {
  node('windows') {
    notify_stash(building_pull_request)

    echo "cookbook: ${cookbook}"
    echo "current branch: ${currentBranch}"
    echo "checkout directory: ${cookbookDirectory}"
    try{
      fetch(scm, cookbookDirectory, currentBranch)
      dir(cookbookDirectory){
        // clean out any old artifacts from the cookbook directory including the berksfile.lock file
        rake('clean')
      }

     dir(cookbookDirectory) {
        try {
          rake('style')
        }
        finally {
          step([$class: 'CheckStylePublisher',
                canComputeNew: false,
                defaultEncoding: '',
                healthy: '',
                pattern: '**/reports/xml/checkstyle-result.xml',
                unHealthy: ''])
        }
      }
      currentBuild.result = 'SUCCESS'
    }
    catch(err){
      currentBuild.result = 'FAILED'
      notify_stash(building_pull_request)
      throw err
    }
  }
}

stage('Unit Test'){
  node('windows') {
    try {
      fetch(scm, cookbookDirectory, currentBranch)
      dir(cookbookDirectory) {
        rake('test:berks_install')
        rake('test:unit')
        currentBuild.result = 'SUCCESS'
      }
    }
    catch(err){
      currentBuild.result = 'FAILED'
      notify_stash(building_pull_request)
      throw err
    }
    finally {
      junit allowEmptyResults: true, testResults: '**/rspec.xml'
    }
  }
}

stage('Functional (Kitchen)') {
  node('kitchen') {
    try{
      fetch(scm, cookbookDirectory, currentBranch)
      dir(cookbookDirectory) {
        rake('test:kitchen:all')
      }
      currentBuild.result = 'SUCCESS'
    }
    catch(err){
      currentBuild.result = 'FAILED'
    }
    finally {
      notify_stash(building_pull_request)
      dir(cookbookDirectory) {
        rake('test:kitchen:destroy')
      }
    }
  }
}

if (currentBranch == stableBranch){
  lock(cookbook){
    stage ('Promote to Supermarket') {
      node('kitchen'){
        fetch(scm, cookbookDirectory, currentBranch)
        dir(cookbookDirectory) {
          execute "git branch --set-upstream ${currentBranch} origin/${currentBranch}"
          rake('release')
        }
      }
    }
  }
}
```

You can see here that the `Jenkinsfile` is acting more like an integration point to the `rakefile`. That's how we like it; we want as much as possible to be reproducible locally. Then we walk through the stages and do the things. Here is a more detailed explanation of the stages:

| Stage                  | Description                                        |
|------------------------|----------------------------------------------------|
| Lint                   | Checks that the code meets our guidelines          |
| Unit Test              | Runs chef unit tests on the cookbook, if any exist |
| Functional (Kitchen)   | Runs test kitchen against all suites               |
| Promote to Supermarket | Promotes the cookbook to an internal supermarket   |

This provides a very simple way for cookbooks to go from a checkin to the supermarket.

## Setting this up in Jenkins

In Jenkins we create two builds:

1. A [pipeline](https://jenkins.io/doc/book/pipeline/) build that builds off of `master`. Notice that we **don't** use the multi-branch pipeline build at the moment, because we were having quality issues with that feature in Jenkins and wanted to test our pull requests.
2. A [pull request](https://wiki.jenkins-ci.org/display/JENKINS/Stash+pullrequest+builder+plugin) builder that tests pull requests in our local [bitbucket](https://www.atlassian.com/software/bitbucket) server.

The pull requests inside of bitbucket are set to not allow acceptance without a passing build, so this keeps our `master` branch clean and ready to go. Just in case, the `master` build will build everything before sending the cookbook off to the supermarket.

You'll also notice that the `Jenkinsfile` has a lot of `try/catch` logic in it. This is so the `Jenkinsfile` can notify the pull request verifier that a build failed, and that message will show up inside of the pull request. So you get some complexity here, but great benefit with having nice integration with your pull request workflow.

Once pull requests are solid, it's now time to lock down your master branch. Don't let a lot of people commit directly to it; instead have them submit pull requests. This follows the normal open source model that products like Chef use, and you'll find that it works very well.

# Conclusion

With a solid cookbook build in place and a CI process, things start to get regularly tested and quality goes up. I had to be persuaded by my colleagues to go the pull request verifier route, but now that I have, I see what they were trying to tell me: pull requests get tested, master is solid, and your speed of delivery goes up. Maybe one day the Jenkins blue ocean project will catch up to Bitbucket integration, but until then, this works pretty nice for us.

I'd like to also thank and credit my colleagues [John Kerry](http://kerryhouse.net/) and Richard Godbee for leading me in this direction. They spent a ton of time helping me understand how to make a good workflow in Jenkins, and the outline above would not be possible if it weren't for their help.
