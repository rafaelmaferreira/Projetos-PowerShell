#Connect to Azure
    #Connect-AzAccount
    Install-PackageProvider -Name NuGet -Force

    Install-Module -Name Az.Storage -Force

    #storage account
    $StorageAccountName = "stokwslab001"
    #storage key
    $StorageAccountKey = "MZuVUdfridctYC6jShkm+Jrw4FanGWlTiDPeqaPGE9dXMhvM33eCy4jx43PeaObUSYt41eAKJ5/a+AStC+6lAg=="
    #container name
    $containerName = "kws"

    #get blob context
    $Ctx = New-AzStorageContext $StorageAccountName -StorageAccountKey $StorageAccountKey
    $ListBlobs = Get-AzStorageBlob -context $Ctx -Container $containerName
    
    #Destination folder - change if different
    $DestinationRootFolder = "C:\7zip\"
    
    #Create destination folder if it doesn't exist
    If(!(test-path $DestinationRootFolder))
    {
          New-Item -ItemType Directory -Force -Path $DestinationRootFolder
    }
    
    #Loop through the files in a container
    foreach($bl in $ListBlobs)
    {
           
        $BlobFullPath = $bl.Name
    
        Write-Host ""
        Write-Host ("File Full Path: " + $BlobFullPath)
        
        #Get blob folder path
        $SourceFolder = $BlobFullPath.Substring( 0, $BlobFullPath.LastIndexOf("/")+1)
        Write-Host ("Source Folder Path: " + $SourceFolder)
    
        #Build destination path based on blob path
        $DestinationFolder = ($DestinationRootFolder + $SourceFolder.Replace("/","\") ).Replace("\\","\")
        Write-Host ("Destination Folder Path: " + $DestinationFolder)
    
        #Create local folders
        New-Item -ItemType Directory -Force -Path $DestinationFolder
              
    
        Write-Host "Blob: " 
        $DestinationFilePath = $DestinationRootFolder + $BlobFullPath.Replace("/", "\")
        Write-Host ("Destination File Path: " + $DestinationFilePath)
    
        #Download file
        Get-AzStorageBlobContent -Container $containerName -Blob $BlobFullPath -Destination $DestinationFilePath -Context $Ctx -Force
    
    }
    
    Write-Host ("")

    Write-Host ("Download completed...")


    Start-Process -NoNewWindow -FilePath C:\7zip\7zip.exe -ArgumentList "/S" -Wait -PassThru