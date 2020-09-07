#!/bin/bash
set -e
set -o pipefail

# Set Variables
apiToken=$1
title=$2
text=$3
time=$(date +%s000)

if [ -n "$4" ]; then
  domainIds=$4
fi
if [ -z "$4" ]; then
  domainIds=""
fi
# Get API Token SSO
authToken=$(curl -X PUT -H "Content-type: application/json" --data-binary '{"apiToken":"'${apiToken}'"}' \
  "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens" | jq '.["token"]' | tr -d '"')
echo $authToken
# Execute Annotation
if [ "$domainIds" == "" ]; then
   data='{ "title":"'${title}'", "start":'${time}', "text":"'${text}'" }'
fi
if [ "$domainIds" != "" ]; then
   data='{ "title":"'${title}'", "start":'${time}', "text":"'${text}'", "domainIds":"['${domainIds}']" }'
fi
annotation=$(curl -X POST \
     -H "X-Auth-Token: $authToken" \
     -H "Content-type: application/json" \
     --data-binary "$data"\
     "https://mpulse.soasta.com/concerto/mpulse/api/annotations/v1")
echo $annotation
annotation=$(echo $annotation | jq '.["id"]' | tr -d '"')
echo $annotation
if [ "$annotation" == null ]; then
  echo "Failed : Annotation ID was empty" && exit 1;
fi
if [ -n "$annotation" ]; then
  echo "success : $annotation"
  echo $annotation > annotationID.txt
fi
if [ -z "$annotation" ]; then
  echo "Failed : $annotation" && exit 1;
fi
