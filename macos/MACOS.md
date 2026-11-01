# macOS setup

Runbook for a new Mac. `./install-macos.sh` runs steps 1–3; the rest are manual.
All scripts are safe to re-run.

## 1. Homebrew packages

Install [Homebrew](https://brew.sh), then `install-macos.sh` trusts the
third-party taps and runs `brew bundle --no-upgrade --file macos/Brewfile`.

## 2. Dotfiles and tools

```bash
shared/_apply/link-dots.sh     # shared configs into ~, ~/.config, ~/.ipython, ~/.claude
macos/_apply/link-dots.sh      # aerospace, karabiner, zathura
shared/_apply/setup-tools.sh   # mise install, pylab venv, bat theme cache
shared/vscode/setup-vscode.sh  # settings/keybindings links + extensions
```

## 3. System Settings

```bash
macos/defaults.sh
```

Writes the settings that differ from the macOS defaults: appearance, Dock
(including the pinned apps), keyboard repeat and shortcuts, trackpad, menu bar
clock, Finder, Stage Manager. Log out and back in afterwards. Give the terminal
Full Disk Access first, or the two Accessibility writes fail with a warning.

### Adding a setting

```bash
defaults-diff snap   # snapshot every preference domain
# ...change the setting in System Settings...
defaults-diff        # shows the domain and key that changed
```

Then add the matching `defaults write` line to `macos/defaults.sh`. Leave out
anything work-specific or set by the employer's MDM.

## 4. Manual steps

macOS doesn't let scripts do these.

**Privacy & Security** (System Settings > Privacy & Security):

| Permission | Apps |
|---|---|
| Accessibility | AeroSpace, Karabiner-Elements, Scroll Reverser |
| Input Monitoring | Karabiner-Elements (`karabiner_grabber`, `karabiner_observer`) |
| Full Disk Access | kitty |

Karabiner also asks to allow its driver extension under General > Login Items &
Extensions.

**Login items** (General > Login Items & Extensions > Open at Login):
AeroSpace, Scroll Reverser, noTunes.

**Apps installed outside Homebrew:** Visual Studio Code, Cursor,
Karabiner-Elements, Google Chrome, Firefox, Slack. Browsers restore their
settings through account sync.

**Not scripted, set by hand if wanted:** Finder sidebar favorites, per-app
notification settings, Touch ID, Wi-Fi, input sources.

## Not included on purpose

- Raw `~/Library/Preferences` copies: binary, tied to the macOS version, and they
  hold work data.
- Settings enforced by the employer's MDM (firewall, screensaver, software
  update, login window): a managed Mac gets them from IT.
- Migration Assistant: copies old clutter and MDM leftovers to the new machine.
