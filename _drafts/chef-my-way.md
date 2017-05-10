
I would like to lay out the way that I've learned to implement Chef as a reference for my colleagues and others in the industry to apply some best practices to their Chef implementation. It turns out that there is a lot to learn when doing Chef the right way; I hope that you'll be able to read through this and learn a thing or two about how you might do Chef.

(/) Cookbook coded
(/) Linted with cookstyle
Runs Kitchen with InSpec
(/) Pipeline to internal supermarket
(/) Good process for review:
  * Pull Requests Tested
  * master locked down
(/) Policyfile pipeline to nexus

InSpec Profile Pipeline to Automate
Databag versions and pipeline (chef not bound to application version)
Clean node object
  * Secrets not in the node
  * Minimal reportable node
  * using ohai plugins where it makes sense
Artifacts stored in Nexus
(/) Cafe Schedules Chef
(/) Orchestration
Rollback Process Defined
Private QA deployment (habitat)
(/) Jenkins deployment to environment
Regular health/inspec scanning
Cross-cutting concerns dealt with (zabbix, cloud passage, dynatrace)
Using Automate
Log management (ELK)
Dynamic secrets
communications model (internal and external)
Zero downtime changes
Blue/Green deployment
External uptime testing
Extensible through microservices
Cloud deployable