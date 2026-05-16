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
- [ ] Перейменовано хост на DC01, налаштовано статичний IP
- [ ] Встановлено роль AD DS, проведено promotion лісу lab.internal
- [ ] OU-структура (Users, Computers, Groups, Servers, ServiceAccounts)
- [ ] Тестові користувачі і групи (вручну)
- [ ] PowerShell-скрипт масового створення юзерів з CSV
- [ ] Перші GPO: політика паролів, Folder Redirection, обмеження для категорій юзерів
- [ ] Тестова Windows-клієнтська VM, ввід у домен, перевірка GPO

## Артефакти
| Файл | Призначення |
|------|-------------|
| `scripts/New-DC01.ps1` | Створення VM DC01 в Hyper-V |
| `команди для VM.txt` | Шпаргалка по командам для робочи з VM |
| `DC01_config.png` | Конфіг DC01|
| `web_architecture.txt` | план по маршрутизації|

## Нюанси

## Що далі
Перехід до Етапу 2 — налаштування мережі через OPNsense.