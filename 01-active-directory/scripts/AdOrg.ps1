#Requires -RunAsAdministrator
$domainDN = "DC=lab,DC=internal"
$org =@(
    "Users",
    "Computers",
    "Servers",
    "Groups",
    "ServiceAccounts",
    "Disabled"
)
$fold =@(
    "IT",
    "Marketing",
    "Sales",
    "Interns"
)
$comp =@(
    "Workstations",
    "Laptops"
)
New-ADOrganizationalUnit -Name "LAB" -Path $domainDN
 foreach($o in $org)
 {
    New-ADOrganizationalUnit -Name $o -Path "OU=LAB,$domainDN"
 }
 foreach($f in $fold)
 {
    New-ADOrganizationalUnit -Name $f -Path "OU=Users,OU=LAB,$domainDN"
 }
  foreach($c in $comp)
 {
    New-ADOrganizationalUnit -Name $c -Path "OU=Computers,OU=LAB,$domainDN"
 }

New-ADOrganizationalUnit -Name "MemberServers" -Path "OU=Servers,OU=LAB,$domainDN"
