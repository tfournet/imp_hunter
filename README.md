# Imposter Domain Hunter
Searches for Imposter Domains to log to Perch

The goal of this project is to add OSINT domain imposter threat intelligence to [Perch](https://www.perchsecurity.com) notifications.
A domain imposter is an internet domain name (*ie. google.com*) that has been registered with the purpose of tricking people into thinking that it is another, more reputable domain. For example, *go0gle.com*

This project makes use of two other projects, [dnstwist](https://github.com/elceef/dnstwist) and [urlcrazy](https://github.com/urbanadventurer/urlcrazy). We utilize docker to run each of them to gain the greatest possible intel.

## Installation
This script is intended to run on Perch sensor machines, but really any Linux will do. This will install docker and run two containers during the collection job, but they are not persistent. It will be up to you to ingest the logs if running on a different system. Non-RH derivatives will need some tweaking as well. The scripts auto-update weekly via a cron job. 
Simply:
```bash
yum -y install git
git clone https://github.com/tfournet/imp_hunter
cd imp_hunter
sh setup.sh
```
Modify `/etc/perch/domains.txt` to include all of the organization's registered domain names


## TODO
- [X] AUtomatic updates via cron
- [ ] Create and Document Perch **Event Notifications** for found events
- [ ] Public ENs to Perch Marketplace
- [ ] Tweak logging format
- [ ] Eliminate duplications between detection projects
- [ ] Create /etc/perch if it doesn't exist

## FAQ
What do I do about imposter domains?
> Good question! It may be possible to report them to the abuse address at their registrar. You also may want to warn users, clients, or vendors about the imposter. This is obviously an important convern to me, so I'd love to hear more ideas!
