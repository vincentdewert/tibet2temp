#!/bin/bash
ENV=$1
GITLAB_USER_LOGIN=$2

#load specific environment variables
. .ci/scripts/Load${ENV}environment.sh

echo "HealthCheck started."

CURL_HEALTHCHECK_PARAMETERS=$(echo -s -w "HSC_HEALTHCHECK:%{http_code}" ${healthCheck_url} -u ${upload_user}:${upload_pwd} | tr -d '\r')
HTTP_RESPONSE_HEALTHCHECK=$(curl ${CURL_HEALTHCHECK_PARAMETERS})

HTTP_STATUS_CODE_HEALTHCHECK=$(echo $HTTP_RESPONSE_HEALTHCHECK | tr -d '\n' | sed -e 's/.*HSC_HEALTHCHECK://')

echo "HealthCheck ended with HTTP status code: ${HTTP_STATUS_CODE_HEALTHCHECK}"

if [ "${HTTP_STATUS_CODE_HEALTHCHECK}" -eq 200 ]; then
   echo "HealthCheck OK"
else
   echo "HealthCheck NOT_OK"
   # exit 1 will fail the job.
   exit 1
fi