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
#
#Script to run
$subs = Get-AzSubscription 

Foreach ($sub in $subs) {

    $context = Set-AzContext $sub

    if($action -eq "Start"){

        ## Start the VM
        $vms = Get-AzVM | Where-Object {$_.Tags["ambevtech.start"] -like $horario}
        Foreach ($vm in $vms) {
            Write-Output "Ligando VM: $($vm.Name)"
            $status = Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
            $status.Status
        }
        
    }elseif($action -eq "Stop"){
        ## Stop the VM

        $vms = Get-AzVM | Where-Object {$_.Tags["ambevtech.stop"] -like $horario}
        Foreach ($vm in $vms) {
            Write-Output "Desligando VM: $($vm.Name)"
            $status = Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
            $status.Status
        }
        
        
    }else{
        Write-Output "Ação incorreta!"
    }
}
