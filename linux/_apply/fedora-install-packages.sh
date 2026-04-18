#!/usr/bin/env bash

sudo dnf -y install fedora-workstation-repositories

sudo dnf -y install \
  git-credential-oauth \
  git-credential-libsecret \
  neovim \
  clang \
  urar \
  zsh \
  git-lfs \
  bat \
  jq \
  ncdu \
  qpdf \
  fastfetch \
  kitty \
  htop \
  fzf \
  git-delta \
  darkhttpd \
  wev \
  gnome-extensions-app \
  kruler \
  gpick \
  gparted \
  vlc \
  zathura zathura-pdf-mupdf \
  duf \
  tokei

# COPRs
sudo dnf -y copr enable atim/starship && sudo dnf -y install starship
sudo dnf -y copr enable keefle/glow && sudo dnf -y install glow
sudo dnf -y copr enable lihaohong/yazi && sudo dnf -y install yazi
sudo dnf -y copr enable jdxcode/mise && sudo dnf -y install mise

# Google Chrome
sudo dnf -y config-manager setopt google-chrome.enabled=1 && sudo dnf -y install google-chrome-stable

# Fonts
sudo dnf -y install fira-code-fonts open-sans-fonts

: '
manual install
    bun (website, bash install script)
    typst (website, exe)
    ngrok (website, exe)
    popsicle-bin (github releases, AppImage)
    mongodb-compass (website, rpm file)

rpm repo install

    code: sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    beekeeper-studio: sudo rpm --import https://rpm.beekeeperstudio.io/beekeeper.key && sudo curl -o /etc/yum.repos.d/my-beekeeper-studio.repo https://rpm.beekeeperstudio.io/beekeeper-studio.repo
'

