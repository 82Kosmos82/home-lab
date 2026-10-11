## 2026-09-01 — налаштування бут ордера на ген1 біосі vm
```powershell
Set-VMBios -VMName $VMName -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
```

## 2026-09-16 — міняємо віртуальний свіч на віртуалці
```powershell
Connect-VMNetworkAdapter -VMName WIN11-01 -SwitchName "Lab-Workstations"
```

## 2026-10-11 — дивимось чи резолвить днс цей айпі. явно вказаний сервер
```powershell
Resolve-DnsName www.youtube.com -Server 8.8.8.8 -DnsOnly
```

## 2026-09-16 — тестуємо конекст з конкретним айпі/ресурсом. явно вказаний порт
```powershell
Test-NetConnection google.com -Port 443
```
