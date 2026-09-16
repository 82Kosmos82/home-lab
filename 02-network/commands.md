## 2026-09-01 — налаштування бут ордера на ген1 біосі vm
```powershell
Set-VMBios -VMName $VMName -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
```

## 2026-09-16 — міняємо віртуальний свіч на віртуалці
```powershell
Connect-VMNetworkAdapter -VMName WIN11-01 -SwitchName "Lab-Workstations"
```