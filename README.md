# Imposter Domain Hunter

Searches for Imposter Domains to log to Perch                                             <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/4a243a29-186e-46e2-b5fd-3581c92b8930/dcxu6pa-5d6745bc-1fc8-4550-bcad-7fdba59e2727.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvNGEyNDNhMjktMTg2ZS00NmUyLWI1ZmQtMzU4MWM5MmI4OTMwXC9kY3h1NnBhLTVkNjc0NWJjLTFmYzgtNDU1MC1iY2FkLTdmZGJhNTllMjcyNy5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.3y58HPfHQio7Dwmyk_N6NRVjpflKeZN4XOS6tB_0TmA" width=200>

The goal of this project is to add OSINT domain imposter threat intelligence to [Perch](https://www.perchsecurity.com) notifications.
A domain imposter is an internet domain name (*ie. google.com*) that has been registered with the purpose of tricking people into thinking that it is another, more reputable domain. For example, *go0gle.com or goog1e.com*

This project makes use of two other projects: [dnstwist](https://github.com/elceef/dnstwist) and [urlcrazy](https://github.com/urbanadventurer/urlcrazy). These apps use _fuzzing_ and other techniques to identify domain names that bad actors would be likely to register in order to impersonate the original company. We utilize docker to run each of them to gain the greatest possible intel.

## Installation
This script is intended to run on Perch sensor machines, but really any Linux will do. This will install docker and run two containers during the collection job, but they are not persistent. It will be up to you to ingest the logs if running on a different system. Non-RH derivatives will need some tweaking as well. The scripts auto-update from this repo weekly via a cron job. 
Simply:
```bash
sudo yum -y install git
git clone https://github.com/tfournet/imp_hunter
cd imp_hunter
sudo sh setup.sh
```
Modify `/opt/imp_hunter/etc/domains.txt` to **include** all of the organization's registered domain names.

Modify `/opt/imp_hunter/etc/domains-ignore.txt` to **exclude** domains from detection and alerting. You may want to do this for alternate domains you may already own, or other false positives.


## TODO
- [X] Automatic updates via cron
- [X] Decide whether it would be better to store known state in a lightweight DB on the sensor and only log changes?
- [ ] Create and Document Perch **Event Notifications** for found events
- [ ] Publish ENs to Perch Marketplace
- [ ] Tweak logging format
- [X] Eliminate duplications between detection projects
- [X] Create any necessary file or folder if it doesn't exist

## FAQ

> Why do I care about imposter domains?

Imposters can be used to communicate with your users/clients/vendors/partners and trick them into a financial transaction, code execution, or other things. Although *technically* those people would be the victims, this can negatively impact you and your relationship with your partners.

> What do I do about imposter domains?

Good question! It may be possible to report them to the abuse address at their registrar. You also may want to warn users, clients, or vendors about the imposter. In some situations, even filing trademark claims against someone may be necessary. This is obviously an important concern to me, so I'd love to hear more ideas. This is a tough battle. 

> Is any of this supported by Perch?

Nope. As of this writing, this is a proof-of-concept project by a motivated user. Perch does not support, condone, or (I hope) condemn using this. Ideally they take the idea and wrap it into the core functionality of their product and make this project obsolete. 

> It doesn't work like I want it to! 

Okay, raise an [Issue](https://github.com/tfournet/imp_hunter/issues) here, or better yet, hit me (**@zaf**) up in the Perch Squawkbox on Slack



