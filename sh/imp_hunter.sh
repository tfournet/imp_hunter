#!/bin/sh

basedir=/opt/imp_hunter
dbdir=$basedir/var
confdir=$basedir/etc

domainfile=$confdir/domains.txt
ignorefile=$confdir/domains-ignore.txt

# Get network interface to use for talking to myself so Perch picks up the data
iface=$(route -n | grep ^0.0.0.0 | awk '{ print $8 }')
ip=$(ip -4 address show $iface | grep inet | awk '{print $2}' | cut -f1 -d\/)

if [ ! -d $dbdir ]; then mkdir -p $dbdir; fi

twist_opts=" \
  --dictionary dictionaries/english.dict \
  --tld dictionaries/common_tlds.dict \
  --geoip \
  --format csv \
  --registered \
  "

urlcrazy_opts=" \
  --format=CSV \
  "
 
log_cmd="logger -n $ip -t 'imp_hunter'"

systemctl status docker >/dev/null || systemctl start docker

if [ ! -f $domainfile ] ; then 
  echo "Error unable to read $domainfile"
  exit 1
fi

cd /tmp

while read -r domain; do

  foundfile=$dbdir/$domain.found
 
  lastfoundfile=$foundfile.lastrun
  if [[ -f $foundfile ]]; then
    mv -f $foundfile $lastfoundfile
  fi; 
  touch $foundfile
  touch $lastfoundfile
  
  # Run dnstwist via docker
  docker run elceef/dnstwist $twist_opts $domain > $domain.twist.csv
  while read -r twisteddomain; do
      
    source="dnstwist"
    fuzzer=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $1 }' )
    dom=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $2 }' )
    mx=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $5 }' )
    country=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $7 }' )
    #if [[ $dom != $domain && $dom != "domain-name" && -n $mx ]] ; then echo $dom ; fi
    if [[ $dom != $domain && $dom != "domain-name" && -n $mx && ! $(grep -qi $dom $ignorefile) ]]; then
      #$log_cmd "DOMAIN_IMPOSTER: FoundDomain: $dom | SourceAlgorithm: $source | FuzzerType: $fuzzer | Country: $country  | MX: $mx"
      echo $dom >> $foundfile
    fi

  done < $domain.twist.csv
  rm -f $domain.twist.csv

  # Run urlcrazy via docker
  docker run jamesmstone/urlcrazy $urlcrazy_opts $domain >> $domain.crazy.csv
  while read -r crazydomain; do

    source="urlcrazy"
    fuzzer=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $1 }' )
    dom=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $2 }' )
    mx=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $5 }' )
    #country=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $6 }' )
    
    if [[ $dom != "Typo" && -n $mx && $(grep -qv $dom $ignorefile) && ! $(grep -qi $dom $ignorefile) ]]; then
      #$log_cmd "DOMAIN_IMPOSTER: FoundDomain: $dom | SourceAlgorithm: $source | FuzzerType: $fuzzer | MX: $mx"
      echo $dom >> $foundfile
    fi

  done < $domain.crazy.csv
  rm -f $domain.crazy.csv 
  
  while read -r founddomain; do
    if [[ ! $(grep -qi $founddomain $lastfoundfile) ]]; then
      alertmsg="{ \"logsource\": \"imp-hunter\", \"notification\": \"New Domain Imposter Found\", \"domain\": \"$founddomain\" }"
      #ALERT: New Domain Imposter Found: $founddomain"
      $log_cmd $alertmsg
    fi
  done < $foundfile

done < $domainfile






