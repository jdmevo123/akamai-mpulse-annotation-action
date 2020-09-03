#!/bin/bash
set -o pipefail

#  Set Variables
Auth-Token=$1
title=$2
start=$3
text=$3
domainIds=$4

if [ -z "$domainIds" ]; then
   data='{ "title":${title}, "start":${start}, "text":${text} }'
fi
if [ -n "$domainIds" ]; then
   data='{ "title":${title}, "start":${start}, "text":${text}, "domainIds":${domainIds} }'
fi

curl -X POST \
     -H "X-Auth-Token: ${Auth-Token}" \
     -H "Content-type: application/json" \
     --data-binary '$data' \
     https://mpulse.soasta.com/concerto/mpulse/api/annotations/v1 |
     while read line; do
      if [[ $line =~ HTTP ]] ; then
          status=`echo $line | tr -d -c 0-9`
          case $status in
             200) echo "Annotation Successfull" ;;
             *)   echo "$status!!  Annotation Failed: status not defined ... aborting" && exit 123 ;;
          esac
       fi
       if [[ $line =~ "error code" ]] ; then
         echo $line && exit 123
       fi
     done
