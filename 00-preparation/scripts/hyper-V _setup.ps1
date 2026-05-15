$folders = @(
    "VMs",
    "VirtualDisks",
    "ISO"
)

foreach($f in $folders){
    New-Item -ItemType Directory -Path "D:\Hyper-V\$f" -Force
}

Set-VMHost -VirtualMachinePath "D:\Hyper-V\VMs"
Set-VMHost -VirtualHardDiskPath "D:\Hyper-V\VirtualDisks"