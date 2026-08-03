# Етап 1: Active Directory

## Мета
Розгорнути контролер домену lab.internal на базі Windows Server 2022,
налаштувати OU-структуру, перші GPO, і ввести в домен тестового клієнта.

## Архітектурні рішення
- **Домен:** lab.internal 
- **Підмережа лабораторії:** 172.16.50.0/24
- **DC01:** 172.16.50.10 
- **Forest functional level:** Windows Server 2016 

## Виконано
- [x] Створено VM DC01 (4 GB RAM, 2 vCPU, 60 GB, Gen 2, Lab-Domain switch)
- [x] Встановлено Windows Server 2022 Datacenter (Desktop Experience), evaluation
- [x] Перейменовано хост на DC01, налаштовано статичний IP
- [x] Встановлено роль AD DS, проведено promotion лісу lab.internal
- [x] OU-структура (Users, Computers, Groups, Servers, ServiceAccounts)
- [x] Тестові користувачі і групи (вручну)
- [x] PowerShell-скрипт масового створення юзерів з CSV
- [x] Перші GPO: політика паролів, Folder Redirection, обмеження для категорій юзерів
- [x] Тестова Windows-клієнтська VM, ввід у домен, перевірка GPO

## Артефакти
| Файл | Призначення |
|------|-------------|
| `scripts/New-DC01.ps1` | Створення VM DC01 в Hyper-V |
| `команди для VM.txt` | Шпаргалка по командам для робочи з VM |
| `DC01_config.png` | Конфіг DC01|
| `web_architecture.txt` | план по маршрутизації|
| `DC01_ipconfig.png` | налаштування мережі на DC01|
| `ADOrg.ps1` | створення OU-структури|
| `OU-structure.png` | OU-структура скриншотом на поточний момент|
| `user-example.png` | створення юзера через GUI|
| `AD_add_users` | масове створення юзерів в ад через список з ікселя|
| `ad-groups.png` | групи в ад лабораторії|
| `ad-groups-adding-users.png` | додавання юзерів в групу через веб інтерфейс |
| `interns-gpo-example.png` | налаштування політик для інтернів|
| `interns-gpo-example2.png` | налаштування політик для інтернів|
| `New-Win11-01.ps1` | творіння нового клієнт пк|
| `rdp_manual.png` | надавання групі юзерів доступу до рдп на цей пк мануально|
| `rdp_script.png` | надавання групі юзерів доступу до рдп на цей пк  скриптом|
| `rdp_policies.png` | надавання групі юзерів доступу до рдп на всі workstation за допомогою політик|
| `New-FILE)!.ps1` | Конфіг DC01|

## Нюанси

## Що далі
Перехід до Етапу 2 — налаштування мережі через OPNsense.