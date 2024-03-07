#!/bin/bash
ENV=$1

echo "Starting SoapUi test in env: ${ENV}, Projectfile: ${SOAPFILE}"

#Start SoapUi test
testrunner.sh -j -r -PEnv=${ENV} -s"e2e TestSuite" -c"e2e TestCase" ${SOAPFILE}

echo "SoapUi test ended, checking result."
#Check result
if grep -q 'finished with status \[FINISHED\]' soapui.log; then
    echo "Test OK"
else
	echo "Test NOT_OK"
    # exit 1 will fail the job.
	exit 1
fi
