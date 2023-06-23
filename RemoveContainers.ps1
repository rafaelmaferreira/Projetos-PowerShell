connect-azaccount -TenantId xxx

$SubscriptionId = 'xxx'
$context = Set-AzContext -SubscriptionId $SubscriptionId

# Verifica se o grupo de recursos é "xxx"
$rgName = "ambev-adtsys-rg-br-non-prod"
$rg = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -eq $rgName }

    # Obtenha todas as contas de armazenamento no grupo de recursos
    $StorageAccountName = "xxx"
    $StorageAccount = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName | Where-Object { $_.StorageAccountName -eq $StorageAccountName }
        # Obtenha o contexto da conta de armazenamento
        $Context = $StorageAccount.Context        

        # Obtenha todos os containers com o nome inicial 'bootdiagnostics'
        $Containers = Get-AzStorageContainer -Context $Context | Where-Object { $_.Name -like "bootdiagnostics*" }
        
        Write-Output $Containers.Count

        #Write-Output $Containers.Name

        $Containers | Select-Object Name | Export-Csv -Path C:\Users\BRADT390659\Documents\bootdiag2.csv -NoTypeInformation
        
        foreach ($Container in $Containers) {
            # Remova o container
            $Container | Remove-AzStorageContainer -Force
        }
        
