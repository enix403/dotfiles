#!/usr/bin/env bash
# System-level (root) settings for Fedora. Safe to re-run.
#
# Config files live in linux/etc/, mirroring their /etc paths. They are copied,
# not symlinked: root-owned /etc should not point into $HOME.
set -euo pipefail

src="$(cd "$(dirname "$0")/../etc" && pwd)"

put() { # put <path relative to /etc>
    sudo install -D -m 644 "$src/$1" "/etc/$1"
    echo "installed /etc/$1"
}

# dnf: parallel downloads, fastest mirror, keep cache
put dnf/libdnf5.conf.d/80-user-settings.conf

# Ignore lid switch (keep running and reachable over SSH with the lid closed)
put systemd/logind.conf.d/ignore-lid.conf
sudo systemctl daemon-reload
# Restarting logind would end the graphical session, so it only takes effect
# on the next boot.
echo "note: lid setting takes effect after reboot (or: sudo systemctl restart systemd-logind)"

# Never sleep/suspend/hibernate
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# undo: sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Wi-Fi power saving off
put NetworkManager/conf.d/disable-wifi-powersave.conf
sudo nmcli general reload conf

# Let the VIA app access the keyboard
put udev/rules.d/92-via.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw

# Login shell: zsh
zsh_path="$(command -v zsh)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    chsh -s "$zsh_path"
fi
