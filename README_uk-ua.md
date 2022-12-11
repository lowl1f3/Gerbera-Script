<div align="right">
  Ця сторінка також на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/>
  <a title="Русский" href="README_ru-ru.md"><img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/></a>
</div>

## Про скрипт

Скрипт PowerShell для Windows, що автоматизує встановлення та налаштування програм

Підтримує `Windows 10` і `Windows 11`

## Пожертвування

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## Як використовувати

* <a href="https://github.com/lowl1f3/Script/archive/refs/heads/main.zip"><img src="https://img.shields.io/badge/Download-%20ZIP-green&?style=for-the-badge"/></a>
* Розпакуйте архів;
* Відкрийте папку розпакованого архіву;
* В `Windows 10` натисніть `Файл` у Провіднику, наведіть курсор на `Запустити Windows PowerShell`, і виберіть `Запустити Windows PowerShell від імені адміністратора` [(як це зробити зі скріншотами)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* В `Windows 11` натисніть правою кнопкою миші на <kbd>Windows</kbd> іконку і виберіть `Термінал (Адміністратор)`;
* Потім змініть поточне розташування

  ```powershell
  Set-Location -Path "Path\To\Script\Folder"
  ```

* Встановіть політику виконання, щоб запускати сценарії тільки в поточному сеансі PowerShell

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Введіть `.\Script.ps1` <kbd>Enter</kbd>, щоб запустити скрипт.

## Програми

> **Note**: Деякі з них мають тихе встановлення

<details>
	<summary>Перелік</summary>

* [Telegram](https://desktop.telegram.org)
* [Discord](https://discord.com/download)
  * [Better Discord](https://betterdiscord.app/) і корисні [плагіни](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L134)
* [Steam](https://store.steampowered.com/about/)
* [Chrome Enterprise](https://chromeenterprise.google/browser/download/#windows-tab)
* [7-Zip](https://www.7-zip.org/download.html) архіватор
* [Кастомний](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) курсор
* [Notepad++](https://notepad-plus-plus.org/downloads/)
* [GitHub Desktop](https://desktop.github.com/)
* [Visual Stutio Code](https://code.visualstudio.com/Download)
* [Teamspeak 3](https://teamspeak.com/en/downloads/)
* [qBittorrent](https://www.qbittorrent.org/download.php)
* [Настроюваний](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook, Teams, OneDrive
* [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)
* [Java 8](https://www.java.com/en/download/)(JRE) і [Java 19](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)(JDK)
* [WireGuard](https://www.wireguard.com/install/)
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [Системні вимоги](https://github.com/farag2/Sophia-Script-for-Windows#system-requirements)
</details>

## Посилання

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
