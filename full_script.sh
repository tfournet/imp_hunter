#!/bin/sh


domainfile=/etc/perch/domains.txt
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

yum -y install docker bind-utils 

systemctl start docker

if [ ! -f $domainfile ] ; then 
  echo "Error unable to read $domainfile"
  exit 1
fi

cd /tmp

while read -r domain; do

  # Run dnstwist via docker
  docker run elceef/dnstwist $twist_opts $domain > $domain.twist.csv
  while read -r twisteddomain; do
      
    source="dnstwist"
    fuzzer=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $1 }' )
    dom=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $2 }' )
    mx=$( echo $twisteddomain | awk 'BEGIN { FS = "," }; { print $5 }' )
    country=$( echo $crazydomain | awk 'BEGIN { FS = "," }; { print $7 }' )
    if [[ $dom != $domain && $dom != "domain-name" && -n $mx ]] ; then
      echo logger "DOMAIN_IMPOSTER: FoundDomain: $dom | SourceAlgorithm: $source | FuzzerType: $fuzzer | Country: $country  | MX: $mx"
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
    if [[ $dom != "Typo" && -n $mx ]] ; then
      echo logger "DOMAIN_IMPOSTER: FoundDomain: $dom | SourceAlgorithm: $source | FuzzerType: $fuzzer | MX: $mx"
    fi

  done < $domain.crazy.csv
  rm -f $domain.crazy.csv 

done < $domainfile

