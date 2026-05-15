New-VMSwitch -Name "Lab-External" -NetAdapterName "Ethernet" -AllowManagementOS $true
New-VMSwitch -Name "Lab-Domain" -SwitchType Private