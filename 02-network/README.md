# Етап 2: Мережа з OPNsense

## Мета
Побудова сегментованої мережі з централізованим firewall на базі OPNsense,
розділення на VLAN (Servers, Workstations, Guests), налаштування DHCP, NAT
і WireGuard VPN для віддаленого доступу.

## Архітектурні рішення
- **Firewall/Router:** OPNsense (BSD-based, open-source)
- **Три ізольовані сегменти:** Servers, Workstations, Guests
- **Firewall model:** Default deny + explicit allow rules
- **DHCP-стратегія:** сервери статично, робочі станції і гості через DHCP
- **DNS-стратегія:** OPNsense forwarder з split-horizon (lab.internal → DC01)
- **VPN:** WireGuard на OPNsense

## IP-план
| Сегмент | Мережа | Gateway | Призначення |
|---|---|---|---|
| WAN | 192.168.50.x/24 | 192.168.50.1 | Вихід у "інтернет" через домашній роутер |
| Servers | 172.16.50.0/24 | 172.16.50.1 | DC01, FILE01 (статичні) |
| Workstations | 172.16.60.0/24 | 172.16.60.1 | WIN11-01 і майбутні клієнти (DHCP) |
| Guests | 172.16.70.0/24 | 172.16.70.1 | Гостьові VM (DHCP, майбутнє) |

## Виконано
- [x] Створено VM OPNsense (2 GB RAM, 1 vCPU, 20 GB, Gen 1, 4 network adapters)
- [x] Перейменовано Lab-Domain на Lab-Servers, створено Lab-Workstations і Lab-Guests
- [x] Встановлено OPNsense з ISO
- [x] Мережева конфігурація OPNsense (interfaces, IP, DHCP scopes, NAT)
- [ ] DHCP options 6, 15 і reservations для напівстатичних пристроїв
- [ ] Split-horizon DNS (lab.internal → DC01, інше → зовнішні DNS)
- [x] Firewall rules між сегментами (default deny + explicit allow)
- [ ] Переведено WIN11-01 у сегмент Workstations
- [ ] WireGuard VPN для віддаленого доступу до лабораторії
- [ ] Site-to-site VPN до Hetzner VPS
- [ ] AD CS (Active Directory Certificate Services) для WireGuard з сертифікатами
- [ ] Windows Server як network controller (DHCP роль замість OPNsense, IPAM)
- [ ] Глибший DNS (DNSSEC, DNS over HTTPS/TLS, ad-blocking)
- [ ] IDS/IPS через Suricata на OPNsense

## Артефакти
| Файл | Призначення |
|------|-------------|
| `scripts/New-OPNsense.ps1` | Створення VM OPNsense |
| `scripts/New-LabSwitches.ps1` | Створення нових свічів для лаби |
| `opnsense_interfaces.png` | дав айпішки віртуальним свічам |
| `opnsense_before_setup.png` | opnsense в базовій конфігурації до налаштування |
| `opnsense_web.png` | веб морда opnsense відкрита з DC01|
| `AD_Services_Ports.txt` | список портів відкритих від серверів на пк|
| `workstations_rules_ver1.png` | правила для інтерфейсу воркстанцій atm|
| `lan_servers_aliases.png` | аліас для підмережі серверів|
| `workstations_to_servers_rule.png` | відкривання портів на воркстанціях для сервіс портів на серверах|
| `web_servise_ports_alises.png` | аліас для веб портів|
| `workstations_to_web_rule.png` | випускаємо воркстанціїв веб|
| `workstations_opnsense_block_rule.png` | забираємо право в воркстанцій мати доступ до вебморди opnsense|
| `local_web_alias.png` | аліас сервісних портів аби можна було отримати dhcp ip|
| `guests_to_dhcp_rule.png` | правило аби можна було отримати ip через dhcp|
| `rfc1918_alias.png` | аліас з зарезервованими локальними мережами|
| `guests_blocking_lan.png` | блокуємо всі можливі лан мережі для гостей|
| `guests_to_web_rule.png` | випускаємо гостів в веб|
| `guests_rules.png` | правила гостьової підмережі|

## Що далі
Перехід до Етапу 3 — Linux, Docker, автоматизація через Ansible.