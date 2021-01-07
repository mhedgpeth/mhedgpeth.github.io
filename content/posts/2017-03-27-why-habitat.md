---
title: Why Habitat?
date: 2017-03-27T00:00:00+00:00
tags: chef
author: Michael
slug: why-habitat
---
<div class="full-width">
  <img src="/images/feature-finding-habitat.jpg" alt="Why Habitat?" />
</div>

I started my career as a software engineer, and I always love creating a new application and seeing the magic of that application being deployed to production. I love seeing the excitement on our user's faces when we talk about all the cool stuff we're working on. And I love making that *real* for people.

Over the years, I've become increasingly aware of the gulf that exists between making something real on my own machine as a developer and making something real for a user of my software who is experiencing an ROI for my work. That frustration led me to tackle the problem of how to better deploy an application into production. I've found [Habitat](https://www.habitat.sh/) to be a compelling but often misunderstood new option within this space. In this post, I'll describe the pros and cons of other application deployment technologies and then at the end talk about what makes me so excited about Habitat.

Here are the various approaches to application automation, from the simplest to the most complex:

## Scripted

In the past when we created new applications, most of us did an initial demo or deployment by running through a list of items someone needs to do to run an application in an environment that a developer didn't build. There are files to be copied somewhere, commands to run, and validation to ensure that the application is running. In our starting scenario, people do this work manually or with custom built scripts, which become more and more complex over time.

The problem with the "manual" or "scripted" way is that solutions end up being bespoke per application, and thus poorly maintainable. There also isn't a really great way to know whether the script was successful. Many scripting languages will just return a code in the middle, leave the system in an unhealthy state, and just kind of shrug when failures occur.

Also, you usually won't do the scripted way in _all_ environments; just your production environment. This will create unintended surprises that lead to more brittle deployments and longer lead times to get deployments out.

If you're using a manual or bash/powershell scripted way to deploy applications, I highly recommend you consider a better mechanism defined below.

## Packaged

The next obvious solution to this problem of how to get your application in production is to package the application and its files with scripts that will deploy it. This is what we considered when we evaluated [XL Deploy](https://xebialabs.com/products/xl-deploy/). Also, in a windows-only world one could use [Chocolatey](https://chocolatey.org/) for this purpose.

These tools really shine when deployment of a package is relatively simple and isolated. I love and use Chocolatey for third party applications, like installing ChefDK or even chrome on a new machine. The package mechanism also allows you to promote a single package through multiple environments, thus ensuring that you have better quality when you go to production.

The packaged mechanism is almost always a better model than the pure scripted mechanism mentioned above. However, we decided not to go with this way to deploy applications because we wanted a more holistic model for how to manage the _entire_ machine that the application needed.

For example, if we had an IIS machine, it's just as important that IIS is set up properly as it is that the website files exist with a IIS website set up. If we ignore the former, there is no value in the latter.

So for complex applications, I don't recommend using a packaged mechanism for application deployment. I do recommend using the packaged mechanism for third party applications (and on windows, use Chocolatey), but limit its usage to isolated third party applications.

## Configuration Management

Up until recently, if one were to want to take a more holistic approach to application deployment automation, the best choice was to use a configuration management tool like [Chef](https://www.chef.io/).

This has several advantages. First, with Chef you get a holistic machine level environment within which your application will run. So with our IIS example, you get a _configured_ IIS Server there upon which your application will run. You can use [Test Kitchen](/test-kitchen-required-not-optional/) to ensure that the entire machine will run, so you have a much better ability to test that your deployment code works early in the process. And integration testing with other third party applications is natural as well; if you have a problem with running an APM or Security tool with your application, you'll find those problems more easily while using a configuration management approach to application automation, because you'll more naturally be able to include all the machine dependencies into a coded, trackable artifact like a [Policyfile](/policyfiles/).

This is ultimately the path we took two and a half years ago, and I'm glad we did. The holistic approach has proven to be more difficult to execute than a simple scripted or package-based mechanism, but it also gives us consistency, which gives us higher uptime and [ability to scale](/our-superbowl/).

This approach has its drawbacks. First, it has been difficult to get our developers and QA staff to really embrace Chef for _their_ environments. They can't just take a "chef" package and "run" it on a developer or QA machine for feature testing. They probably need an entire separate machine there. And they probably want it to be connected to a Chef Server. All of this overhead makes it difficult or impossible for a developer to want to use the chef deployment mechanism locally. When we get to a shared, stable QA environment or UAT environment, it's fine. But for a QA person trying to test an app on a private local machine, Chef isn't a very good natural choice.

The second drawback to this approach is the distinct difference that exists between a promise-based configuration management system's capabilities and the workflow-oriented approach that exists in a typical deployment. With deployment you're talking about steps, like "first I upgrade the database, then I update the files, then I turn the websites on and add them back to the LB". A "desired state" DSL like Chef, Puppet, or DSC is not a very natural way to express this. We've gotten around it with Chef and can get by, but the unnatural expression of workflow within a promise-based DSL has slowed down our adoption of Chef.

For example, if I'm doing a workflow based deployment, it looks something like this:

```
1. Stop all services
2. Upgrade database
3. Copy files to the right locations
4. Start all services
```

That's relatively simple, and how most people think of an orchestrated deployment. With Chef, however, it becomes quite difficult (and this is only on one machine):

```
1. download the artifact file, notify 2, 3, 4 to run
2. service action: stopped (only if notified)
3. execute script 'upgrade database' (only if notified)
4. copy all files (only if notified)
5. service action: started (every time)
```

If you don't know Chef, you're probably thoroughly confused, and that's the point. Chef is just not very good at executing a workflow like this. You might say that Ansible or Puppet Orchestration are better at it, but the reality is that you're still using a promise language to express a workflow problem. You've found a hammer and now you think everything is a nail. Is there a better way? Perhaps.

## Containers

A lot of people I meet view Docker as a lightweight virtual machine runtime mechanism. They think that Docker's main benefits are faster uptime and lower resource consumption. Recently [Wes Higbee](http://www.weshigbee.com/) helped me understand the true benefits of Docker and how they relate to application deployment automation.

Docker, at the surface, allows you to have the best of both worlds between packaging and configuration management above. You can create a Docker container that _contains_ all of the dependencies that the application needs to run into a container, and then ship that container to run on any linux environment you want. So you now have a single file, that is itself _not_ a script, it's a package that is _immediately_ ready to run.

This changes everything. I no longer have to worry that IIS is set up incorrectly. If I'm using a Docker container for Windows, I can use the `microsoft\iis` image and build on top of it to create a fully encapsulated running application that can run on any Windows Server 2016 host.

On top of that, I get a more lightweight runtime so I can take this image and very rapidly autoscale during peak consumption times. So in the past, I had to spin up a new server, and even if it was fully automated, I would have to wait a few minutes for that to be built. With Docker, I can have that server up in seconds, consuming less resources and therefore operating at a fraction of the cost, and then kill the server when the peak consumption time is over. Usually I'll run a scheduler like [Kubernetes](https://kubernetes.io/), [Open Shift](https://www.openshift.com), or [Mesosphere](https://mesosphere.com/) to "schedule" when machines are going in and out of operations and how upgrades occur.

When you fully grasp what containers can bring to the table for application runtime isolation and scale, it's very easy to get caught up in the excitement of what the future can bring. However, as I think about it more, my excitement has been tempered a bit. Containers are a powerful tool that can do both great good and great harm to your business. Let's consider a few risks:

First, scheduled containers as mentioned above rely on an immutable infrastructure to work. In other words, if you are used to logging into a machine to look at anything, or making any manual changes at all, you're not ready for containers. I often say to people that Packaging/Scripting is like playing Junior Varsity football, Configuration Management is like playing College Football, and Containers are like the NFL. If you're still in JV football, you're not going to get very far with the NFL equivalent. Yes, other companies have done it. But those companies also don't ssh into their servers to make changes. Do you? If so you're not ready for this. Work on becoming more mature in your processes, and then revisit it perhaps.

A second problem with this containers approach, is that you end up isolating the application itself, which is wonderful, but you replace that isolation with an essential _scheduler_ component that is itself complicated and therefore prone to error. In other words, your developer may say "hey, my docker image works, what's the problem?" and at that level there is no problem. But at the scheduler level, there might be an orchestration problem, or runtime problem. You solved your isolation problem, in effect, by replacing it with another tool that few people understand and that developers are likely not going to run themselves. Instead of having the desired effect of making deployment _simpler_, it actually makes deployment more difficult, by introducing a runtime environment that allows little interactivity and troubleshooting.

The final problem I have with containers is the latent issues of including a full stack of linux in the container image itself. I get this warning from [Julian Dunn's blog](http://www.juliandunn.net/2015/12/04/the-oncoming-train-of-enterprise-container-deployments/). Julian has some great points, and if you have time, read his post on the topic. The risk here is that if you include the current version of ubuntu in your docker image, and that version has security vulnerabilities inside of it that are discovered a decade from now, it's going to be difficult to change/update those images. In Docker, an image is immutable, so you need to have a pipeline to build a new image set up if you're doing it right. Which leads to the question: are your Docker images in production built within a continuous delivery pipeline? Are you prepared for that pipeline to be fully functional for the container's lifespan, which could span decades? For most enterprises I've interacted with, it would be a huge step to go from where they are to a fully functional and operational CD pipeline. And on the startup side, do we _really_ trust that they will take the time to deploy docker in an immutable rebuildable way using a minimal image? I think that's wishful thinking.

In short, containers provide a fantastic platform for isolation of our application and for scaling it. But when you try to _operationalize_ the application, the complexity increases to the point that it becomes nearly impossible to pull it off without making serious ommissions that are going to bite you.

Is there a better way? It looks like my friends at Chef have something that is quite intriguing:

## Habitat

Last Summer, [Chef released Habitat](/finding-habitat/) as their application automation platform. Habitat is different in many ways to the previous categories, so much so that it deserves its own category.

With habitat, I can script the build and execution of my application in a way that I would if I were just scripting it from scratch. But, unlike with the typical scripting mechanism, the scripting is _build into the application_ package itself.

So Habitat is a package? Well it's similar to that, yes. Habitat allows you to have a single file that represents the package. So I can provide QA the application and they can run it very quickly. Or as a developer I can run my application locally or on a container very easily. But unlike the packaging mechanisms listed above in the classic model, Habitat will isolate the package's dependencies in order to give me the assurance that my application will run on any environment.

Since I have that packaged deployment mechanism, I no longer need to fit the square peg (application deployment) into a round hole (configuration management). Instead, configuration management can do the things it is good at: making sure the machines on which your applications run are hardened and configured correctly. With the application deployment out of the configuration management code, the complexity drastically reduces and therefore the velocity of adoption drastically increases.

And finally, Habitat will help you operationalize containers with a lot less complexity. It does this in two ways: First inside of its package is a _contract_ with other applications that will help fulfill the real-time configuration needs of a rapidly changing environment. For example, if I'm upgrading an application, I may need that application to be taken out of the load balancer, or I may need for that application to talk to a database. That sounds easy in a classic model where these things may change only occasionally, but in a containerized world, these things change within seconds. Habitat helps you manage the relationships within your applications and therefore allows you to truly operationalize microservices.

It's also easy to take this package and run it as a developer in a simpler model. This is the genius of packaging these services with the app: you no longer have to deal with the complexity of a scheduler, or _something else_ that is there. Developers never like to have to throw the kitchen sink at something to just run something. They want to run something simple and get a production-like result. Habitat is the closest thing I've seen to achieving this goal.

The second thing Habitat does to lower complexity for containers is that it builds an application and all of its dependencies from scratch. This provides the isolation needed to truly make the package portable, but it also provides a declared understanding of _what_ an application's dependencies are. So if there is a vulnerability in one of the dependencies, it's as easy as querying for that dependency, and then easily rebuilding that application with the newer dependency.

With the lower complexity for deploying applications, it's also quite easy to increase the maturity of an application's runtime _without_ having to resort to using Docker and a scheduler. This way an organization can have a more gradual strategy for taking advantage of application isolation and increase the cultural and procedural maturity needed to pull them off safely.

For the reasons laid out in this post, I've become a fan of Habitat in the past six weeks that I've been looking at it. Habitat has a shot at changing the game for application development and delivering on the promise and profitability of Continuous Delivery of our applications. However, there are currently some drawbacks one should be aware of before going down this route. First, Habitat is in its early stages. While I would be fine with putting this into production (in fact I'm days away from doing so), the tooling is not as mature as one experiences with Docker. Therefore, an adopter will need to rely on their fantastic slack channel to get up to speed.

The second negative to Habitat that I'll call out is the learning curve, due to its bash-centric authoring model. There are a few abstractions I miss within Habitat. For example, when I'm telling Habitat where to find the source, I want to just give it the answer (for example, from GitHub). Instead I have to create a shell script to do some things that are not quite straightforward. Also, when I want to build an application, I want to tell it "build a node application from _this_ source directory". Instead I need to copy/paste a bash script I didn't write and change the _right_ things within that script. I'm told by the product team that this will be addressed within an upcoming [blueprints feature](https://github.com/habitat-sh/habitat/issues/1951). When this feature is delivered, I will probably go from cautiously recommending it to wholeheartedly recommending it.

The final negative to Habitat, for the next few weeks hopefully, is that there is little Windows support. Many of our applications rely on Windows to run, so our value of this platform will greatly increase when that is delivered.

## Conclusion

There are many approaches to application deployment automation: Scripting, Packaging, Configuration Management, Containers, and Habitat. Of them all, I believe Habitat has the greatest chance at delivering a scalable, cloud-ready, and operational application deployment mechanism that can truly realize the promise and ROI of DevOps for application developers. I highly encourage those of you interested in this topic to being following the project and contributing with feedback and implementations.

There may be a time in the future where Chef is known more for Habitat and InSpec than for Chef, just as Apple is known more for their iPhone and iPad than their Mac. If the Habitat team delivers on the transformative vision they've laid out, that day will come very soon.
