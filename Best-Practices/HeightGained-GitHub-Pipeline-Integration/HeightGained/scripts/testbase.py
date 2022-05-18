from imghdr import tests
from dotenv import load_dotenv
load_dotenv('../.env')
from azure.identity import AzureCliCredential
from azure.mgmt.testbase.models import OsUpdateType
from azure.mgmt.testbase.models import ExecutionStatus
from azure.mgmt.testbase.models import TestStatus
from azure.mgmt.testbase import TestBase
from datetime import datetime, timedelta
import os

def handle_osupdate_summary(summary) :
    print(summary.build_version+ ':' + summary.test_status)
    if (summary.test_status == TestStatus.TEST_FAILURE or 
        summary.test_status == TestStatus.UPDATE_FAILURE or 
        summary.test_status == TestStatus.TEST_AND_UPDATE_FAILURE or
        summary.test_status == TestStatus.INFRASTRUCTURE_FAILURE ) :
            return -1
    return 0

# check test results in my account. 
# return 0 if there was no failure in the last 24 hours
# return -1 if was a failure in the last 24 hours
def check_testbase_results () :
    # Acquire a credential object using CLI-based authentication.
    credential = AzureCliCredential()
    
    # Retrieve needed info from environment variables.
    subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]
    resource_group = os.environ["RESOURCE_GROUP_NAME"]
    testBaseAccount_name = os.environ["TESTBASE_ACCOUNT_NAME"]


    # Create client to talk to Test Base service
    testBase_client = TestBase(credential, subscription_id)

    # enumerate all test summaries in my account
    summary = testBase_client.test_summaries.list(resource_group, testBaseAccount_name)

    print ()
    atleastOneRunIn24Hours = False
    for item in summary : 

        
        print("Package Id: " + item.application_name + " " +item.execution_status)
        if (item.execution_status is None or item.test_run_time is None) :
            print("No execution status or run time")
            return -1
        # check if this summary is a run within last 24 hours
        lastrun = item.test_run_time[0:item.test_run_time.rindex(".")]        
        yesterday = datetime.today() - timedelta(days = 1)
        if datetime.strptime(lastrun,'%Y-%m-%dT%H:%M:%S') < yesterday :
            continue

        atleastOneRunIn24Hours = True
        print("There is at least one run in the last day")
        if item.execution_status == ExecutionStatus.FAILED :
            print("There was a test failure")
            return -1
        print("Reviewing test execution status")
        if item.execution_status == ExecutionStatus.COMPLETED or item.execution_status == ExecutionStatus.SUCCEEDED :
            print("Feature updates")
            for fuSummary in item.feature_updates_test_summary.os_update_test_summaries :
                if (handle_osupdate_summary(fuSummary)) :
                    return -1
                    
                
            print()
            print("Security updates")
            for suSummary in item.security_updates_test_summary.os_update_test_summaries :            
                if (handle_osupdate_summary(suSummary)) :
                    return -1
    if atleastOneRunIn24Hours == False :
        print("No test run in last 24 hours")
        os.environ["NO_TESTBASE_RUN_IN24Hrs"] = "True"
    return 0

exit(check_testbase_results())