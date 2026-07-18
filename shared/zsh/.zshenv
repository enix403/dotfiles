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

# Directory holding our split config files (base.* + int.*).
ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$HOME/dotfiles/shared/zsh/config}"

# Auto-source base config in filename order: tracked `base.*.zsh` (paths, vars)
# plus machine-local `base.x-*.zsh` / `base.*.local.zsh` overrides (gitignored,
# same spirit as the old x-* pattern). (N) => no error if the glob is empty.
for _cfg in "$ZSH_CONFIG_DIR"/base.*.zsh(N); do
  source "$_cfg"
done
unset _cfg
