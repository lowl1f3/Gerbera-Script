<div align="right">
  Ця сторінка також на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
  <a title="Русский" href="README_ru-ru.md"><img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/></a>
</div>

## Про Gerbera Script

Скрипт PowerShell для Windows, автоматизуючий встановлення та налаштування програм

Підтримує `Windows 10` і `Windows 11`

## Пожертвування

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## Як користуватися

* Завантажте [актуальну версію](https://github.com/lowl1f3/Gerbera-Script/releases/latest);
* Розпакуйте архів;
* Відкрийте папку розпакованого архіву;
* Перегляньте файл `Gerbera.ps1` для налаштування функцій, які потрібно запустити;
  * Помістіть символ "#" перед функцією, якщо ви не бажаєте, щоб вона виконувалася.
  * Приберіть символ "#" перед функцією, якщо ви бажаєте, щоб вона виконувалася.
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

Gerbera -Functions Telegram, DeleteInstallationFiles
```

## Список

> **Note**: Для коректного виконання скрипту необхідні [winget](https://github.com/microsoft/winget-cli) і [Windows Terminal](https://github.com/microsoft/terminal)

<details>
  <summary>Програми</summary>

* [Telegram Desktop](https://desktop.telegram.org)
* [Spotify](https://www.spotify.com/download/windows)
* [Discord](https://discord.com/download)
  * [BetterDiscord](https://betterdiscord.app), [плагіни](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L283) і [теми](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L384)
* [Steam](https://store.steampowered.com/about)
* [Mozilla Firefox](https://www.mozilla.org/en/firefox/new/)
* [NanaZip](https://github.com/M2Team/NanaZip#-nanazip)
* [Курсор](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)
* [Notepad++](https://notepad-plus-plus.org/downloads)
* [GitHub Desktop](https://desktop.github.com)
* [Visual Stutio Community 2022](https://visualstudio.microsoft.com/#vs-section)
* [Microsoft Visual Stutio Code](https://code.visualstudio.com/Download)
* [TeamSpeak 3 Client](https://teamspeak.com/en/downloads)
* [qBittorrent](https://www.qbittorrent.org/download.php)
* [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)
* [Java 8](https://www.java.com/en/download) і [Java 19](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)
* [WireGuard](https://www.wireguard.com/install)
* [Налаштовуваний](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [Системні вимоги](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/README_uk-ua.md#системні-вимоги)
</details>

## Посилання

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
