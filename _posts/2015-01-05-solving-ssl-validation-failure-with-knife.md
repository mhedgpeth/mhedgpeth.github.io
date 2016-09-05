---
id: 701
layout: post
title: Solving SSL Validation failure with knife
date: 2015-01-05T08:00:37+00:00
categories: 
  - automation
  - chef
author_name: Michael
author_url: /author/michael
author_avatar: michael
show_avatar: false
read_time: 10
feature_image: feature-solving-ssl-validation-failure-with-knife 
show_related_posts: true 
guid: http://hedge-ops.com/?p=701
permalink: /solving-ssl-validation-failure-with-knife/
dsq_thread_id:
  - 3377207670
tags:
  - chef
  - knife
  - Security
  - Ssl Problem
  - Ssl Validation
  - windows
---
After I moved to a hosted version of the [chef](http://chef.io) server, I started getting this problem with knife:

```
knife download environments
ERROR: SSL Validation failure connecting to host: chef.yourdomain.com - SSL_connect returned=1 errno=0 state=SSLv3 read server
certificate B: certificate verify failed
ERROR: OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify
failed
```

There are a couple of ways to fix this. <!--more-->The short-term way is to ignore SSL on your knife.rb file with this setting:

```ruby
ssl_verify_mode :verify_none
```

The better and more long-term solution is to add this line to the knife.rb file:

```ruby
trusted_certs_dir        "#{current_dir}/trusted_certs"
```

And then run:

```bash
knife ssl fetch
```

I then had to ignore the trusted_certs file in my git repo.

Thanks to [Matt Stratton](http://www.mattstratton.com/) and his colleagues at [chef](http://chef.io) for helping me find the solution.