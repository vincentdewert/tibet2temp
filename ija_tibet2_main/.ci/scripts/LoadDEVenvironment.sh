#!/bin/bash
#here all the DEV environment variables are stored.
upload_url=https://$upload_host4D/${IBIS}/rest/configs
reload_url="https://$upload_host4D/${IBIS}/adapterHandler.do?action=reload&configurationName=${CONFIG}"
healthCheck_url=https://$upload_host4D/${IBIS}/iaf/api/server/health
#passwords are stored in GitLab
upload_user=$upload_user4DTA
upload_pwd=$upload_pwd4DTA