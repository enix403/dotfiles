#!/usr/bin/env bash
# Bootstrap a fresh Fedora Workstation. Every step is safe to re-run; existing
# files that would be replaced by a symlink are moved aside, not deleted.
# Manual steps: linux/FEDORA.md
set -euo pipefail
cd "$(dirname "$0")"

[ "$(uname -s)" = Linux ] || { echo "install-linux.sh: not Linux" >&2; exit 1; }

echo -e '\033[1mThis will install packages, change system settings and replace configs with symlinks into this repo.\033[0m'
echo -ne '\033[1mContinue? [y/N]: \033[0m'
read -r reply
[[ $reply =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

step() { echo -e "\n\033[1m==> $1\033[0m"; }

step "Packages";        ./linux/_apply/fedora-install-packages.sh
step "System settings"; ./linux/_apply/fedora-system-settings.sh
step "Link dotfiles";   ./shared/_apply/link-dots.sh; ./linux/_apply/link-dots.sh
step "Tools";           ./shared/_apply/setup-tools.sh
step "Fonts";           ./linux/fonts/download-fonts.sh
step "GNOME";           ./linux/gnome/gnome-settings.sh; ./linux/gnome/gnome-keybinds.sh
step "VS Code";         ./shared/vscode/setup-vscode.sh

step "Done. Remaining manual steps: linux/FEDORA.md"
