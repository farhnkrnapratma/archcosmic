#!/bin/sh

RD='\033[0;31m'
GR='\033[0;32m'
BL='\033[0;34m'
NC='\033[0m'

ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
ID_LIKE=$(grep '^ID_LIKE=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_FAMILY="$ID $ID_LIKE"

echo "$OS_FAMILY" | grep -qi 'arch'

if [ $? -eq 0 ]; then
  echo "Non-Arch system detected."
  exit 1
fi

echo "\n${BL}╭━━━┳━━━╮╱╱╱╱╭╮╱╭━━━┳━━━┳━━━╮"
echo "┃╭━━┫╭━╮┃╱╱╱╱┃┃╱┃╭━╮┃╭━╮┃╭━╮┃"
echo "┃╰━━┫┃╱┃┣━┳━━┫╰━┫┃╱╰┫┃╱┃┃╰━━╮"
echo "┃╭━━┫╰━╯┃╭┫╭━┫╭╮┃┃╱╭┫┃╱┃┣━━╮┃"
echo "┃┃╱╱┃╭━╮┃┃┃╰━┫┃┃┃╰━╯┃╰━╯┃╰━╯┃"
echo "╰╯╱╱╰╯╱╰┻╯╰━━┻╯╰┻━━━┻━━━┻━━━╯${NC}\n"
echo "Arch Linux with COSMIC Epoch 1 (${GR}alpha 7${NC})\n"

SetupCOSMIC() {
  echo "COSMIC"
  echo "Done."
}

printf "Continue the installation? [Y/n]: "
read ans

[ -z "$ans" ] && ans=Y

case "$ans" in
  [Yy]*)
    echo "Installing..."
    SetupCOSMIC
    ;;
  *)
    echo "Aborted."
    exit 1
    ;;
esac
