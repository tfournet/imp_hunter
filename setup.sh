#!/bin/sh

# Initial version 2020-09-10 by Tim Fournet <tfournet@tfour.net>
# Updated 2020-09-10 by Tim Fournet <tfournet@tfour.net>

basedir=/opt/imp_hunter
dbdir=$basedir/var
confdir=$basedir/etc

domainfile=$confdir/domains.txt
ignorefile=$confdir/domains-ignore.txt
foundfile=$dbdir/found-domains.txt

clear


echo "Making sure required packages are installed (docker, bind-utils)"
which docker || yum -y install docker 
which dig    || yum -y install bind-utils 


echo "Creating Blank Config Files"
if [[ ! -d $basedir ]]; then mkdir -p $basedir; fi
if [[ ! -d $dbdir ]];   then mkdir -p $dbdir;   fi
if [[ ! -d $confdir ]]; then mkdir -p $confdir; fi

if [[ ! -f $ignorefile ]] ; then touch $ignorefile; fi
if [[ ! -f $domainfile ]] ; then touch $domainfile; fi


echo "Installing Scripts"
installdir="/opt/imp_hunter"
scriptfile="imp_hunter.sh"
updatescript="update_imp_hunter.sh"

mkdir -p $installdir
cp -f sh/$scriptfile $installdir
chmod a+x $installdir/$scriptfile

cp -f sh/$updatescript $installdir
chmod a+x $installdir/$updatescript


echo "Setting up Cron Job"
ln -s $installdir/$scriptfile /etc/cron.daily
ln -s $installdir/$updatescript /etc/cron.weekly


echo "Initial setup complete. Add domain(s) to monitor to $domainfile and run $installdir/$scriptfile to run manually."
echo "Add domains you wish to ignore to $ignorefile"
echo "System will automatically scan nightly"

