param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$horario,
    [Parameter(Mandatory=$true)]
    [ValidateSet('Start','Stop')]
    [string]$action
 )
#<#
#Authenticate with Azure Automation Run As account (service principal)

Connect-AzAccount -Identity
#>
#Script to run

$subs = Get-AzSubscription

Foreach ($sub in $subs) {
    Set-AzContext $sub

    if($action -eq "Start"){

        ## Start the VM
        Get-AzVM | Where-Object {$_.Tags["start"] -like $horario} | Start-AzVM       

    }elseif($action -eq "Stop"){

        ## Stop the VM
        Get-AzVM | Where-Object {$_.Tags["stop"] -like $horario} | Stop-AzVM -Force       

    }else{
        Write-Output "Ação incorreta!"
    }
}
