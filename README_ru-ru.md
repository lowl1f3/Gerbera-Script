<div align="right">
  Эта страница также на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

# Gerbera Script

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

## Про Gerbera Script

> **Note**: Скрипт PowerShell для Windows, автоматизирующий установку и настройку программ. Поддерживает `Windows 10` и `Windows 11`

<details>
  <summary>Программы</summary>

* [Telegram Desktop](https://desktop.telegram.org)
* [Spotify](https://www.spotify.com/download/windows)
* [Discord](https://discord.com/download)
  * [BetterDiscord](https://betterdiscord.app), [плагины](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L284) и [темы](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L397)
* [Steam](https://store.steampowered.com/about)
* [Mozilla Firefox](https://www.mozilla.org/en/firefox/new)
  * [Кастомизация](https://github.com/lowl1f3/Firefox) используя .css дополнения
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

## Перед запуском

> **Note**: Убедитесь, что у вас установлены [winget](https://github.com/microsoft/winget-cli) и [Windows Terminal](https://github.com/microsoft/terminal) для корректного выполнения

## Пожертвования

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

[![Monobank](https://www.monobank.ua/resources/1.0.22.1-1684902721000/img/favicon/apple/apple-touch-icon-152x152.png)](https://send.monobank.ua/jar/2niEmTngoi)

## Как использовать

* Скачайте [актуальную версию](https://github.com/lowl1f3/Gerbera-Script/releases/latest);
* Распакуйте архив;
* Откройте папку распакованного архива;
* Просмотрите файл `Gerbera.ps1`, чтобы настроить функции, которые вы хотите запустить;
  * Поставьте символ "`#`" перед функцией, если вы не хотите, чтобы она выполнялась.
  * Уберите символ "`#`" перед функцией, если вы хотите, чтобы она выполнялась.
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

Gerbera -Functions TelegramDesktop, DeleteInstallationFiles
```
