<div align="right">
  This page also in:
  <a title="Русский" href="README_ru-ru.md"><img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/></a>
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

## About script

A PowerShell script for Windows that automates installing and configuring programs

Supports `Windows 10` & `Windows 11`

## Donations

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## How to use

* <a href="https://github.com/lowl1f3/Script/archive/refs/heads/main.zip"><img src="https://img.shields.io/badge/Download-%20ZIP-green&?style=for-the-badge"/></a>
* Expand the archive;
* Open folder with the expanded archive;
* Look through the `Script.ps1` file to configure functions that you want to be run;
  * Place the "#" char before function if you don't want it to be run.
  * Remove the "#" char before function if you want it to be run.
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

* Type `.\Script.ps1` <kbd>Enter</kbd> to run the whole preset file.

### How to run the specific function(s)

To run the specific function(s) [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) the `Functions.ps1` file first:

```powershell
# With a dot at the beginning
. .\Functions.ps1
```

* Now you can do like this

```powershell
Script -Functions <TAB>
Script -Functions tele<TAB>
Script -Functions delete<TAB>

Script -Functions Telegram, DeleteInstallationFiles
```

## List

> **Note**: Script requires [winget](https://github.com/microsoft/winget-cli) and a [Windows Terminal](https://github.com/microsoft/terminal) to work properly

<details>
  <summary>Programs</summary>

* [Telegram Desktop](https://desktop.telegram.org)
* [Spotify](https://www.spotify.com/download/windows)
* [Discord](https://discord.com/download)
  * [BetterDiscord](https://betterdiscord.app), [plugins](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L277) & [themes](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L378)
* [Steam](https://store.steampowered.com/about)
* [Firefox](https://www.mozilla.org/en/firefox/new/)
* [NanaZip](https://github.com/M2Team/NanaZip#-nanazip)
* [Cursor](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356)
* [Notepad++](https://notepad-plus-plus.org/downloads)
* [GitHub Desktop](https://desktop.github.com)
* [Visual Stutio Community](https://visualstudio.microsoft.com/#vs-section)
* [Visual Stutio Code](https://code.visualstudio.com/Download)
* [TeamSpeak 3 Client](https://teamspeak.com/en/downloads)
* [qBittorrent](https://www.qbittorrent.org/download.php)
* [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)
* [Java 8(JRE)](https://www.java.com/en/download) & [Java 19(JDK)](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)
* [WireGuard](https://www.wireguard.com/install)
* [Customizable](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [System Requirements](https://github.com/farag2/Sophia-Script-for-Windows#system-requirements)
</details>

## Links

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
