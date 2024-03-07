#!/bin/bash
#here all the PRD environment variables are stored.
upload_url=https://$upload_host4P/${IBIS}/rest/configs
reload_url="https://$upload_host4P/${IBIS}/adapterHandler.do?action=reload&configurationName=${CONFIG}"
healthCheck_url=https://$upload_host4P/${IBIS}/iaf/api/server/health
#passwords are stored in GitLab
upload_user=$upload_user4P
upload_pwd=$upload_pwd4P