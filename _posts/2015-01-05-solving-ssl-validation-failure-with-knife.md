---
id: 701
title: Solving SSL Validation failure with knife
date: 2015-01-05T08:00:37+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=701
permalink: /solving-ssl-validation-failure-with-knife/
dsq_thread_id:
  - 3377207670
snapFB:
  - 's:159:"a:1:{i:0;a:4:{s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:35:"10152471133176268_10152487232701268";s:5:"pDate";s:19:"2015-01-05 14:03:04";}}";'
snapLI:
  - 's:290:"a:1:{i:0;a:5:{s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:19:"5957868678404984832";s:7:"postURL";s:124:"https://www.linkedin.com/updates?discuss=&amp;scope=16659297&amp;stype=M&amp;topic=5957868678404984832&amp;type=U&amp;a=Wr_h";s:5:"pDate";s:19:"2015-01-05 14:03:04";}}";'
snap_isAutoPosted:
  - 1
snapTW:
  - 's:142:"a:1:{i:0;a:4:{s:11:"isPrePosted";s:1:"1";s:8:"isPosted";s:1:"1";s:4:"pgID";s:18:"552102999191851008";s:5:"pDate";s:19:"2015-01-05 14:03:07";}}";'
categories:
  - insights
tags:
  - chef
  - knife
  - Security
  - Ssl Problem
  - Ssl Validation
  - windows
---
After I moved to a hosted version of the [chef](http://chef.io) server, I started getting this problem with knife:

<pre>knife download environments
ERROR: SSL Validation failure connecting to host: chef.yourdomain.com - SSL_connect returned=1 errno=0 state=SSLv3 read server
certificate B: certificate verify failed
ERROR: OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify
failed

</pre>

There are a couple of ways to fix this. <!--more-->The short-term way is to ignore SSL on your knife.rb file with this setting:

<pre>ssl_verify_mode :verify_none</pre>

The better and more long-term solution is to add this line to the knife.rb file:

<pre><em>trusted_certs_dir        "#{current_dir}/trusted_certs”</em></pre>

And then run:

<pre>knife ssl fetch</pre>

I then had to ignore the trusted_certs file in my git repo.

Thanks to [Matt Stratton](http://www.mattstratton.com/) and his colleagues at [After I moved to a hosted version of the [chef](http://chef.io) server, I started getting this problem with knife:

<pre>knife download environments
ERROR: SSL Validation failure connecting to host: chef.yourdomain.com - SSL_connect returned=1 errno=0 state=SSLv3 read server
certificate B: certificate verify failed
ERROR: OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify
failed

</pre>

There are a couple of ways to fix this. <!--more-->The short-term way is to ignore SSL on your knife.rb file with this setting:

<pre>ssl_verify_mode :verify_none</pre>

The better and more long-term solution is to add this line to the knife.rb file:

<pre><em>trusted_certs_dir        "#{current_dir}/trusted_certs”</em></pre>

And then run:

<pre>knife ssl fetch</pre>

I then had to ignore the trusted_certs file in my git repo.

Thanks to [Matt Stratton](http://www.mattstratton.com/) and his colleagues at](http://chef.io) for helping me find the solution.