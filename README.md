<div align="right">
  This page also in:
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

# Gerbera Script - Simplifying Your Windows Experience🌟

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

## About Gerbera Script

Brings hassle-free experience to your Windows setup by automating the installation and configuration of programs. Supports `Windows 10 x64` & `Windows 11`

<details>
  <summary>Drop-down list: </summary>
  
| Programs                                                                                                                                                                                       |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Telegram Desktop](https://desktop.telegram.org)                                                                                                                                               |
| [Discord](https://discord.com/download) & [BetterDiscord](https://betterdiscord.app) with [Plugins & Themes](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Module/Gerbera.psm1#L268) |
| [Steam](https://store.steampowered.com/about)                                                                                                                                                  |
| [Mozilla Firefox](https://www.mozilla.org/firefox/new) with [add-ons](https://github.com/lowl1f3/Firefox)                                                                                      |
| [NanaZip](https://github.com/M2Team/NanaZip#-nanazip)                                                                                                                                          |
| [Custom Cursor](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)                                                                                         |
| [Notepad++](https://notepad-plus-plus.org/downloads)                                                                                                                                           |
| [GitHub Desktop](https://desktop.github.com)                                                                                                                                                   |
| [TeamSpeak 3 Client](https://teamspeak.com/downloads)                                                                                                                                          |
| [qBittorrent](https://www.qbittorrent.org/download.php)                                                                                                                                        |
| [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)                                                                                                        |
| [Java 8](https://www.java.com/download) & [Java 21](https://www.oracle.com/java/technologies/downloads/#jdk21-windows)                                                                         |
| [Microsoft Office](https://github.com/farag2/Office) with [configuration](https://github.com/lowl1f3/Gerbera-Script/blob/main/src/Office/Configure.ps1)                                        |
| [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)                                                                                                                           |
</details>

## Before running

> [!NOTE]
> To work properly, [winget](https://github.com/microsoft/winget-cli) and [Windows Terminal](https://github.com/microsoft/terminal) will be installed

---

## How to use

* Download [up-to-date version](https://github.com/lowl1f3/Gerbera-Script/releases/latest);
* Expand the archive;
* Open folder with the expanded archive;
* Look through the `Gerbera.ps1` file to configure functions that you want to be run;
  * Place the "`#`" char before function if you don't want it to be run.
  * Remove the "`#`" char before function if you want it to be run.
* On `Windows 10` click `File` in File Explorer, hover over `Open Windows PowerShell`, and select `Open Windows PowerShell as Administrator` [(how-to with screenshots)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* On `Windows 11` right-click on the <kbd>Windows</kbd> icon and select `Windows Terminal (Admin)`;
* Then change the current location

  ```powershell
  Set-Location -Path "Path\To\Script\Folder"
  ```

* Set execution policy to run scripts only in the current PowerShell session

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Type `.\Gerbera.ps1` <kbd>Enter</kbd> to run the whole preset file.

### How to run the specific function(s)

To run the specific function(s) [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) the `Functions.ps1` file first:

```powershell
# With a dot at the beginning
. .\Functions.ps1
```

* Now you can do like this

```powershell
Gerbera -Functions <TAB>
Gerbera -Functions tele<TAB>
Gerbera -Functions delete<TAB>

Gerbera -Functions TelegramDesktop, DeleteInstallationFiles
```

---

## Connect with Me

[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/lowlif3)
[![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.com/users/330825971835863042)

---

## Donations

Consider supporting this project with a sprinkle of joy!🌈🚀
⠀
<a href="https://ko-fi.com/lowlife"><img src="https://storage.ko-fi.com/cdn/generated/zfskfgqnf/rest-d30761e860c553134d017c78c754b0d9-bulajus2.jpg" height="152px"></a>
