#!/bin/bash
ENV=$1
GITLAB_USER_LOGIN=$2

#load specific environment variables
. .ci/scripts/Load${ENV}environment.sh

echo "Upload job started by: ${GITLAB_USER_LOGIN}"

CURL_UPLOAD_PARAMETERS=$(echo -s -w "HSC_UPLOAD:%{http_code}" -F "file=@target/${IBIS}_${CONFIG}-${REVISION}.jar" -F "realPrincipal=${GITLAB_USER_LOGIN}" -F "realm=jdbc" -F "multiple_configs=false" -F "activate_config=true" -F "automatic_reload=false" ${upload_url} -u ${upload_user}:${upload_pwd} | tr -d '\r')
HTTP_RESPONSE_UPLOAD=$(curl ${CURL_UPLOAD_PARAMETERS})

HTTP_STATUS_CODE_UPLOAD=$(echo $HTTP_RESPONSE_UPLOAD | tr -d '\n' | sed -e 's/.*HSC_UPLOAD://')

echo "Upload ended with HTTP status code: ${HTTP_STATUS_CODE_UPLOAD}"

if [ "${HTTP_STATUS_CODE_UPLOAD}" -eq 200 ] || [ "${HTTP_STATUS_CODE_UPLOAD}" -eq 201 ]; then
   echo "Upload OK"
else
   echo "Upload NOT_OK"
   # exit 1 will fail the job.
   exit 1
fi