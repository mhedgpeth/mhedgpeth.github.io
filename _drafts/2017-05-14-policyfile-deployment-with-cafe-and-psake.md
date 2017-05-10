---
layout: post
title: "Policyfile Deployment with Cafe and Psake"
date: 2017-05-14T00:00:00+00:00
categories:
  - cafe
  - chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-policyfile-deployment-with-cafe-and-psake
show_related_posts: true
square_related: related-policyfile-deployment-with-cafe-and-psake
permalink: /policyfile-deployment-with-cafe-and-psake/
---
So we have a lot of [cookbook builds](/cookbook-development-with-rakefile/) that make a [pipeline](/cookbook-pipeline-with-jenkinsfile/) into a private supermarket. Then we have separate [policyfile repository pipelines](/policyfile-pipeline-with-jenkinsfile/) grouped by product that have their own pipeline that gets uploaded to an artifactory server. We do this so in a air-gapped environment, we can easily update all the things chef-related and do that within a transactional interaction with the Chef Server and all of its nodes.

This is the part where my project [cafe](/introducing-cafe/) really starts to shine. In this situation where you're rolling out a policy to a Chef Server, you might have a lot of issues; you might have to wait an indeterminate time for chef to run on each node. You may not be able to predict if all the right policies hit the nodes when they run next. It's a very scary moment.

But we can automate that crazy situation and make it a peaceful, good situation. We do that with cafe and [psake](https://github.com/psake/psake) a powershell-based automation mechanism.

Why psake? Within our windows-heavy environment people want to see powershell. So it makes sense for us to orchestrate our deployment of chef changes with a powershell-based mechanism. If I was in a ruby shop I'd probably use rake. Whatever it takes; the main requirements are that it be a staged model where if a stage fails then the execution stops. Pretty much any make-based system will do that.

# Psake Deployment Script with Cafe

So let's jump into our `deploy.ps1` which is our script to deploy all the things to the Chef Server and rerun Chef on all the servers:

```powershell
properties {
  #put properties here like servers
  $servers = @( 'database-server', 'webserver')
  $policy_group = 'qa'
  $product_prefix = 'myproduct'
}
Task default -description "runs a full deployment" `
-depends PauseChef, UpdatePolicies, ConvergeNodes, ResumeChef

Task PauseChef -description "pauses chef across all nodes using cafe" {
  foreach ($server in $servers) {
    exec { Invoke-Expression "C:\cafe\cafe.exe chef pause on: $server" }
  }
}

Task UpdatePolicies -description "Updates the Policies on the Chef Server" {
 foreach ($policyfile in Get-ChildItem -Filter *.tgz) {
    Write-Host "Uploading $policyfile to $policy_group"
    exec { Invoke-Expression "chef push-archive $policy_group $policyfile" }
  }
}

Task ConvergeNodes -description "Runs Chef on all nodes" {
  foreach ($server in $servers) {
    exec { Invoke-Expression "C:\cafe\cafe.exe chef run on: $server" }
  }
}

Task ResumeChef -description "Resumes Chef across all nodes using cafe" {
  foreach ($server in $servers) {
    exec { Invoke-Expression "C:\cafe\cafe.exe chef resume on: $server" }
  }
}
```

I really love how readable and self-documenting this is. So much so, that I don't feel like I have to explain it. What I will say is that pausing chef, running my update, converging, then resuming chef should make every Chef user giddy with excitement. That change point is so scary, that you need safety around it. Cafe brings you that safety, and if you agree I would love your help making cafe everything it should be within the Chef ecosystem.

# Pipeline for Deployment

If you'll remember from our [policyfile pipeline]() post, everything described above is packaged **with** the policyfile archives. So this is the script that runs within the context of those other files. We have **one package**, versioned by jenkins, that we can upload to do an atomic update of everything related to chef, then reconverge the nodes.

So now that we have this file available on our artifacts server, it's time to run a deployment. With an air-gapped environment, the source of these files might be different, or you might get those files to their destination in a variety of ways. However, the basics remain the same from a pipeline perspective: you need to download the file, unzip it, and run the script. Here is an example `Jenkinsfile` that does just this:

```groovy
archiveName = "myproduct_policies_${policiesVersion}.zip"
stage("Download") {
  node("windows") {
    bat 'del /F /Q *.*'
    bat "jfrog.exe rt download myproduct-repo/myproduct-policies/${archiveName} ${archiveName} --flat=true"
    bat "\"C:\\Program Files\\7-Zip\\7z.exe\" x ${archiveName}"
    stash 'everything'
  }
}
def powershell(command){
  ansiColor('xterm'){
    print ("${(char)27}[33m  ${new Date()} Executing :: ${command}")
    bat "powershell.exe -Command \"${command}\""
  }
}
def invoke_psake(){
  powershell(".\\psake.ps1 .\\deploy.ps1")
}
stage("Deploy") {
  node("windows") {
    unstash 'everything'
    invoke_psake()
  }
}
```

It's as simple as that. In Jenkins we make `policiesVersion` a parameter and all of the sudden we have a parameterized build of versioned grouped policies that happen in an ATOMIC update, with immediate node convergence.