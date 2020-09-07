#!/bin/bash
set -e
set -o pipefail

# Set Variables
apiToken="4b87edd6-1123-471d-9e77-a8b8991ca9f3" #$1
title="test" #$2
time="1599439052853" #$3
text="TestingAction" #$4
domainIds="" #$5
annotationID="" #$6

# Get API Token SSO
authToken=$(curl -X PUT -H "Content-type: application/json" --data-binary '{"apiToken":"'${apiToken}'"}' \
  "https://mpulse.soasta.com/concerto/services/rest/RepositoryService/v1/Tokens" | jq '.["token"]' | tr -d '"')
echo $authToken
if [ "$annotationID" == "" ]; then
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
fi

# Execute append Annotation with end time
if [ "annotationID" != "" ]; then
    # Execute Annotation Update
    data='{ "end":'${time}' }'
    ammend=$(curl -X POST \
         -H "X-Auth-Token: $authToken" \
         -H "Content-type: application/json" \
         --data-binary "$data"\
         "https://mpulse.soasta.com/concerto/mpulse/api/annotations/v1/$annotationID")
    echo $ammend
    ammend=$(echo $ammend | jq '.["id"]' | tr -d '"')
    echo $ammend
    if [ "$ammend" == null ]; then
      echo "Failed : Annotation ID was empty" && exit 1;
    fi
    if [ "$ammend" == "$annotationID" ]; then
      echo "success : $ammend"
      echo "Annotation ID updated with end time"
    fi
    if [ -z "$ammend" ]; then
      echo "Failed : $ammend" && exit 1;
    fi
fi
