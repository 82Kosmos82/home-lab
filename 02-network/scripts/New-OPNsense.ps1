#Requires -RunAsAdministrator

# === Параметри VM ===
$VMName     = "OPNsense"
$VMMemory   = 2GB
$VMCpu      = 1
$VMDiskSize = 20GB
$VHDPath    = "D:\Hyper-V\VirtualDisks\$VMName.vhdx"
$ISOPath    = "D:\Hyper-V\ISO\OPNsense-26.7-dvd-amd64.iso"
$switch     = @("Lab-External", "Lab-Servers", "Lab-Workstations","Lab-Guests")
$counter    = @(0,1,2,3)
$switchname = @("WAN", "Servers", "Workstations", "Guests")

# === Створення VM ===
New-VM -Name $VMName `
       -MemoryStartupBytes $VMMemory `
       -NewVHDPath $VHDPath `
       -NewVHDSizeBytes $VMDiskSize `
       -Generation 1

Remove-VMNetworkAdapter -VMName $VMName
foreach($c in $counter)
{
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $switch[$c] -IsLegacy $true -Name $switchname[$c]
}     
# === CPU ===
Set-VMProcessor -VMName $VMName -Count $VMCpu

# === DVD з ISO ===
Add-VMDvdDrive -VMName $VMName -Path $ISOPath

Set-VMBios -VMName $VMName -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")