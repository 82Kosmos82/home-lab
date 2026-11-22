Remove-NetIPAddress -InterfaceIndex 13 -AddressFamily IPv4 -Confirm:$false
Remove-NetRoute -InterfaceIndex 13 -AddressFamily IPv4 -Confirm:$false
Set-NetIPInterface -InterfaceIndex 13 -Dhcp Enabled
Set-DnsClientServerAddress -InterfaceIndex 13 -ResetServerAddresses
