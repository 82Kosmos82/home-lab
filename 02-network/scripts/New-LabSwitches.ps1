#Requires -RunAsAdministrator

Rename-VMSwitch -Name "Lab-Domain" -NewName "Lab-Servers"
$labswitch = @("Lab-Workstations", "Lab-Guests")

foreach($sw in $labswitch)
{
    New-VMSwitch -Name $sw -SwitchType Private
}
