#!/bin/sh

flog="tee -a /home/$USER/.archcosmic"

echo -e "[$(date '+%F %T %z') | $USER@$HOSTNAME | $SHELL | $PWD]\n" | $flog

elog() {
  echo -e "[$(date '+%H:%M:%S')] $1" | $flog
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

enable_aur=0

if [ -z "$1" ]; then
  repo_type="Chaotic-AUR"
  func_name=COSMICFromCAUR
elif [ "$1" = "--arch" ]; then
  enable_aur=1
  repo_type="Arch Linux"
  func_name=COSMICFromArch
else
  elog "Unknown argument: $1"
  elog "Aborted."
  exit 1
fi

elog "Arch Linux with COSMIC Desktop Environment [$repo_type]"
elog "Homepage  : https://system76.com/cosmic"
elog "GitHub    : https://github.com/pop-os/cosmic-epoch\n"
elog "Note      : All COSMIC desktop environment packages are installed from the Chaotic-AUR repository."
elog "            If you want to use the official version from the Arch Linux repository, please add"
elog "            the '--arch' argument before running the installation script."
elog "            Example: $ ./install.sh --arch\n"
elog "Log       : $HOME/.archcosmic\n"

CheckReqs() {
  elog "Checking all requirements..."

  which git >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    noreq "git"
    sudo pacman -S git --noconfirm | $flog
    ldone
  else
    avreq "git"
  fi

  if pacman -Qqg base-devel >/dev/null 2>&1 && pacman -Qqg base-devel | pacman -Qq >/dev/null 2>&1; then
    noreq "base-devel"
    sudo pacman -S base-devel --noconfirm | $flog
    ldone
  else
    avreq "base-devel"
  fi

  which yay >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    noreq "yay"
    git clone https://aur.archlinux.org/yay.git | $flog
    cd yay || exit
    makepkg -si --noconfirm | $flog
    ldone
  else
    avreq "yay"
  fi

  if [ $enable_aur -eq 0 ]; then
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
  fi

  elog "All requirements are met."
}

servd() {
  elog "Checking service: $1"
  if ! systemctl is-active "$1"; then
    elog "Inactive. Activating service: $1"
    sudo systemctl enable "$1" | $flog
    printf "Start service '%s' now? [y/N]: " "$1" | $flog
    read -r ans

    case "$ans" in
      [Nn]*)
        elog "[$ans] Continue..."
        ;;
      [Yy]*|*)
        elog "[$ans] Starting service: $1"
        sudo systemctl start "$1"
        ;;
    esac
  else
    elog "Service '$1' is already active."
  fi
  ldone
}

RebootOpts() {
  printf "COSMIC successfully installed. Reboot now? [Y/n]: " | $flog
  read -r ans

  [ -z "$ans" ] && ans=Y

  case "$ans" in
    [Yy]*)
      reboot
      ;;
    *)
      exit 0
      ;;
  esac
}

COSMICFromCAUR() {
  elog "Installing COSMIC packages from Chaotic-AUR repository..."
  yay -S \
    chaotic-aur/cosmic-app-library-git \
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
    chaotic-aur/xdg-desktop-portal-cosmic \
    extra/power-profiles-daemon \
    extra/bluez \
    extra/bluez-utils | $flog
  ldone
}

COSMICFromArch() {
  elog "Installing COSMIC packages from Arch Linux repository..."
  yay -S \
    extra/cosmic-app-library \
    extra/cosmic-applets \
    extra/cosmic-bg \
    extra/cosmic-comp \
    extra/cosmic-files \
    extra/cosmic-greeter \
    extra/cosmic-icon-theme \
    extra/cosmic-idle \
    extra/cosmic-launcher \
    extra/cosmic-notifications \
    extra/cosmic-osd \
    extra/cosmic-panel \
    extra/cosmic-player \
    extra/cosmic-randr \
    extra/cosmic-screenshot \
    extra/cosmic-session \
    extra/cosmic-settings \
    extra/cosmic-settings-daemon \
    extra/cosmic-store \
    extra/cosmic-terminal \
    extra/cosmic-text-editor \
    extra/cosmic-wallpapers \
    extra/cosmic-workspaces \
    extra/xdg-desktop-portal-cosmic \
    extra/power-profiles-daemon \
    extra/bluez \
    extra/bluez-utils | $flog
  ldone
}

printf "Continue the installation? [Y/n]: " | $flog
read -r ans

[ -z "$ans" ] && ans=Y

case "$ans" in
  [Yy]*)
    CheckReqs
    $func_name
    servd "power-profiles-daemon"
    servd "bluetooth"
    servd "cosmic-greeter"
    RebootOpts
    exit 0
    ;;
  *)
    elog "Aborted."
    exit 1
    ;;
esac
