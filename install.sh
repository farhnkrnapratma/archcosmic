#!/bin/sh

flog=$(tee -a /home/$USER/.farchcos_mylog)

elog() {
  echo "[$USER:$(date +'%H:%M:%S')] $1" | $flog
}

done() {
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

echo "╭━━━┳━━━╮╱╱╱╱╭╮╱╭━━━┳━━━┳━━━╮"
echo "┃╭━━┫╭━╮┃╱╱╱╱┃┃╱┃╭━╮┃╭━╮┃╭━╮┃"
echo "┃╰━━┫┃╱┃┣━┳━━┫╰━┫┃╱╰┫┃╱┃┃╰━━╮"
echo "┃╭━━┫╰━╯┃╭┫╭━┫╭╮┃┃╱╭┫┃╱┃┣━━╮┃"
echo "┃┃╱╱┃╭━╮┃┃┃╰━┫┃┃┃╰━╯┃╰━╯┃╰━╯┃"
echo "╰╯╱╱╰╯╱╰┻╯╰━━┻╯╰┻━━━┻━━━┻━━━╯\n"
echo "Arch Linux with COSMIC Epoch 1 (alpha 7)\n"

CheckReqs() {
  elog "Checking required packages..."
  which git
  if [ $? -eq 1 ]; then
    elog "The required package 'git' is not installed."
    elog "Installing..."
    sudo pacman -S git --noconfirm 2>&1 | $flog
    done
  else
    elog "The required package 'git' is installed."
  fi
  which base-devel
  if [ $? -eq 1 ]; then
    elog "The required package 'base-devel' is not installed."
    elog "Installing..."
    sudo pacman -S base-devel --noconfirm 2>&1 | $flog
    done
  else
    elog "The required package 'base-devel' is installed."
  fi
  which yay
  if [ $? -eq 1 ]; then
    elog "The required package 'yay' is not installed."
    elog "Installing..."
    git clone https://aur.archlinux.org/yay.git 2>&1 | flog
    cd yay
    makepkg -si 2>&1 | $flog
    done
  else
    elog "The required package 'yay' is installed."
  fi
  elog "All required packages are installed."
  done
}

SetupCOSMIC() {
  elog "Updating software repositories index."
  sudo pacman -Sy
  done
  CheckReqs
  elog "Installing COSMIC"
  done
}

printf "Continue the installation? [Y/n]: "
read ans

[ -z "$ans" ] && ans=Y

case "$ans" in
  [Yy]*)
    elog "Installing..."
    SetupCOSMIC
    done
    exit 0
    ;;
  *)
    elog "Aborted."
    exit 1
    ;;
esac
