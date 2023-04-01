<div align="right">
  Эта страница также на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

## Про Gerbera Script

Скрипт PowerShell для Windows, автоматизирующий установку и настройку программ

Поддерживает `Windows 10` и `Windows 11`

## Пожертвования

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## Как использовать

* Скачайте [актуальную версию](https://github.com/lowl1f3/Gerbera-Script/releases/latest);
* Распакуйте архив;
* Откройте папку распакованного архива;
* Просмотрите файл `Gerbera.ps1`, чтобы настроить функции, которые вы хотите запустить;
  * Поставьте символ "#" перед функцией, если вы не хотите, чтобы она выполнялась.
  * Уберите символ "#" перед функцией, если вы хотите, чтобы она выполнялась.
* В `Windows 10` нажмите `Файл` в Проводнике, наведите курсор на `Запустить Windows PowerShell`, и выберите `Запустить Windows PowerShell от имени администратора` [(как это сделать со скриншотами)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* В `Windows 11` нажмите правой кнопкой мыши на <kbd>Windows</kbd> иконку и выберите `Терминал (Администратор)`;
* Затем измените текущее расположение

  ```powershell
  Set-Location -Path "Path\To\Script\Folder"
  ```

* Установите политику выполнения, чтобы запускать сценарии только в текущем сеансе PowerShell

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Введите `.\Gerbera.ps1` <kbd>Enter</kbd> для запуска всего пресета.

### Как вызвать конкретные функции(ю)

Чтобы вызвать конкретные функции(ю), необходимо сначала [дот-сорсить](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) файл `Functions.ps1`:

```powershell
# С точкой в начале
. .\Functions.ps1
```

* Теперь вы можете делать так

```powershell
Gerbera -Functions <TAB>
Gerbera -Functions tele<TAB>
Gerbera -Functions delete<TAB>

Gerbera -Functions Telegram, DeleteInstallationFiles
```

## Список

> **Note**: Для корректного выполнения скрипта необходимы [winget](https://github.com/microsoft/winget-cli) и [Windows Terminal](https://github.com/microsoft/terminal)

<details>
  <summary>Программы</summary>

* [Telegram Desktop](https://desktop.telegram.org)
* [Spotify](https://www.spotify.com/download/windows)
* [Discord](https://discord.com/download)
  * [BetterDiscord](https://betterdiscord.app), [плагины](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L283) и [темы](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L384)
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
* [Java 8](https://www.java.com/en/download) и [Java 19](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)
* [WireGuard](https://www.wireguard.com/install)
* [Настраиваемый](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [Системные требования](https://github.com/farag2/Sophia-Script-for-Windows#system-requirements)
</details>

## Ссылки

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
