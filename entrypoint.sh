#!/bin/bash
set -o pipefail

# Set Variables
userName=$1
password=$2
apiToken=$3
title=$4
start=$5
text=$6
domainIds=$7

# # Get API Token
# curl -X PUT -H "Content-type: application/json" --data-binary '{"userName":${userName}, "password":${password}}' \
#   "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens"
# Auth-Token=
# example response = {"token":"da7be4d72030656559f3e41a98924a6b2a544730"}

# Get API Token SSO
curl -X PUT -H "Content-type: application/json" --data-binary '{"apiToken":${apiToken}}' \
  "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens"
Auth-Token=

# Execute Annotation
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
