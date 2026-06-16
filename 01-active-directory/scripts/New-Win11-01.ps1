#Requires -RunAsAdministrator

# === Параметри VM ===
$VMName     = "WIN11-01"
$VMMemory   = 4GB
$VMCpu      = 2
$VMDiskSize = 60GB
$VMSwitch   = "Lab-Domain"
$VHDPath    = "D:\Hyper-V\VirtualDisks\$VMName.vhdx"
$ISOPath    = "D:\Hyper-V\ISO\Windows11.iso"

New-VM -Name $VMName `
       -MemoryStartupBytes $VMMemory `
       -NewVHDPath $VHDPath `
       -NewVHDSizeBytes $VMDiskSize `
       -Generation 2 `
       -SwitchName $VMSwitch 
       
# TPM 2.0
Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
Enable-VMTPM -VMName $VMName

# === CPU ===
Set-VMProcessor -VMName $VMName -Count $VMCpu

# === DVD з ISO ===
Add-VMDvdDrive -VMName $VMName -Path $ISOPath

# === Зробити DVD першим у boot order ===
$dvd = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd

