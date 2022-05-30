import os
import json

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobClient

from azure.mgmt.testbase import TestBase
from azure.mgmt.testbase.models import PackageResource
from azure.mgmt.testbase.models import TargetOSInfo
from azure.mgmt.testbase.models import Test
from azure.mgmt.testbase.models import Command
from azure.mgmt.testbase.models import GetFileUploadURLParameters

def main():
    # Requesting token from Azure
    print("Requesting token from Azure...")
    # For other authentication approaches, please see: https://pypi.org/project/azure-identity/
    #     Use `credential = AzureCliCredential()` if authenticating via Azure CLI for test
    credential = DefaultAzureCredential()

    # Get environment variables
    # Run `export AZURE_SUBSCRIPTION_ID="<subscription-id>"` on Linux-based OS
    # Run `set AZURE_SUBSCRIPTION_ID=<subscription-id>` on Windows
    subscription_id = os.environ.get("AZURE_SUBSCRIPTION_ID", None)
    resource_group = os.environ.get("RESOURCE_GROUP_NAME", None) 
    testbase_account_name = os.environ.get("TESTBASE_ACCOUNT_NAME", None) 

    application_name = os.environ.get("APPLICATION_NAME", None)
    version = os.environ.get("APPLICATION_VERSION", None)
    oss_to_test = os.environ.get("OSS_TO_TEST", None)
    package_file_path = os.environ.get("PACKAGE_FILE_PATH", None)
    script_path_install = os.environ.get("SCRIPT_PATH_INSTALL", None)
    script_path_launch = os.environ.get("SCRIPT_PATH_LAUNCH", None)
    script_path_close = os.environ.get("SCRIPT_PATH_CLOSE", None)
    script_path_uninstall = os.environ.get("SCRIPT_PATH_UNINSTALL", None)

    # Create client
    testbase_client = TestBase(credential, subscription_id)

    # Create Package
    print("Creating/Updating Package...")
    package_name = "{name}-{version}".format(name=application_name, version = version)

    target_os_info_su = _get_target_os_info(oss_to_test)

    blob_path = _get_package_blob_path(resource_group, testbase_account_name, package_file_path, testbase_client)

    install_command = _create_command("install", "Install", script_path_install, True)
    launch_command = _create_command("launch", "Launch", script_path_launch, False)
    close_command = _create_command("close", "Close", script_path_close, False)
    uninstall_command = _create_command("uninstall", "Uninstall", script_path_uninstall, False)
    
    oob_test = Test(test_type="OutOfBoxTest",
                    commands=[install_command, launch_command, close_command, uninstall_command], is_active=True)

    package_resource = PackageResource(location="Global", tags={}, application_name=application_name,
                                     version=version, target_os_list=[
                                         target_os_info_su],
                                     flighting_ring="", blob_path=blob_path,
                                     tests=[oob_test])
    print(format_json(package_resource))
 
    try:
        operation = testbase_client.packages.begin_create(
            resource_group, testbase_account_name, package_name, package_resource)
        # wait until the async operation completed
        print("Waiting until the async operation completed.")
        operation.wait(600)

        if(operation.status() == 'Succeeded'):
            # return 1 if the package is created/updated successfully.
            print("Package is created/updated successfully.")
            return 0
    except Exception as e:
        print(e)

    print("Failed to create/update the package.")
    return -1

def _get_package_blob_path(resource_group, testbase_account_name, package_file_path, testbase_client):
    file_upload_url_parameters = GetFileUploadURLParameters(
        blob_name="package.zip")
    file_upload_url_response = testbase_client.test_base_accounts.get_file_upload_url(
        resource_group, testbase_account_name, file_upload_url_parameters)
    blob_path = file_upload_url_response.blob_path
    upload_url = file_upload_url_response.upload_url

    storage_blob_client = BlobClient.from_blob_url(upload_url)
    with open(package_file_path, "rb") as data:
        storage_blob_client.upload_blob(data)

    blob_path = upload_url.split(".zip")[0]+".zip"
    return blob_path

def _get_target_os_info(oss_to_test: str):
    target_oss = oss_to_test.split(',')
    target_oss_trim = [os.strip() for os in target_oss]
    return TargetOSInfo(
        os_update_type="Security updates", target_o_ss=target_oss_trim)

def _create_command(name, action, script_path, restart_after):
    return Command(name=name, action=action, content_type="Path",
                                content=script_path,
                                run_elevated=True, restart_after=restart_after,
                                max_run_time=1800, run_as_interactive=True,
                                always_run=True, apply_update_before=False)

def format_json(content):
    return json.dumps(content.serialize(keep_readonly=True), indent=4, separators=(',', ': '))

if __name__ == "__main__":
    exit(main())
