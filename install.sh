#!/bin/sh

flog="tee -a /home/$USER/.archcosmic"

echo -e "[$(date '+%F %T %z') | $USER@$HOSTNAME | $SHELL | $PWD]\n" | "$flog"

elog() {
	echo -e "[$(date '+%H:%M:%S')] $1" | "$flog"
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

elog "Arch Linux with COSMIC Desktop Environment"
elog "Homepage  : https://system76.com/cosmic"
elog "GitHub    : https://github.com/pop-os/cosmic-epoch\n"
elog "Log       : $HOME/.archcosmic\n"

servd() {
	elog "Checking service: $1"
	if ! systemctl is-active "$1"; then
		elog "Inactive. Activating service: $1"
		sudo systemctl enable "$1" | "$flog"
		printf "Start service '%s' now? [y/N]: " "$1" | "$flog"
		read -r ans

		case "$ans" in
		[Nn]*)
			elog "[$ans] Continue..."
			;;
		[Yy]* | *)
			elog "[$ans] Starting service: $1"
			sudo systemctl start "$1"
			;;
		esac
	else
		elog "Service '$1' is already active."
	fi
	ldone
}

Install_COSMIC() {
	elog "Installing COSMIC..."
	sudo pacman -S \
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
		extra/bluez-utils --noconfirm --quiet --disable-download-timeout --needed | "$flog"
	ldone
}

printf "Continue the installation? [Y/n]: " | "$flog"
read -r ans

[ "$ans" = "" ] && ans=Y

case "$ans" in
[Yy]*)
	Install_COSMIC
	servd "power-profiles-daemon"
	servd "bluetooth"
	servd "cosmic-greeter"
	exit 0
	;;
*)
	elog "Aborted."
	exit 1
	;;
esac
