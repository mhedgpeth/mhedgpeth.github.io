---
layout: post
title: "Chef Artifacts with Artifactory"
date: 2017-05-15T00:00:00+00:00
categories: chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 5
feature_image: feature-artifactory
show_related_posts: true
square_related: related-artifactory
permalink: /artifactory/
---
If you're going to deploy anything, you'll eventually come across a fundamental need: you need somewhere to put your large files. At first, Chef seems like an attractive choice for this, but on deeper inspection it's a horrible path to take. Chef is really great at delivering idempotent scripts to your machines to test and repair. It's not that great of a file server. Storing your files in Chef will make your cookbooks more bloated, your source code repositories more bloated, and cause pain all around.

So it's been a pleasure recently to discover how great artifactory is for a tool for managing artifacts for deployments. Artifactory very naturally and easily lets you get up and running with hosting artifacts in a safe and scalable way. I'd like to lay out a bit of how we use artifactory for those interested in using it for themselves.

# Licensing

First, I _really_ want to give artifactory my money, but there is a budget cycle to fend with, and besides people don't want to spend money unless they can see the value they're getting. So this post will be based on the _free_ version of artifactory. Fortunately, the free version contains what we need; we just need to host artifacts and call it good. Later we can get into the fancypants gem repos, supermarket, artifact expiration features. For now let's ship it!

# Installation

It was quite delightful for me to get artifactory up and running. In evaluation mode I did this with docker:

## Docker

I first just pull the image:

```
docker pull docker.bintray.io/jfrog/artifactory-oss:latest
```

And then run the container:

```
docker run --name artifactory -d -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:latest
```

I then navigate my browser to `http://localhost:8081` and I'm immediately using artifactory. This was an excellent example of [inverted learning](http://www.anniehedgie.com/docker) that Annie loves to talk about.

## Package Installation

For those of us freaked out about running Docker in production, artifactory's package installation is pretty good as well:

```
wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-rpms.repo
sudo mv bintray-jfrog-artifactory-rpms.repo /etc/yum.repos.d/
sudo yum install jfrog-artifactory-oss
```

It's really that easy. They did a fantastic job of making it easy.

# Uploading

Creating and uploading artifacts with artifactory is easy to intuit on their web UI. For CI jobs, we've found that the [`jfrog.exe`](https://www.jfrog.com/confluence/display/CLI/JFrog+CLI) is a really nice way of making uploads easy.

This way [you can store your authentication credentials](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-Configuration) for uploading to artifactory on your build agents in a `~/.jfrog/jfrog-cli.conf` file. This way your usage of the `jfrog.exe` can be very simple:

You can [upload](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-UploadingFiles):
```
jfrog rt u *.tgz product-repo/policyfile-archives
```

And you can [download](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-DownloadingFiles)
```
jfrog rt dl product-repo/policyfile-archives/webserver-3498732hjfkdlsfdahlfewlrhewkl.tgz
```

If you're doing it right, that's about all that you need.

# Access Control

For any automation situation, you want to create access control to the assets of that automation. That way you prevent, at many levels, the situation where your scripts accidentally deploy the same product on all your nodes. If you keep access restricted, you keep things happening the way you'd say they would happen.

Fortunately, artifactory allows for [users to be created](https://www.jfrog.com/confluence/display/RTF/Managing+Users) for this very purpose. So each of your products could have its own artifactory user, which would only be granted access to the repositories you say it should.

# Chef Integration

Fortunately, artifactory provides an http api that works very nicely with the `remote_file` resource:

```ruby
remote_file 'C:\cafe\staging\chef-client-13.0.118-1-x64.msi' do
  source 'https://productuser:mypassw0rd@artifactory.mycompany.com/artifactory/chef-repo/chef-client-13.0.118-1-x64.msi'
  checksum 'c594965648e20a2339d6f33d236b4e3e22b2be6916cceb1b0f338c74378c03da'
end
```

You can [create a module](https://coderanger.net/chef-tips/#3) that will build your url for you and make it even easier:

```ruby
remote_file 'C:\cafe\staging\chef-client-13.0.118-1-x64.msi' do
  extends ::Artifactory::UrlResolver
  source artifactory_url 'chef-repo/chef-client-13.0.118-1-x64.msi'
  checksum 'c594965648e20a2339d6f33d236b4e3e22b2be6916cceb1b0f338c74378c03da'
end
```

Having an https url is great because I can use a lot of third party chef cookbooks that just need a URL.

We have even taken it a step further and developed our own custom resource:

```ruby
artifactory_file 'C:\cafe\staging\chef-client-13.0.118-1-x64.msi' do
  repsoitory_path 'chef-repo/chef-client-13.0.118-1-x64.msi'
  checksum 'c594965648e20a2339d6f33d236b4e3e22b2be6916cceb1b0f338c74378c03da'
end
```

This will automatically determine the artifactory path we use to all of our cookbooks that just want to download a file can be easier to code.

# Checksum Validation

You should be checking checksums on all downloads. Fortunately the `remote_file` resource gives you a built-in way to do this. Simply add the `checksum` attribute to your resource and you have checking. That way if your files are tampered with or not what you expected, you don't go ahead; you stop right there. That's the "limit the damage when things go wrong" principle at work again. This is something I learned well from my security friends.

# Conclusion

Artifactory is a fantastic an essential ally to Chef in your search for DevOps nirvana. I highly recommend it over the other alternatives: Nexus by Sonatype and your own SFTP server. We're extremely happy with this product.
