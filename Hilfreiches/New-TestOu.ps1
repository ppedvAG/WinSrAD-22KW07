[cmdletBinding()]
param(
[Parameter(Mandatory=$true)]
$Abteilung,

[string]$User = ($Abteilung[0] + "User1"),

[Parameter(Mandatory=$true)]
[string]$Passwort
)

New-ADOrganizationalUnit -Name:"$Abteilung" -Path:"OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"
Set-ADObject -Identity:"OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"
New-ADOrganizationalUnit -Name:"Computer" -Path:"OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"
Set-ADObject -Identity:"OU=Computer,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"
New-ADOrganizationalUnit -Name:"User" -Path:"OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"
Set-ADObject -Identity:"OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -ProtectedFromAccidentalDeletion:$true -Server:"Server1.ppedv.test"

New-ADGroup -GroupCategory:"Security" -GroupScope:"Global" -Name:"GL-$Abteilung" -Path:"OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -SamAccountName:"GL-$Abteilung" -Server:"Server1.ppedv.test"

New-ADUser -DisplayName:$null -GivenName:$null -Initials:$null -Name:"$User" -Path:"OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -SamAccountName:"$User" -Server:"Server1.ppedv.test" -Surname:$null -Type:"user" -UserPrincipalName:"$User@ppedv.test"
Set-ADAccountPassword -Identity:"CN=$User,OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -NewPassword:(ConvertTo-SecureString -AsPlainText -Force -String "$Passwort") -Reset:$true -Server:"Server1.ppedv.test"
Enable-ADAccount -Identity:"CN=$User,OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -Server:"Server1.ppedv.test"
Add-ADPrincipalGroupMembership -Identity:"CN=$User,OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -MemberOf:"CN=GL-$Abteilung,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -Server:"Server1.ppedv.test"
Set-ADAccountControl -AccountNotDelegated:$false -AllowReversiblePasswordEncryption:$false -CannotChangePassword:$false -DoesNotRequirePreAuth:$false -Identity:"CN=$User,OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -PasswordNeverExpires:$false -Server:"Server1.ppedv.test" -UseDESKeyOnly:$false
Set-ADUser -ChangePasswordAtLogon:$false -Identity:"CN=$User,OU=User,OU=$Abteilung,OU=Struktur,DC=ppedv,DC=test" -Server:"Server1.ppedv.test" -SmartcardLogonRequired:$false
