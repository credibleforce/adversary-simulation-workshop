invoke-command -ComputerName win10-dsk1.lab.lan -UseSSL -Authentication Negotiate -ScriptBlock {
    New-Service -Name "nCentral" -BinaryPathName '"C:\Program Files\nCentral\nCentral.exe"' -ErrorAction SilentlyContinue
    New-Item -ItemType Directory 'C:\Program Files\nCentral' -ErrorAction SilentlyContinue
    Copy-Item C:\windows\system32\calc.exe 'C:\Program Files\nCentral\nCentral.exe' -Force 
    $acl = Get-Acl 'C:\Program Files\nCentral'
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","FullControl","Allow")
    $acl.SetAccessRule($AccessRule)
    $acl | Set-Acl 'C:\Program Files\nCentral'
    sc.exe sdset nCentral "D:(A;CI;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCDCLCSWRPWPDTLOCRSDRC;;;BU)S:(AU;SAFA;WDWO;;;BA)"
}