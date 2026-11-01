#!/usr/bin/env bash
# Link dotfiles and set up tools on macOS. Every step is safe to re-run;
# existing files that would be replaced by a symlink are moved aside, not deleted.
# Assumes Homebrew is installed. Apps outside the Brewfile (VS Code, Karabiner, ...)
# are installed by hand.
set -euo pipefail
cd "$(dirname "$0")"

[ "$(uname -s)" = Darwin ] || { echo "install-macos.sh: not macOS" >&2; exit 1; }

echo -e '\033[1mThis will install Homebrew packages, replace configs with symlinks into this repo and apply macOS settings.\033[0m'
echo -ne '\033[1mContinue? [y/N]: \033[0m'
read -r reply
[[ $reply =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

step() { echo -e "\n\033[1m==> $1\033[0m"; }

# Third-party taps whose formulae/casks Homebrew refuses to load until trusted.
TRUSTED_TAPS=(homebrew-zathura/zathura nikitabobko/tap macos-fuse-t/cask minchenlee/tap)

step "Homebrew"
for tap in "${TRUSTED_TAPS[@]}"; do
    brew tap "$tap"
    brew trust --tap "$tap"
done
brew bundle --no-upgrade --file macos/Brewfile

step "mise"
if ! command -v mise >/dev/null && [ ! -x ~/.local/bin/mise ]; then
    curl -fsSL https://mise.run | sh # installs to ~/.local/bin
fi
export PATH="$HOME/.local/bin:$PATH"

step "Link dotfiles"; ./shared/_apply/link-dots.sh; ./macos/_apply/link-dots.sh
step "Tools";         ./shared/_apply/setup-tools.sh
step "VS Code";       ./shared/vscode/setup-vscode.sh
step "macOS settings"; ./macos/defaults.sh

echo -e "\nManual steps (permissions, login items, ...): macos/MACOS.md"
