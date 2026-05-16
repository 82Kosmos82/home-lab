#Requires -RunAsAdministrator

# === Параметри VM ===
$VMName     = "DC01"
$VMMemory   = 4GB
$VMCpu      = 2
$VMDiskSize = 60GB
$VMSwitch   = "Lab-Domain"
$VHDPath    = "D:\Hyper-V\VirtualDisks\$VMName.vhdx"
$ISOPath    = "D:\Hyper-V\ISO\SERVER_EVAL_x64FRE_en-us.iso"

# === Створення VM ===
New-VM -Name $VMName `
       -MemoryStartupBytes $VMMemory `
       -NewVHDPath $VHDPath `
       -NewVHDSizeBytes $VMDiskSize `
       -Generation 2 `
       -SwitchName $VMSwitch 
       

# === CPU ===
Set-VMProcessor -VMName $VMName -Count $VMCpu

# === DVD з ISO ===
Add-VMDvdDrive -VMName $VMName -Path $ISOPath

# === Зробити DVD першим у boot order ===
$dvd = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd
