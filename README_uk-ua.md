<div align="right">
  Ця сторінка також на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
</div>

# Gerbera Script - Спрощує досвід роботи з Windows🌟

<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Windows_10_Logo.svg" height="30px"/> &emsp; <img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="30px"/>

<p align="left">
  <a href="https://github.com/lowl1f3/Gerbera-Script/actions"><img src="https://img.shields.io/github/actions/workflow/status/lowl1f3/Gerbera-Script/Gerbera.yml?label=GitHub%20Actions&logo=GitHub"></a>
  <img src="https://img.shields.io/badge/PowerShell%205.1%20&%207.3-Ready-blue.svg?color=5391FE&style=flat&logo=powershell">

  <a href="https://github.com/lowl1f3/Gerbera-Script/releases"><img src="https://img.shields.io/github/v/release/lowl1f3/Gerbera-Script"></a>
  <a href="https://github.com/lowl1f3/Gerbera-Script/releases"><img src="https://img.shields.io/github/downloads/lowl1f3/Gerbera-Script/total?label=downloads%20%28since%20April%202022%29"></a>

  [telegram-badge]: https://img.shields.io/badge/Telegram-blue?style=flat&logo=Telegram
  [telegram-pm]: https://t.me/lowlif3

  [discord-badge]: https://img.shields.io/badge/Discord-5865F2?style=flat&logo=discord&logoColor=white
  [discord-pm]: https://discord.com/users/330825971835863042
  [![Telegram][telegram-badge]][telegram-pm]
  [![Discord][discord-badge]][discord-pm]
</p>

---

## Про Gerbera Script

Забезпечує простоту налаштування Windows, автоматизуючи процеси встановлення та налаштування програм. Підтримує `Windows 10 x64` і `Windows 11`

<details>
  <summary>Випадаючий список: </summary>
  
| Програми                                                                                                                                                                                      |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Telegram Desktop](https://desktop.telegram.org)                                                                                                                                              |
| [Discord](https://discord.com/download) і [BetterDiscord](https://betterdiscord.app) з [Плагінами і Темами](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L268) |
| [Steam](https://store.steampowered.com/about)                                                                                                                                                 |
| [Mozilla Firefox](https://www.mozilla.org/firefox/new) з [доповненнями](https://github.com/lowl1f3/Firefox)                                                                                   |
| [NanaZip](https://github.com/M2Team/NanaZip#-nanazip)                                                                                                                                         |
| [Custom Cursor](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)                                                                                        |
| [Notepad++](https://notepad-plus-plus.org/downloads)                                                                                                                                          |
| [GitHub Desktop](https://desktop.github.com)                                                                                                                                                  |
| [TeamSpeak 3 Client](https://teamspeak.com/downloads)                                                                                                                                         |
| [qBittorrent](https://www.qbittorrent.org/download.php)                                                                                                                                       |
| [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)                                                                                                       |
| [Java 8](https://www.java.com/download) і [Java 21](https://www.oracle.com/java/technologies/downloads/#jdk21-windows)                                                                        |
| [WireGuard](https://www.wireguard.com/install)                                                                                                                                                |
| [Microsoft Office](https://github.com/farag2/Office) з [конфігуруванням](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Office/Configure.ps1)                                       |
| [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)                                                                                                                          |
</details>

## Перед запуском

> [!NOTE]
> **Note**: Для коректної роботи скрипта буде встановлено [winget](https://github.com/microsoft/winget-cli) та [Windows Terminal](https://github.com/microsoft/terminal)

---

## Як користуватися

* Завантажте [актуальну версію](https://github.com/lowl1f3/Gerbera-Script/releases/latest);
* Розпакуйте архів;
* Відкрийте папку розпакованого архіву;
* Перегляньте файл `Gerbera.ps1` для налаштування функцій, які потрібно запустити;
  * Помістіть символ "`#`" перед функцією, якщо ви не бажаєте, щоб вона виконувалася.
  * Приберіть символ "`#`" перед функцією, якщо ви бажаєте, щоб вона виконувалася.
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

* Введіть `.\Gerbera.ps1` <kbd>Enter</kbd> для запуску всього пресету.

### Як викликати конкретні функції(ю)

Щоб викликати конкретні функції(ю), необхідно спочатку [дот-сорсити](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) файл `Functions.ps1`:

```powershell
# З точкою на початку
. .\Functions.ps1
```

* Тепер ви можете робити так

```powershell
Gerbera -Functions <TAB>
Gerbera -Functions tele<TAB>
Gerbera -Functions delete<TAB>

Gerbera -Functions TelegramDesktop, DeleteInstallationFiles
```

---

## Пожертвування

Подумайте про те, щоб підтримати цей проєкт крапелькою радості!🌈🚀

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

[![Monobank](https://www.monobank.ua/resources/1.0.22.1-1684902721000/img/favicon/apple/apple-touch-icon-152x152.png)](https://send.monobank.ua/jar/2niEmTngoi)
