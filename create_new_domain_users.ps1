$newPass = 'PASSWORD'
New-ADUser `
-Name "Jebediah Springfield (Admin)" `
-GivenName "Jeb" `
-Surname "Springfield" `
-SamAccountName "a-jspringfield" `
-AccountPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) `
-ChangePasswordAtLogon $False `
-Company "LAB" `
-Title "CEO" `
-State "British Columbia" `
-City "Vancouver" `
-Description "User" `
-EmployeeNumber "10" `
-Department "Engineering" `
-DisplayName "Jebediah Springfield (Admin)" `
-Country "CA" `
-PostalCode "A1A1A1" `
-Enabled $True

$newPass = 'PASSWORD'
New-ADUser `
-Name "Jebediah Springfield" `
-GivenName "Jeb" `
-Surname "Springfield" `
-SamAccountName "jspringfield" `
-AccountPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force) `
-ChangePasswordAtLogon $False `
-Company "LAB" `
-Title "CEO" `
-State "British Columbia" `
-City "Vancouver" `
-Description "User" `
-EmployeeNumber "10" `
-Department "Engineering" `
-DisplayName "Jebediah Springfield" `
-Country "CA" `
-PostalCode "A1A1A1" `
-Enabled $True

Add-ADGroupMember -Identity "Domain Admins" -Members "a-jspringfield"

invoke-command -ComputerName win19-svr1.lab.lan -UseSSL -Authentication Negotiate -ScriptBlock {
    Add-LocalGroupMember "Administrators" -Member "LAB\jspringfield"
}