 New-Service -Name "KDService" -BinaryPathName '"C:\KDService\KDService.exe"' -ErrorAction SilentlyContinue
New-Item -ItemType Directory 'C:\KDService' -ErrorAction SilentlyContinue
Copy-Item C:\windows\system32\calc.exe C:\KDService\KDService.exe -Force 
cmd /k "sc sdset kdservice D:(A;CI;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCDCLCSWRPWPDTLOCRSDRC;;;BU)S:(AU;SAFA;WDWO;;;BA)" 
