#!/bin/bash
ENV=$1
GITLAB_USER_LOGIN=$2

#load specific environment variables
. .ci/scripts/Load${ENV}environment.sh

echo "Reload config started by: ${GITLAB_USER_LOGIN}"

CURL_RELOAD_PARAMETERS=$(echo -s -w "HSC_RELOAD:%{http_code}" ${reload_url} -u ${upload_user}:${upload_pwd} | tr -d '\r')
HTTP_RESPONSE_RELOAD=$(curl ${CURL_RELOAD_PARAMETERS})

HTTP_STATUS_CODE_RELOAD=$(echo $HTTP_RESPONSE_RELOAD | tr -d '\n' | sed -e 's/.*HSC_RELOAD://')

echo "Reload ended with HTTP status code: ${HTTP_STATUS_CODE_RELOAD}"

if [ "${HTTP_STATUS_CODE_RELOAD}" -eq 302 ]; then
   echo "Reload OK"
else
   echo "Reload NOT_OK"
   # exit 1 will fail the job.
   exit 1
fi