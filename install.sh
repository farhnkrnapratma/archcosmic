#!/bin/sh

trap 'echo "An error occurred on line $LINENO"; exit 1' ERR
set -e

flog="tee -a /home/$USER/.farchcos_mylog"

echo -e "[$(date '+%Y-%m-%d %H:%M:%S %Z') | $USER@$HOSTNAME | $SHELL | $PWD]\n"

elog() {
  echo -e "[$(date +'%H:%M:%S')] $1" | $flog
}

noreq() {
  elog "The requirement of ‘$1’ is not met."
  elog "Resolving..."
}

avreq() {
  elog "The requirement of ‘$1’ is met."
}

ldone() {
  elog "Done."
}

ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
ID_LIKE=$(grep '^ID_LIKE=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_FAMILY="$ID $ID_LIKE"

echo "$OS_FAMILY" | grep -qi 'arch'

if [ $? -eq 1 ]; then
  elog "Non-Arch system detected."
  elog "Aborted."
  exit 1
fi

elog "╭━━━┳━━━╮╱╱╱╱╭╮╱╭━━━┳━━━┳━━━╮"
elog "┃╭━━┫╭━╮┃╱╱╱╱┃┃╱┃╭━╮┃╭━╮┃╭━╮┃"
elog "┃╰━━┫┃╱┃┣━┳━━┫╰━┫┃╱╰┫┃╱┃┃╰━━╮"
elog "┃╭━━┫╰━╯┃╭┫╭━┫╭╮┃┃╱╭┫┃╱┃┣━━╮┃"
elog "┃┃╱╱┃╭━╮┃┃┃╰━┫┃┃┃╰━╯┃╰━╯┃╰━╯┃"
elog "╰╯╱╱╰╯╱╰┻╯╰━━┻╯╰┻━━━┻━━━┻━━━╯\n"
elog "Arch Linux with COSMIC Epoch 1 (alpha 7)"
elog "Log: /home/$USER/.farchcos_mylog\n"

CheckReqs() {
  elog "Checking all requirements..."

  which git >/dev/null 2>&1 
  if [ $? -eq 1 ]; then
    noreq "git"
    sudo pacman -S git --noconfirm 2>&1 | $flog
    ldone
  else
    avreq "git"
  fi

  if pacman -Qqg base-devel >/dev/null 2>&1 && pacman -Qqg base-devel | pacman -Qq >/dev/null 2>&1; then
    noreq "base-devel"
    sudo pacman -S base-devel --noconfirm 2>&1 | $flog
    ldone
  else
    avreq "base-devel"
  fi

  which yay >/dev/null 2>&1   
  if [ $? -eq 1 ]; then
    noreq "yay"
    git clone https://aur.archlinux.org/yay.git 2>&1 | $flog
    cd yay || exit
    makepkg -si --noconfirm 2>&1 | $flog
    ldone
  else
    avreq "yay"
  fi

  if grep "^\[chaotic-aur\]" /etc/pacman.conf >/dev/null 2>&1; then
    avreq "chaotic-aur"
  else
    noreq "chaotic-aur"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com | $flog
    sudo pacman-key --lsign-key 3056513887B78AEB | $flog
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' | $flog
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' | $flog
    echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
    echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | $flog
    yay -Syu | $flog
    ldone
  fi

  elog "All requirements are met."
}

InstallCOSMIC() {
  CheckReqs

  elog "Installing COSMIC..."
  yay -S chaotic-aur/cosmic-app-library-git \
    chaotic-aur/cosmic-applets-git \
    chaotic-aur/cosmic-bg-git \
    chaotic-aur/cosmic-comp-git \
    chaotic-aur/cosmic-edit-git \
    chaotic-aur/cosmic-files-git \
    chaotic-aur/cosmic-greeter-git \
    chaotic-aur/cosmic-icons-git \
    chaotic-aur/cosmic-idle-git \
    chaotic-aur/cosmic-launcher-git \
    chaotic-aur/cosmic-notifications-git \
    chaotic-aur/cosmic-osd-git \
    chaotic-aur/cosmic-panel-git \
    chaotic-aur/cosmic-player-git \
    chaotic-aur/cosmic-randr-git \
    chaotic-aur/cosmic-screenshot-git \
    chaotic-aur/cosmic-session-git \
    chaotic-aur/cosmic-settings-daemon-git \
    chaotic-aur/cosmic-settings-git \
    chaotic-aur/cosmic-store-git \
    chaotic-aur/cosmic-term-git \
    chaotic-aur/cosmic-wallpapers-git \
    chaotic-aur/cosmic-workspaces-git \
    extra/power-profiles-daemon \
    extra/bluez \
    extra/bluez-utils | $flog
  ldone

  elog "Activating services..."
  sudo systemctl status power-profiles-daemon | $flog
  sudo systemctl enable power-profiles-daemon | $flog
  sudo systemctl start power-profiles-daemon | $flog

  sudo systemctl status bluetooth | $flog
  sudo systemctl enable bluetooth | $flog
  sudo systemctl start bluetooth | $flog
  
  sudo systemctl status cosmic-greeter | $flog
  sudo systemctl enable cosmic-greeter | $flog
  ldone
}

RebootOpts() {
  printf "COSMIC successfully installed. Reboot now? [Y/n]: "
  read -r ans

  [ -z "$ans" ] && ans=Y

  case "$ans" in
    [Yy]*)
      reboot
      ;;
    *)
      elog "Exiting..."
      exit 0
      ;;
  esac
}

printf "Continue the installation? [Y/n]: "
read -r ans

[ -z "$ans" ] && ans=Y

case "$ans" in
  [Yy]*)
    elog "Installing..."
    InstallCOSMIC
    RebootOpts
    exit 0
    ;;
  *)
    elog "Aborted."
    exit 1
    ;;
esac
