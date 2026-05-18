# Команди Етапу 1: Active Directory

Хронологічна збірка команд, використаних при розгортанні домену
`lab.internal`. З коментарями і контекстом.

Команди розділено на дві категорії:
- **На хості (PC)** — виконуються в PowerShell на Windows 11 від адміна
- **На DC01 (VM)** — виконуються в PowerShell всередині VM від адміна

---

## 2026-05-16 — Створення VM DC01

**Контекст:** На хості з активованим Hyper-V створюємо VM майбутнього контролера домену.
Запускається з `01-active-directory/scripts/New-DC01.ps1`.

**Виконується на:** хості (PC)

```powershell
# Параметри VM
$VMName     = "DC01"
$VMMemory   = 4GB
$VMCpu      = 2
$VMDiskSize = 60GB
$VMSwitch   = "Lab-Domain"
$VHDPath    = "D:\Hyper-V\VirtualDisks\$VMName.vhdx"
$ISOPath    = "D:\Hyper-V\ISO\SERVER_EVAL_x64FRE_en-us.iso"

# Створення VM
New-VM -Name $VMName `
       -MemoryStartupBytes $VMMemory `
       -NewVHDPath $VHDPath `
       -NewVHDSizeBytes $VMDiskSize `
       -Generation 2 `
       -SwitchName $VMSwitch

# Налаштування CPU
Set-VMProcessor -VMName $VMName -Count $VMCpu

# Підключення ISO
Add-VMDvdDrive -VMName $VMName -Path $ISOPath

# Boot order — DVD першим (інакше Gen 2 спробує boot з порожнього диска)
$dvd = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd

# Перевірка
Get-VM -Name $VMName
```

**Перевірка:**
- `Get-VM -Name DC01` → State: Off
- `Get-VMDvdDrive -VMName DC01` → ISO підключено
- `Get-VM -Name DC01 | Select -ExpandProperty NetworkAdapters` → Lab-Domain

**Граблі:**
- Для `New-VM` параметри `-MemoryStartupBytes` і `-NewVHDSizeBytes` приймають числа з суфіксами (`4GB`, `60GB`) без лапок. У лапках це стає рядком і команда не приймає.
- Якщо забути `-NewVHDPath` — система може створити диск у дефолтному місці (бо `Set-VMHost -VirtualHardDiskPath` ми робили), але краще явно вказувати.

---

## 2026-05-17 — Перейменування хоста і налаштування мережі

**Контекст:** Свіжо встановлений Windows Server 2022. Готуємо до promotion.

**Виконується на:** DC01 (VM)

### Перейменування
```powershell
Rename-Computer -NewName "DC01" -Restart
```

VM перезавантажиться автоматично через `-Restart`.

### Після перезавантаження — статичний IP

```powershell
# 1. Знайти InterfaceIndex активного адаптера
Get-NetAdapter

# 2. Налаштувати IP (підставити свій InterfaceIndex замість 5)
New-NetIPAddress -InterfaceIndex 5 -IPAddress 172.16.50.10 -PrefixLength 24 -DefaultGateway 172.16.50.1

# 3. DNS — на loopback (DC сам буде DNS-сервером)
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses 127.0.0.1

# 4. Перевірка
ipconfig /all
```

**Якщо помилково додали неправильний IP — видалити:**
```powershell
Remove-NetIPAddress -InterfaceIndex 5 -Confirm:$false
```

**Перевірка:**
- `hostname` → DC01
- `ipconfig /all` → IPv4: 172.16.50.10, Subnet: 255.255.255.0, Gateway: 172.16.50.1, DNS: 127.0.0.1


---

## 2026-05-17 — Установка ролі AD DS

**Контекст:** Сервер перейменований, з коректною мережею. Встановлюємо бінарники.

**Виконується на:** DC01 (VM)

```powershell
# Установка ролі + інструменти управління (ADUC, ADAC, PowerShell-модуль)
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Перевірка
Get-WindowsFeature -Name AD-Domain-Services
Get-Module -ListAvailable -Name ActiveDirectory
```

**Перевірка:**
- `Get-WindowsFeature -Name AD-Domain-Services` → `[X]` (Installed)
- Модуль `ActiveDirectory` доступний

---

## 2026-05-17 — Promotion: створення лісу lab.internal

**Контекст:** Установка бінарників завершена. Створюємо ліс і робимо сервер першим DC.

**Виконується на:** DC01 (VM)

```powershell
Install-ADDSForest `
    -DomainName "lab.internal" `
    -DomainNetbiosName "LAB" `
    -ForestMode "WinThreshold" `
    -DomainMode "WinThreshold" `
    -InstallDns `
    -NoRebootOnCompletion:$false
```

**Що команда запитає:**
1. `SafeModeAdministratorPassword` — пароль DSRM (Directory Services Restore Mode). Окремий пароль для режиму відновлення AD.
2. Підтвердження повного підтвердження операції — `Y`.

**Параметри детально:**
- `-DomainName "lab.internal"` — FQDN домену і лісу
- `-DomainNetbiosName "LAB"` — коротка форма (для логінів `LAB\username`)
- `-ForestMode "WinThreshold"` — функціональний рівень лісу (Server 2016)
- `-DomainMode "WinThreshold"` — функціональний рівень домену (Server 2016)
- `-InstallDns` — встановити DNS-сервер (обов'язково для першого DC у лісі)
- `-NoRebootOnCompletion:$false` — перезавантажити автоматично після завершення

**Очікувано:** 5-15 хвилин роботи + автоматичний перезавантаження.

**Перевірка після перезавантаження:**
```powershell
hostname              # DC01
Get-ADDomain          # info про домен lab.internal
Get-ADForest          # info про ліс
dcdiag /v             # повна діагностика контролера
```

**Ключові поля у Get-ADDomain:**
- Forest: lab.internal
- DNSRoot: lab.internal
- NetBIOSName: LAB
- DomainMode: Windows2016Domain
- PDCEmulator, RIDMaster, InfrastructureMaster: DC01.lab.internal
- DomainSID: S-1-5-21-... (унікальний на ліс)



---

## 2026-05-17 — Створення snapshot як точки відкату

**Контекст:** Свіжо створений ліс, чистий стан перед експериментами з OU/GPO.

**Виконується на:** хості (PC)

```powershell
# Створення Production Checkpoint
Checkpoint-VM -Name DC01 -SnapshotName "AD-DS-promoted-clean"

# Перевірка
Get-VMSnapshot -VMName DC01
```

**Перевірка:**
- `Get-VMSnapshot -VMName DC01` → snapshot з назвою "AD-DS-promoted-clean"


## 2026-05-18 — Створення структури домена
New-ADOrganizationalUnit команда для додавання нової OU
**Параметри детально:**
- -Name -- ім'я підрівня
- -Path -- шлях в форматі DN. читається зліва направо.
**Приклад**
New-ADOrganizationalUnit -Name "MemberServers" -Path "OU=Servers,OU=LAB,$domainDN"

створює Member-Servers OU вісередині lab.internal\LAB\Servers


---
