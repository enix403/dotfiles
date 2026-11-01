#!/usr/bin/env bash
# Fedora packages. Safe to re-run.
set -euo pipefail

src="$(cd "$(dirname "$0")/../etc" && pwd)"

# Not wanted:
#   PackageKit-command-not-found: "did you mean" package lookup on unknown commands
#   zsh-syntax-highlighting: vendored in shared/zsh/thirdparty instead
sudo dnf -y remove PackageKit-command-not-found zsh-syntax-highlighting

# Third-party repos
sudo dnf -y install fedora-workstation-repositories # provides google-chrome
sudo dnf -y config-manager setopt google-chrome.enabled=1
sudo install -D -m 644 "$src/yum.repos.d/my-vscode.repo" /etc/yum.repos.d/my-vscode.repo
sudo install -D -m 644 "$src/yum.repos.d/beekeeper-studio.repo" /etc/yum.repos.d/beekeeper-studio.repo
sudo dnf -y copr enable atim/starship
sudo dnf -y copr enable keefle/glow
sudo dnf -y copr enable lihaohong/yazi
sudo dnf -y copr enable jdxcode/mise

packages=(
    # shell / cli
    zsh
    neovim
    git-lfs
    git-delta
    git-annex
    git-credential-oauth
    git-credential-libsecret
    bat
    fzf
    jq
    htop
    ncdu
    duf
    tokei
    fastfetch
    qpdf
    unar
    rclone
    darkhttpd
    wev
    clang
    starship # copr
    glow     # copr
    yazi     # copr
    mise     # copr

    # gui
    kitty
    code             # repo
    google-chrome-stable
    beekeeper-studio # repo
    gnome-extensions-app
    kruler
    gpick
    gparted
    vlc
    deluge
    zathura
    zathura-pdf-mupdf

    # fonts (nerd fonts: linux/fonts/download-fonts.sh)
    fira-code-fonts
    open-sans-fonts
)
sudo dnf -y install "${packages[@]}"

# Manual installs: see linux/FEDORA.md
