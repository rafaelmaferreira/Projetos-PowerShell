$Username = 'rafael@kws.local'
$Password = 'ferreira123*'
[SecureString]$Securepassword = $Password | ConvertTo-SecureString -AsPlainText -Force 
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $Securepassword
Add-Computer –domainname "kws.local" -Credential $credential
Restart-Computer