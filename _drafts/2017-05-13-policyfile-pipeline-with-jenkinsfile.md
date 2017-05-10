---
layout: post
title: "Policyfile Pipeline with Jenkinsfile"
date: 2017-05-13T00:00:00+00:00
categories: cafe
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-policyfile-pipeline-with-jenkinsfile
show_related_posts: true
square_related: related-policyfile-pipeline-with-jenkinsfile
permalink: /policyfile-pipeline-with-jenkinsfile/
---
I'm a huge proponent of [policyfiles](/policyfiles/) for managing Chef changes in all of your environments. Let's talk a little about how we take a policyfile and create a pipeline in Jenkins around it to get it deployed to the right places.

For policyfiles, we create a similar process to our cookbooks: 

1. We keep a separate `policies` git repo for each product group of policies that we have. **We don't keep the policyfiles in the cookbook.** This is largely because we want to have our own pipeline for policies that is **unrelated** to the cookbook pipeline. This is a feature not a bug. More on that below.
2. We have a `rakefile` for doing tasks that can be done locally on a developer machine
3. We then put that into a pipeline with a `Jenkinsfile`. 

Let's first look at the `rakefile`:

# Policyfile Rakefile

```ruby
require 'rake/clean'
require 'rake/packagetask'
def product_name
  'myproduct'
end

def policies
  FileList["#{product_name}-*.rb"]
end

def policies_version(build_number)
  "1.#{build_number}.0"
end

def archive_name
  build_number = ENV['BUILD_ID']
  if build_number.nil?
    "#{product_name}_policies.zip"
  else
    "#{product_name}_policies_#{policies_version(build_number)}.zip"
  end
end

task :default => [:compile_policies]

desc "compiles all policies"
task :compile_policies do 
  rm Dir.glob('*.lock.json')
  policies.each do |policyfile|
    sh 'chef', 'install', policyfile
  end
end

directory 'staging'

CLEAN.include('staging')
CLEAN.include('*.zip')

desc "Exports all policies to archives and stages them in the archive folder"
task :export_policies => 'staging' do
  policies.each do |policyfile|
    sh 'chef', 'export', policyfile, 'staging', '-a'
  end
end

require 'os'

task :stage => [:clean, 'staging', :export_policies] do
  cp 'deploy.ps1', 'staging'
  cp 'psake.psm1', 'staging'
  cp 'psake.psd1', 'staging'
  cp 'psake.ps1', 'staging'
end

task :package => [:stage] do
  cd('staging') do
    if OS.windows?
      sh 'C:\Program Files\7-Zip\7z.exe', 'a', '-tzip', archive_name, '*.*', '-x!*.zip'
    else
      sh 'zip', '-r', archive_name, '.', '-x', '*.zip'
    end
  end
end
```

Let's unpack this a little bit. Here's what's going on:

1. **compile_poilcies** will run `chef install` against all files that have the pattern `myproduct-*.rb`. So it basicaly generates the `Policyfile.lock.json` for all the policies in the repo.
2. **export_policies** will export all policies to a `tgz` file with `chef export` command.
3. **stage** will stage all the things that are to be packaged into a `staging` folder
4. **package** will package the `tgz` file and the deployment scripts into a package

# Policyfile Jenkinsfile

Now that we have a rakefile that can do the work we need, now it's time to get that into a `Jenkinsfile` to describe the pipeline. The pipeline will create a package of all policyfile archives and put them, with the script that will deploy them, on our artifactory server. Here's an example:

```groovy
#!/usr/bin/env groovy
def repository = 'myproduct-policies'
def workingDirectory = "policies/${repository}"
// the current branch that is being built
def currentBranch = env.BRANCH_NAME
def execute(command){
  ansiColor('xterm'){
    bat command
  }
}
stage('Checkout') {
  node('windows') {
    checkout([$class: 'GitSCM',
              branches: scm.branches,
              doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
              extensions: scm.extensions + [[$class: 'RelativeTargetDirectory',
                            relativeTargetDir: workingDirectory], [$class: 'LocalBranch', localBranch: currentBranch]],
              userRemoteConfigs: scm.userRemoteConfigs
     ])
    dir(workingDirectory) {
      execute('rake -t clean')
    }
    stash name: 'everything',
          includes: '**'
  }
}
stage('Compile') {
  node('windows') {
    unstash 'everything'
    dir(workingDirectory) {
      execute('rake -t compile_policies')
      try {
        execute('git add *.lock.json')
        execute("git commit -m \"Automatically Compiled Policyfiles\"")
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'abcYOUR_GUID_HERE123', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
          execute("git push http://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@almgit.ncr.com/scm/chef/${repository}.git ${currentBranch}")
        }
      }
      catch(error) {
        echo "Nothing to commit because of error: ${error}, so skipping pushing"
      }
    }
    stash name: 'compiled',
          includes: '**'
  }
}
stage('Package') {
  node('windows') {
    unstash 'compiled'
    dir(workingDirectory) {
      execute('rake -t package')
      archiveArtifacts 'staging/*.zip'
    }
  }
}
stage('Publish') {
  node('windows') {
    unstash 'compiled'
    dir(workingDirectory) {
      execute('jfrog.exe rt upload "staging\\\\*.zip" myproduct-repo/myproduct-policies/')
    }
  }
}

```

Here is a description of all the stages:


| Stage    | Description                                                       |
|----------|-------------------------------------------------------------------|
| Checkout | Checks out the policies repo                                      |
| Compile  | Generates all policyfile.lock.json files and checks them into git |
| Package  | Creates tgz files and zips them up with deployment scripts        |
| Publish  | Publishes this all to artifactory                                 |

You can see a pattern here with the pipelines. They rely on script that can run locally, then end up being deployed to something that is a source of the next step in the process. More on that in the next post: how we deploy these policies to a Chef Server.