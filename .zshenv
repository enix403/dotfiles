# MANAGED BY KTMR/ktmr-installer/roles/homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# END MANAGED BY KTMR/ktmr-installer/roles/homebrew
# MANAGED BY KTMR/ktmr-installer/roles/nix
# source nix into the environment.
if ! command -v nix &>/dev/null; then
  if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [[ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
fi

# # hook direnv into the shell
# if command -v direnv &>/dev/null; then
#   eval "$( direnv hook "${SHELL}" )"
# fi
# # END MANAGED BY KTMR/ktmr-installer/roles/nix
# MANAGED BY KTMR/ktmr-installer/roles/ktmr
if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/ktmr/load.sh" ]]; then
  source "${XDG_CONFIG_HOME:-${HOME}/.config}/ktmr/load.sh"
fi
# END MANAGED BY KTMR/ktmr-installer/roles/ktmr
