```
FArchCOS

My Arch Linux COSMIC setup script. The all in one Arch-COSMIC setup solution.
This setup script is effective for COSMIC version Alpha 7.

# Requirements
  - git
    $ sudo pacman -S git
  - yay
    $ sudo pacman -S git base-devel
    $ git clone https://aur.archlinux.org/yay.git
    $ cd yay
    $ makepkg -si

# Installation
    $ git clone https://github.com/farhnkrnapratma/farchcos.git
    $ cd farchcos
    $ chmod +x install.sh
    $ ./install.sh

# Enable Chaotic-AUR (optional) [per 04/07/2025 00:41 GMT+7]
  Home: https://aur.chaotic.cx/
    $ sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    $ sudo pacman-key --lsign-key 3056513887B78AEB
    $ sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    $ sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    $ sudo sed -i -e '$a\\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
    $ sudo pacman -Syu

# Report Problems
  Report the issue by opening a pull request or send the issue details to farhnkrnapratma@protonmail.com

Copyright 2025 Farhan Kurnia Pratama <farhnkrnapratma@protonmail.com>
```
