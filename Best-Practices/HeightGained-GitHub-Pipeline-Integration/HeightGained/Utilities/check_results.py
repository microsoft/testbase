# --------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for
# license information.
# --------------------------------------------------------------------------

from azure.identity import DefaultAzureCredential
from azure.mgmt.testbase.models import ExecutionStatus
from azure.mgmt.testbase.models import TestStatus
from azure.mgmt.testbase.models import TestSummaryListResult
from azure.mgmt.testbase import TestBase
from datetime import datetime, timedelta, timezone
import os

test_result_format = """
\tpackage_name:\t{application_name}
\tversion:\t{application_version}
\ttestType:\t{test_type}
\tstatus:\t\t{test_status}
\trunTime:\t{test_run_time}
\tosName:\t\t{os_name}
\tupdateType:\t{update_type}
\trelease:\t{release_name}
\tversion:\t{build_version}
"""

# check test results in my account.
# return 0 if there was no failure in the last 24 hours
# return -1 if there was a failure in the last 24 hours


def check_testbase_results():
    # Requesting token from Azure
    print("Requesting token from Azure...")
    # For other authentication approaches, please see: https://pypi.org/project/azure-identity/
    #     Use `credential = AzureCliCredential()` if authenticating via Azure CLI for test
    credential = DefaultAzureCredential()

    # Retrieve needed info from environment variables.
    subscription_id = os.environ.get("AZURE_SUBSCRIPTION_ID", None)
    resource_group = os.environ.get("RESOURCE_GROUP_NAME", None)
    testBaseAccount_name = os.environ.get("TESTBASE_ACCOUNT_NAME", None)

    # Create client to talk to Test Base service
    testBase_client = TestBase(credential, subscription_id)

    # enumerate all test summaries in my account
    summary = testBase_client.test_summaries.list(
        resource_group, testBaseAccount_name)

    print()
    at_least_one_run_in_24h = False
    failure_tests = []
    for item in summary:
        print("Package: " + item.application_name + "-" +
              item.application_version + " " + item.execution_status)
        if (item.execution_status is None or item.test_run_time is None):
            print("No execution status or run time")
            return -1

        # check if this summary is a run within last 24 hours
        lastrun = _parse_time(item.test_run_time)
        print("Last Run time:", lastrun)
        yesterday = datetime.now(timezone.utc) - timedelta(days=1)
        if lastrun < yesterday:
            continue

        at_least_one_run_in_24h = True
        print("There is at least one run in the last day")

        if _is_failure(item.test_status):
            if item.feature_updates_test_summary is not None:
                for fuSummary in item.feature_updates_test_summary.os_update_test_summaries:
                    if (_is_failure(fuSummary.test_status) and _parse_time(fuSummary.test_run_time) > yesterday):
                        # failure in last 24 hours
                        failure_tests.append(test_result_format.format(
                            application_name=item.application_name,
                            application_version=item.application_version,
                            test_type=fuSummary.test_type,
                            test_status=fuSummary.test_status,
                            test_run_time=fuSummary.test_run_time,
                            os_name=fuSummary.os_name,
                            update_type="Feature update",
                            release_name=fuSummary.release_name,
                            build_version=fuSummary.build_version))

            if item.security_updates_test_summary is not None:
                for suSummary in item.security_updates_test_summary.os_update_test_summaries:
                    if (_is_failure(suSummary.test_status) and _parse_time(suSummary.test_run_time) > yesterday):
                        # failure in last 24 hours
                        failure_tests.append(test_result_format.format(
                            application_name=item.application_name,
                            application_version=item.application_version,
                            test_type=suSummary.test_type,
                            test_status=suSummary.test_status,
                            test_run_time=suSummary.test_run_time,
                            os_name=suSummary.os_name,
                            update_type="Security update",
                            release_name=suSummary.release_name,
                            build_version=suSummary.build_version))

    if at_least_one_run_in_24h == False:
        print("No test run in last 24 hours")
        os.environ["NO_TESTBASE_RUN_IN24Hrs"] = "True"

    if len(failure_tests) > 0:
        print(len(failure_tests), "failed test in last 24 hours")
        for test in failure_tests:
            print(test)
        return -1
    else:
        return 0


def _parse_time(time_string: str):
    return datetime.strptime(time_string[:26] + " +0000", '%Y-%m-%dT%H:%M:%S.%f %z')


def _is_failure(test_status: TestStatus):
    if (test_status == TestStatus.TEST_FAILURE or
        test_status == TestStatus.UPDATE_FAILURE or
        test_status == TestStatus.TEST_AND_UPDATE_FAILURE or
            test_status == TestStatus.INFRASTRUCTURE_FAILURE):
        return True
    return False


exit(check_testbase_results())
