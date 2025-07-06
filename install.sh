#!/bin/sh

flog="tee -a /home/$USER/.farchcos_mylog"

elog() {
  echo -e "[$USER@$(date +'%H:%M:%S')] $1" | $flog
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
  elog "Checking required packages..."
  which git >/dev/null 2>&1 
  if [ $? -eq 1 ]; then
    elog "The required package 'git' is not installed."
    elog "Installing..."
    yay -S git --noconfirm 2>&1 | $flog
    ldone
  else
    elog "The required package 'git' is installed."
  fi
  if pacman -Qqg base-devel >/dev/null 2>&1 && pacman -Qqg base-devel | pacman -Qq >/dev/null 2>&1; then
    elog "The required package 'base-devel' is not installed."
    elog "Installing..."
    yay -S base-devel --noconfirm 2>&1 | $flog
    ldone
  else
    elog "The required package 'base-devel' is installed."
  fi
  which yay >/dev/null 2>&1   
  if [ $? -eq 1 ]; then
    elog "The required package 'yay' is not installed."
    elog "Installing..."
git clone https://aur.archlinux.org/yay.git 2>&1 | $flog
    cd yay
makepkg -si --noconfirm 2>&1 | $flog
    ldone
  else
    elog "The required package 'yay' is installed."
  fi
  elog "All required packages are installed."
  ldone
}

SetupCOSMIC() {
  elog "Updating software repositories index."
  yay -Syy 2>&1 | $flog
  ldone
  CheckReqs
  elog "Installing COSMIC"
  ldone
}

printf "Continue the installation? [Y/n]: "
read ans

[ -z "$ans" ] && ans=Y

case "$ans" in
  [Yy]*)
    elog "Installing..."
    SetupCOSMIC
    exit 0
    ;;
  *)
    elog "Aborted."
    exit 1
    ;;
esac
