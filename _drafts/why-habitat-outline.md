# Habitat Meetup Talk

## Sponsorship - DevOps Days

## Introduction

  - Michael Hedgpeth, NCR
  - Story - developer -> devops
  - Node application needing to deploy
  - Habitat is misunderstood; let's put it in context

## Scripted

The natural choice

**Examples**: copy files, `npm install | node app.js`
**Advantages**: fits the developer workflow
**Disadvantages**: bespoke, difficult to maintain, can fail unexpectely, may only run in production

## Packaged

The natural improvement

**Examples**: XL Deploy, Chocolately, Octopus Deploy
**Advantages**: Simple, Portable, Intuitive
**Disadvantages**: Not holistic

## Configuration Management

The holistic option

**Examples**: Chef, Puppet, Ansible
**Advantages**: Holistic view, Testable, Consistency
**Disadvantages**: QA/Dev rejection; Promise != Workflow (Orchestration)

## Containers

The new thing that WILL SOLVE EVERYTHING!!!!

**Examples**: Docker, Kubernetes, Mesosphere, Open Shift
**Advantages**: Extremely portable, scalable
**Disadvantages**:
  1. Immutable infrastructure difficult to operationalize
  2. Migration of complexity to the scheduler
  3. Full stack included

## Habitat

Promises the best of all of these approaches:
**Advantages**:
1. Scripted in bash
2. Packaged, so portable to QA
3. Holistic, so portable to production as well
4. Packaged with configuration services that can extend into schedulers

Built from the ground up for Continuous Deployment.

**Disadvantages**: 
1. Relatively new, requires slack interaction
2. Not abstracted enough, needs blueprints

## Tour

Go to `~/code/habitat-example-plans/mytutorialapp_finished`

0. Runtime Architecture - supervisor
1. Installation - `hab` executable
2. `plan.sh` - the declaration of an application and its dependencies
  * metadata
  * `pkg_deps` - declared so they can be updated as a part of the build
  * `exports` - to tell other applications about dependencies (where `pkg_binds` is the other side of that)
  * `do_download` and others ignored because our source is in the same repo as the app
  * `do_build` - generates the files that will be used
  * `do_install` - copies those files to a runtime location
3. Configuration
  * `config` folder contains configuration files that you need
  * `default.toml` contains defaults, but those can be overridden per environment
  * configuration changes can be made in real time either by health of other services (through bindings), or by habitat changes
4. Hooks
  * `init` intializes an application for the first time
  * `run` runs an application
  * `health_check` will say whether or not the application is healthy

## Let's run it!

1. go to `~/code/habitat-example-plans/mytutorialapp_finished`
2. run `HAB_DOCKER_OPTS="-p 8080:8080" hab studio enter` - this is a linux vm that will help us isolate our dependencies
3. run `build` to build the application
4. within the sudio (because it's a linux vm) let's run `hab start mh185122/mytutorialapp`
5. Now let's change that message: `HAB_MYTUTORIALAPP='message="Hello Node User Group!"' hab start mh185122/mytutorialapp`

But that's only the beginning:
- I can add a database
- I can update in real time
- I can deploy an application with orchestration

## What's missing?
  * blueprints are going to make building packages easier
  * builder service will allow for zero-day vulnerability
  * depot will allow for CD


## How to get started?

* Go through the tutorial
* Get on the slack
* Add a simple application to habitat
