#!/bin/bash
#here all the TST environment variables are stored.
upload_url=https://$upload_host4T/${IBIS}/rest/configs
reload_url="https://$upload_host4T/${IBIS}/adapterHandler.do?action=reload&configurationName=${CONFIG}"
healthCheck_url=https://$upload_host4T/${IBIS}/iaf/api/server/health
#passwords are stored in GitLab
upload_user=$upload_user4DTA
upload_pwd=$upload_pwd4DTA