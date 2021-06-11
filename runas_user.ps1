$Username = 'labuser'
$Password = 'labuser'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass