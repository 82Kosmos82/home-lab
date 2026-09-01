## 2026-09-01 — налаштування бут ордера на ген1 біосі vm
```powershell
Set-VMBios -VMName $VMName -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
```