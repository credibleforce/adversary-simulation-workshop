invoke-command -ComputerName win19-svr1.lab.lan -UseSSL -Authentication Negotiate -SessionOption (New-PSSessionOption -SkipRevocationCheck) -ScriptBlock {
    iwr -UseBasicParsing "https://github.com/mobia-security-services/adversarysimulationworkshop/raw/main/RDCMan.zip" -OutFile $env:TEMP\RDCMan.zip
    Expand-Archive -Path $env:TEMP\RDCMan.zip -DestinationPath $env:TEMP -Force
    cd $env:TEMP\RDCMan
    Import-Module .\RDCMan.psd1
    Remove-Item ${env:USERPROFILE}\Desktop\RemoteDesktop.rdg -ErrorAction SilentlyContinue
    New-RDCManFile -FilePath ${env:USERPROFILE}\Desktop\RemoteDesktop.rdg -Name RDCMan
    New-RDCManGroup -FilePath ${env:USERPROFILE}\Desktop\RemoteDesktop.rdg -Name RDCMan
    $Username = 'LAB\a-jspringfield'
    $Password = 'PASSWORD'
    $pass = ConvertTo-SecureString -AsPlainText $Password -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass
    New-RDCManServer -FilePath ${env:USERPROFILE}\Desktop\RemoteDesktop.rdg -DisplayName RDCMan -Server 'win19-dc1.lab.lan' -Group RDCMan -Credential $Cred
    Remove-Module $PSScriptRoot\bin\RDCMan.dll -Force -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Path $env:TEMP\RDCMan -Force -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Path $env:TEMP\RDCMan.zip -Force -ErrorAction SilentlyContinue
}