#!/bin/sh

# Initial version 2020-09-10 by Tim Fournet <tfournet@tfour.net>
# Updated 2020-09-10 by Tim Fournet <tfournet@tfour.net>

domainlist="/etc/perch/domains.txt"
installdir="/opt/imp_hunter"
scriptfile="imp_hunter.sh"

echo"Making sure required packages are installed (docker, bind-utils)"
yum -y install docker bind-utils 

echo "Creating domain list file $domainlist"
touch $domainlist

echo "Setting up Cron Job"
cp -f cron/imp_hunter_daily /etc/cron.daily
chmod a+x /etc/cron.daily/imp_hunter_daily
cp -f cron/update_imp_hunter /etc/cron.weekly
chmod a+x /etc/cron.weekly/update_imp_hunter

mkdir -p $installdir
cp -f sh/$scriptfile $installdir
chmod a+x $installdir/$scriptfile

echo "Initial setup complete. Add domain(s) to monitor to $domainlist and run $installdir/$scriptfile to run manually."
echo "System will automatically scan nightly"

