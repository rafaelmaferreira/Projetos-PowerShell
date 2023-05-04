## Ensure you create two (2) different Runbooks: (1) to turn on (2) to turn off, in your Automation Account blade

# This syntax is needed to leverage the newly created managed 'system-assigned' identity

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# Set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

## Start the VM
Get-AzVM | Where-Object {$_.Tags.start -like "9:00"} | Start-AzVM

## Stop the VM
#Get-AzVM | Where-Object {$_.Tags.stop -like "18:00"} | Stop-AzVM
