# Fedora setup

Runbook for a fresh Fedora Workstation install. `./install-linux.sh` runs every
scripted step below in order (1, 2, 4 and 5); the rest are
manual. All scripts are safe to re-run, and a real file that would be replaced
by a symlink is moved aside to `<name>.pre-dotfiles.<timestamp>`.

## 1. Packages

```bash
linux/_apply/fedora-install-packages.sh
```

Removes the unwanted defaults, adds the third-party repos (Chrome, VS Code,
Beekeeper Studio, COPRs for starship/glow/yazi/mise) and installs everything.

## 2. System settings

```bash
linux/_apply/fedora-system-settings.sh
```

Copies the files under `linux/etc/` into `/etc` and reloads what's needed:

| File | Effect |
|---|---|
| `dnf/libdnf5.conf.d/80-user-settings.conf` | parallel downloads, fastest mirror, keep cache |
| `systemd/logind.conf.d/ignore-lid.conf` | closing the lid does nothing (stays up for SSH); applies after reboot |
| `NetworkManager/conf.d/disable-wifi-powersave.conf` | Wi-Fi power saving off |
| `udev/rules.d/92-via.rules` | VIA app can access the keyboard |

It also masks `sleep`/`suspend`/`hibernate`/`hybrid-sleep` (the machine never
sleeps) and sets zsh as the login shell.

## 3. Home Wi-Fi: stable MAC address

NetworkManager randomizes the MAC per network. To use the real one on the home
network (router reservations, etc.):

```bash
nmcli connection modify "<home SSID>" 802-11-wireless.cloned-mac-address permanent
nmcli connection up "<home SSID>"
```

## 4. Dotfiles, runtimes, fonts

```bash
shared/_apply/link-dots.sh     # shared configs into ~, ~/.config, ~/.ipython, ~/.claude
linux/_apply/link-dots.sh      # linux-only configs
shared/_apply/setup-tools.sh   # mise install, pylab venv, bat theme cache
linux/fonts/download-fonts.sh  # Fira Code Nerd Font, Maple Mono
shared/vscode/setup-vscode.sh  # settings/keybindings links + extensions
```

## 5. GNOME

```bash
linux/gnome/gnome-settings.sh
linux/gnome/gnome-keybinds.sh
```

Extensions (install from extensions.gnome.org, manage with `gnome-extensions-app`):

- No overview at start-up (`no-overview@fthx`)
- Weeks start on Monday (`weeks-start-on-monday@extensions.gnome-shell.fifi.org`)

## 6. Manual installs

Not packaged for Fedora; download the latest release by hand into `~/Applications`:

| App | Source | Format |
|---|---|---|
| typst | typst.app / GitHub releases | static binary |
| ngrok | ngrok.com/download | binary |
| bun | bun.sh install script | binary |
| Popsicle (USB flasher) | github.com/pop-os/popsicle releases | AppImage |
| MongoDB Compass | mongodb.com/try/download/compass | `.rpm` (`sudo dnf install ./mongodb-compass-*.rpm`) |

## 7. Containers

Podman images used for local databases:

```bash
podman pull docker.io/library/postgres:18.3
podman pull docker.io/library/mongo:7.0
podman pull docker.io/library/mongo:6.0
```

## Testing the scripts

A throwaway Fedora container is enough for the package script:

```bash
podman run --name fed -d fedora:43 tail -f /dev/null
podman exec -it fed bash
podman rm -f fed
```
