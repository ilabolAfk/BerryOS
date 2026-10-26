<img width="512" height="512" alt="image" src="https://github.com/user-attachments/assets/12819fc8-22a4-47dc-a16b-0dec3d2144cb" />

# Berry OS

<p align="center">
  <b>Мощь Linux. Свобода от Windows.</b><br>
  <i>Твоя система. Твои правила.</i>
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/version-3.1_Fresh-brightgreen.svg?style=for-the-badge" alt="Version"></a>
  <a href="#"><img src="https://img.shields.io/badge/base-Linux_Mint_22-blue.svg?style=for-the-badge" alt="Base"></a>
  <a href="#"><img src="https://img.shields.io/badge/desktop-Cinnamon-orange.svg?style=for-the-badge" alt="Desktop"></a>
  <a href="#"><img src="https://img.shields.io/badge/license-GPLv3-lightgrey.svg?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Status-Active-success.svg" alt="Status"></a>
  <a href="#"><img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" alt="Maintained"></a>
  <a href="#"><img src="https://img.shields.io/badge/Python-3.12-yellow.svg?logo=python&logoColor=white" alt="Python"></a>
  <a href="#"><img src="https://img.shields.io/badge/PyQt-6-green.svg?logo=qt&logoColor=white" alt="PyQt6"></a>
</p>

---

**Berry OS** — это кастомная операционная система на базе Linux Mint, созданная для тех, кто устал от ограничений, навязчивой рекламы и слежки. Мы взяли надежность и стабильность Linux и завернули её в понятный, красивый интерфейс с набором собственных утилит, написанных на Python и PyQt6.

## ✨ Главные фишки

Мы не просто перекрасили обои. Мы написали собственные приложения, чтобы миграция с Windows прошла максимально безболезненно.

| Приложение | Описание |
| :--- | :--- |
| 🛠️ **Berry Command Center** | Единый центр управления системой, где собраны все инструменты, графики нагрузки и настройки. |
| 🛍️ **Berry App Store** | Установка популярного софта в один клик (с выбором между APT и изолированным Flatpak). |
| 🍷 **Berry Windows Bridge** | Интуитивная графическая обертка для Wine. Запускайте `.exe` файлы, не заходя в терминал. |
| 🛡️ **Berry Antivirus** | Встроенный сканер на базе ClamAV и YARA с красивой визуализацией. Безопасность без тормозов. |
| 🧹 **Berry Cleaner** | Умная очистка кэша, логов и мусора с наглядным прогрессом. |
| 📦 **Berry Migrator** | Помогает в один клик перенести документы, фото и файлы с рабочего стола Windows. |
| 🗜️ **Berry Archiver** | Красивый GUI-архиватор (ZIP, 7Z, TAR) с поддержкой Drag & Drop и паролей. |
| 🔄 **Berry Updater** | Центр обновлений, который делает всё в фоне и показывает прогресс прямо в окне. |
| 🎨 **Berry Theme Manager** | Переключение между светлой (Zorin + Papirus) и темной темами в один клик. |

---

## 🚀 Как попробовать?

На данный момент Berry OS распространяется в виде готового ISO-образа (Live-USB).

1. Скачайте последний релиз `BerryOS.iso` со вкладки **[Releases](../../releases)**.
2. Запишите образ на флешку (минимум 8 ГБ) с помощью [Rufus](https://rufus.ie/) или BalenaEtcher.
3. Загрузитесь с флешки. Вы можете поработать в Live-режиме или установить Berry OS на жесткий диск, нажав на иконку **Install BerryOS** на рабочем столе.

> [!WARNING]
> **Тестирование в VirtualBox:** Обязательно отключите EFI в настройках виртуальной машины (используйте Legacy BIOS) и включите 4 ГБ ОЗУ.

---

## 🖼️ Скриншоты

| Рабочий стол | Berry Command Center |
| :---: | :---: |
| ![Desktop](https://just-sources.com/os/desctop.png) | ![Center](https://just-sources.com/os/comcenter.png) |

| Berry Antivirus | Berry Windows Bridge |
| :---: | :---: |
| ![Antivirus](https://just-sources.com/os/antivirus.png) | ![Wine](https://just-sources.com/os/winbridge.png) |

---

## 📚 Документация

Подробные гайды по использованию Berry OS, настройке Wine и решению проблем доступны на нашем сайте:
👉 **[just-sources.com/os](https://just-sources.com/os)**

---

## 👨‍💻 Для разработчиков (Сборка из исходников)

Если вы хотите собрать Berry OS самостоятельно или внести изменения:

1. Скачайте оригинальный ISO Linux Mint 22.
2. Откройте его в **[Cubic](https://github.com/PJ-Singh-001/Cubic)** (Custom Ubuntu ISO Creator).
3. Все скрипты и конфигурации, которые использовались для создания Berry OS, находятся в этом репозитории. Запустите установочный скрипт в chroot-окружении Cubic:
```bash
sudo ./install.sh
Сгенерируйте новый ISO (рекомендуется сжатие lz4).

🤝 Вклад в проект
Мы всегда рады помощи! Если вы нашли баг, хотите предложить новую фичу или перевести систему на другой язык — создавайте Issue или делайте Pull Request.

📄 Лицензия
Проект распространяется под лицензией GPLv3. Вы можете свободно использовать, модифицировать и распространять Berry OS.

<p align="center"> <i>Сделано с любовью к чистым системам.</i> 🍓 </p> ```
