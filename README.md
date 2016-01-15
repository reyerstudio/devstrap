# devstrap
Devstrap are bootstraps processes to deploy a development environment.

Devstrap is compatible with following platforms
- Windows 7 and further
- Linux (Ubuntu 14.04 LTS and further is only supported for the moment)
- OSX 10.11 and further

## Background
The goals of **devstrap** are following
- deploy full developpment stacks / frameworks / libraries / tools on your development platform
- install a helper tool named 'ra' (Rapid Administration) to ease the use of your development platform
- enable the same developper experience on each platform

## Prerequisites
To deploy **devstrap**, following prerequisites are required.
### Windows prerequisites
- Windows 7 and further installed
- If you're running on Windows 7, [install PowerShell 3.0](https://www.microsoft.com/en-us/download/details.aspx?id=34595). If you're running on newer version of Windows, skip this step.
- Update execution policy (Warning: Don't do that on your servers, it's insecure), open a Powershell terminal and launch

```$ set-executionpolicy unrestricted -s cu```

### Linux prerequisites
- Ubuntu 14.04 LTS (or further) installed

### Mac prerequisites
- Mac OSX 10.11 and further installed
- [Install Xcode](https://developer.apple.com/xcode)
- Install Xcode command line developper tools, open a terminal and launch 
```$ xcode-select --install```

## Installation
Installation consists on deploying the core environment for supporting 'ra' command.
### Windows
- Open Powershell terminal and launch

```$ iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/reyerstudio/devstrap/master/straps/windows/core.ps1')```

### Linux
- Open a terminal and launch

```$ bash <(curl -sL 'https://raw.githubusercontent.com/reyerstudio/devstrap/master/straps/unix/core.sh')```

### Mac
- Open a terminal and launch

```$ bash <(curl -sL 'https://raw.githubusercontent.com/reyerstudio/devstrap/master/straps/unix/core.sh')```

## References
**devstrap** processes are based on
- [Scoop](http://scoop.sh/) on Windows
- [Linuxbrew](http://brew.sh/linuxbrew/) on Linux
- [Homebrew](http://brew.sh/) on Mac
