# Note: prepended dirs win (last prepend = highest priority).

if [[ "$OSTYPE" == darwin* ]]; then
    # Homebrew env (PATH, MANPATH, HOMEBREW_PREFIX, ...). Moved here from the
    # KTMR-managed ~/.zshenv so it's owned by the repo.
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ---------
# bun
BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"

# Less important with low chance of ambiguity. These are appended.
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"

# ===========================================================================
# Front-priority dirs.
#
# Kept in a function so it can be re-run: on macOS, path_helper (invoked from
# /etc/zprofile on LOGIN shells, *after* .zshenv) prepends the system dirs
# (/usr/bin, /bin, ...) to the front, which would otherwise shadow these — e.g.
# /bin/ls (BSD) winning over /usr/local/bin/override/ls (GNU). ~/.zprofile
# re-calls this after path_helper to restore priority. Non-login shells never
# run path_helper, so the single call below is enough for them.
#
# `typeset -U PATH` (set in .zshenv) makes re-prepending an existing entry just
# promote it to the front, so calling this twice is safe and idempotent.
# ===========================================================================
_zsh_prioritize_path() {
  local d
  # Lowest priority first; the last one prepended ends up front-most.
  for d in \
    /opt/homebrew/sbin \
    /opt/homebrew/bin \
    /opt/homebrew/opt/ruby/bin \
    "$HOME/probin" \
    "$HOME/bin" \
    /usr/local/bin \
    /usr/local/bin/override
  do
    [[ -d "$d" ]] && export PATH="$d:$PATH"
  done
}
_zsh_prioritize_path

# ----------------
# mise: activated on every OS and in every shell (base, not interactive-only),
# so mise tools also resolve in scripts and `zsh -c`. Runs after the PATH setup
# above because mise itself may live in ~/.local/bin (appended above), and after
# _zsh_prioritize_path so mise's tool dirs sit in front of Homebrew's.
(( $+commands[mise] )) && eval "$(mise activate zsh)"
