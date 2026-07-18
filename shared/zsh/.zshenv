# =========================================================
# ==== Base config — sourced for EVERY zsh invocation  ====
# =========================================================
# zsh reads .zshenv for all shells: interactive, scripts, `zsh -c`, cron,
# ssh commands. Keep this to what non-interactive shells need — PATH and
# environment. Interactive-only setup (prompt, completion, plugins, aliases,
# keybindings, history) lives in .zshrc.
#
# ~/.zshenv is a symlink to this file (see shared/_apply/link-dots.sh). It
# used to be managed by KTMR, which only ran `brew shellenv`; that now lives
# in base.paths.10-default.zsh so the whole thing is repo-owned.

# Remove PATH duplicates. `typeset -U` keeps the FIRST occurrence, so a later
# re-prepend of an existing entry promotes it to the front.
typeset -U PATH path

# Root of the zsh setup, and the config dir under it. `config/` holds only
# autoloaded files (base.* + int.*); vendored lib/ and thirdparty/ live beside
# it under $ZSH_DIR and are sourced explicitly by .zshrc.
ZSH_DIR="${ZSH_DIR:-$HOME/dotfiles/shared/zsh}"
ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$ZSH_DIR/config}"

# Auto-source base config in filename order: tracked `base.*.zsh` (paths, vars)
# plus machine-local `base.x-*.zsh` / `base.*.local.zsh` overrides (gitignored,
# same spirit as the old x-* pattern). (N) => no error if the glob is empty.
for _cfg in "$ZSH_CONFIG_DIR"/base.*.zsh(N); do
  source "$_cfg"
done
unset _cfg
