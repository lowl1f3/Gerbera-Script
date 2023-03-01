<div align="right">
  Эта страница также на:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

## О скрипте

Скрипт PowerShell для Windows, автоматизирующий установку и настройку программ

Поддерживает `Windows 10` и `Windows 11`

## Пожертвования

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## Как использовать

* <a href="https://github.com/lowl1f3/Script/archive/refs/heads/main.zip"><img src="https://img.shields.io/badge/Скачать-%20ZIP-green&?style=for-the-badge"/></a>
* Распакуйте архив;
* Откройте папку распакованного архива;
* Просмотрите файл Script.ps1, чтобы настроить функции, которые вы хотите запустить;
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

* Введите `.\Script.ps1` <kbd>Enter</kbd> для запуска всего пресета.

## Программы

> **Note**: Некоторые из них имеют тихую установку

<details>
  <summary>Программы</summary>

* [Telegram](https://desktop.telegram.org)
* [Spotify](https://www.spotify.com/download/windows)
* [Discord](https://discord.com/download)
  * [Better Discord](https://betterdiscord.app), [плагины](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L178) и [темы](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L285)
* [Steam](https://store.steampowered.com/about)
* [Google Chrome](https://chromeenterprise.google/browser/download/#windows-tab)
* [NanaZip](https://github.com/M2Team/NanaZip)
* [Кастомный курсор](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)
* [Notepad++](https://notepad-plus-plus.org/downloads)
* [GitHub Desktop](https://desktop.github.com)
* [Visual Stutio](https://visualstudio.microsoft.com/#vs-section)
* [Visual Stutio Code](https://code.visualstudio.com/Download)
* [TeamSpeak 3](https://teamspeak.com/en/downloads)
* [qBittorrent](https://www.qbittorrent.org/download.php)
* [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)
* [Java 8(JRE)](https://www.java.com/en/download) и [Java 19(JDK)](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)
* [WireGuard](https://www.wireguard.com/install)
* [Настраиваемый](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [Системные требования](https://github.com/farag2/Sophia-Script-for-Windows#system-requirements)
</details>

## Ссылки

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
