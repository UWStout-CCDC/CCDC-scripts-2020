# Install and configure Splunk forwarder

#NOTE: Process is still manual but easier than editing the file now

#TODO:
# - Add script to run on initial setup script
# - Finish automations once IP and Ports are known

# Add any MONITOR_PATH="<directory_path>" ` as needed (the '`' specifies a newline)
# change <directory_path> to the file you want monitored

$username = Read-Host -Prompt 'Enter username for new user to run Splunk Forwarder as'
$password = Read-Host -Prompt 'Enter password for Splunk forwarder user'
$server = Read-Host -Prompt 'Enter Splunk Server IP'
$recievePort = Read-Host -Prompt 'Enter Splunk Server recieving index port'
$deploymentPort = Read-Host -Prompt 'Enter Splunk Server deployment port'

$recieve = $server + ":" + $recievePort
$deployment = $server + ":" + $deploymentPort

#Used for testing inputs
#Write-Host "$username, $password, $server, $recievePort, $deploymentPort, $recieve, $deployment"

msiexec.exe /i splunkforwarder-9.0.3-dd0128b1f8cd-x64-release.msi AGREETOLICENSE=Yes `
LOGON_USERNAME="$username" LOGON_PASSWORD="$password" RECEIVING_INDEXER="$recieve" DEPLOYMENT_SERVER="$deployment" `
WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 ENABLEADMON=1 `
SPLUNKUSERNAME=$username SPLUNKPASSWORD=$password `
MONITOR_PATH="<directory_path>" `
MONITOR_PATH="<directory_path>"