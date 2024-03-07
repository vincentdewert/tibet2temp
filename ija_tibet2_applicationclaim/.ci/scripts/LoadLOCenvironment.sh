#!/bin/bash
#here all the TST environment variables are stored.
upload_url=http://localhost:8080/ibis4oma/rest/configs
reload_url="http://localhost:8080/ibis4oma/adapterHandler.do?action=reload&configurationName=testcmis"
healthCheck_url=http://localhost:8080/ibis4oma/iaf/api/server/health
#passwords are stored in GitLab
upload_user=$upload_user4DTA
upload_pwd=$upload_pwd4DTA