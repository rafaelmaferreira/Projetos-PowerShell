

        Install-PackageProvider -Name NuGet -Force

        Install-Module -Name Az.Storage -Force

        #storage account
        $StorageAccountName = "xxx"
        #storage key
        $StorageAccountKey = "xxx"
        #container name
        $containerName = "kws"

        #get blob context
        $Ctx = New-AzStorageContext $StorageAccountName -StorageAccountKey $StorageAccountKey
        $ListBlobs = Get-AzStorageBlob -context $Ctx -Container $containerName
    
        #Destination folder - change if different
        $DestinationRootFolder = "C:\Folder\"
    
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


Start-Process C:\Folder\Installer_UEM_EmpirumAgent\start.bat
Start-Sleep 120

Start-Process C:\Folder\NessusAgent-10.1.4-x64.msi -ArgumentList "/quiet"
Start-Sleep -Seconds 85

Start-Process C:\Folder\check_mk_agent1.6-new-DEFAULT.msi -ArgumentList "/quiet"
Start-Sleep -Seconds 65

Start-Process C:\Folder\FramePkg_KWS_5.7.6.exe 
Start-Sleep -Seconds 65

        Write-Host ("Installation completed...")
        Start-Sleep 10


        $Username = 'xxx'
        $Password = 'xxx'
        [SecureString]$Securepassword = $Password | ConvertTo-SecureString -AsPlainText -Force 
        $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $Securepassword
        Add-Computer –domainname "xxx" -Credential $credential -OUPath "xxx"
        Restart-Computer

        Write-Host ("Process completed...")
        Start-Sleep 15
