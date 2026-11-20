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
## 2026-11-20 — додаємо зворотню зону на сервері
```powershell
Add-DnsServerPrimaryZone -NetworkId "172.16.50.0/24" -ReplicationScope "Domain" -DynamicUpdate Secure
```
-NetworkId — Windows сама перетворить мережу на назву ...in-addr.arpa
-ReplicationScope Domain — зона зберігається в AD і реплікується між DC (з'явиться DC02 — отримає її автоматично)
-DynamicUpdate Secure — записи можуть створювати лише доменні машини від свого імені
## 2026-11-20 — додаємо зворотню зону на сервері для недоменної машини(опнсенс)
```powershell
Add-DnsServerResourceRecordPtr -ZoneName "50.16.172.in-addr.arpa" -Name "1" -PtrDomainName "opnsense.lab.internal"
```
-Name "1" — останній октет адреси: 172.16.50.1 і 172.16.60.1

