#!/bin/bash
set -e
set -o pipefail

# Set Variables
apiToken="4b87edd6-1123-471d-9e77-a8b8991ca9f3"
title="test" #$4
start="1599433542355" #$5
text="TestingAction" #$6
domainIds="" #$7
executionType="" #$8

# # Get API Token
# curl -X PUT -H "Content-type: application/json" --data-binary '{"userName":${userName}, "password":${password}}' \
#   "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens"
# Auth-Token=
# example response = {"token":"da7be4d72030656559f3e41a98924a6b2a544730"}
# curl -X PUT -H "Content-type: application/json" --data-binary '{"apiToken":"'${apiToken}'"}' \
#   "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens" | jq '.["token"]'
# Get API Token SSO
authToken=$(curl -X PUT -H "Content-type: application/json" --data-binary '{"apiToken":"'${apiToken}'"}' \
  "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens" | jq '.["token"]' | tr -d '"')
echo $authToken
# Execute Annotation
if [ -z "$domainIds" ]; then
   data='{ "title":"'${title}'", "start":'${start}', "text":"'${text}'" }'
fi
if [ -n "$domainIds" ]; then
   data='{ "title":"'${title}'", "start":'${start}', "text":"'${text}'", "domainIds":"['${domainIds}']" }'
fi
# echo '{"title":"'$title'","start":'$start',"text":"'$text'"}'
annotationID=$(curl -X POST \
     -H "X-Auth-Token: $authToken" \
     -H "Content-type: application/json" \
     --data-binary "'$data'"\
     "https://mpulse.soasta.com/concerto/mpulse/api/annotations/v1" | jq '.["id"]' | tr -d '"')
if [ "$annotationID" == null ]; then
  echo "Failed : Annotation ID was empty" && exit 1;
fi
if [ -n "$annotationID" ]; then
  echo "success : $annotationID"
  echo $annotationID > annotationID.txt
fi
if [ -z "$annotationID" ]; then
  echo "Failed : $annotationID" && exit 1;
fi
