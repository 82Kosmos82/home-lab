# Етап 0: Підготовка

Налаштування робочого середовища і базової інфраструктури віртуалізації 
на хості, перш ніж починати будувати лабораторію.

## Мета

Підготувати хост (ПК) і репозиторій до роботи з Hyper-V і Git так, 
щоб усі наступні етапи могли спиратися на готову основу.

## Виконано

- [✅] Чиста установка Windows 11 Pro
- [✅] BitLocker безпечно вимкнено на C: і D:
- [✅] Локальний адміністративний акаунт `kosmos`
- [✅] Базовий софт через `winget`: Git, VS Code, Windows Terminal, PowerShell 7, GitHub CLI, Everything, WinDirStat, 7-Zip, Draw.io
- [✅] Git налаштовано (user, email, autocrlf, editor)
- [✅] SSH-ключ ed25519 на GitHub
- [✅] Створено публічний репозиторій `home-lab`
- [✅] Структура папок репозиторію
- [✅] Активовано Hyper-V
- [✅ Налаштовано шляхи зберігання VM: `D:\Hyper-V\VMs`, `D:\Hyper-V\VirtualDisks`, `D:\Hyper-V\ISO`
- [✅ Створено Virtual Switch: `Lab-External` (зовнішній), `Lab-Domain` (приватний)
- [✅] Завантажено ISO: Windows Server 2022 Eval, Ubuntu Server 26.04 LTS

## Артефакти

| Файл | Призначення |
|------|-------------|
| `scripts/git.setup.ps1` | Створення структури папок репозиторію |
| `scripts/hyper-V.setup.ps1` | Налаштування шляхів зберігання VM |
| `scripts/VirtualSwitch.setup.ps1` | Створення Virtual Switch для лабораторії |

## Нюанси

- ПК — ASUS B450 + Ryzen 5 3600, 32 GB RAM. Для Hyper-V вистачає з запасом
- Для External Switch обов'язково `-AllowManagementOS $true`, інакше хост втрачає інтернет
- WireGuard-тунель до Hetzner не постраждав від створення External Switch


## Що далі

Перехід до [Етапу 1 — Active Directory](../01-active-directory/) для розгортання домену.