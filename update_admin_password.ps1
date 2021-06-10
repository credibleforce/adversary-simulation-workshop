$user = 'Administrator'
$newPass = 'PASSWORD_HERE'
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force)