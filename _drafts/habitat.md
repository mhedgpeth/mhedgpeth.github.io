
Approaches to Application Automation:

"Packaging" - like chocolatey, octopus deploy, XL deploy, or even just do a git pull and npm install
  - advantages: portable, simple (no 'tricks')
  - disadvantages: running an application is much more than getting the app files on the machine - what about load balancer, security, etc.?

"Containers" - like docker, but extending into Kubernetes, mesos, etc.
  - advantages: extremely portable, always works
  - disadvantages: complex at scale, another abstraction layer, looming security/maintenance issues

A third way: Habitat
  - a single package to run an app
  - gives you an interface between applications for orchestration
  - can be ported to docker, mesos, kubernetes, etc...or not
  - a 'cooperative ecosystem' approach to microservices - forces rules in a system, and from that allows for easier promotion to production
  - built from the ground up for CD
  - minimal security footprint that is catalogued and therefore quickly avoids zero day 
