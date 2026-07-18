# Note: prepended dirs win (last prepend = highest priority).

if [[ "$OSTYPE" == darwin* ]]; then
    # Homebrew env (PATH, MANPATH, HOMEBREW_PREFIX, ...). Moved here from the
    # KTMR-managed ~/.zshenv so it's owned by the repo.
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ----------------
# Pyenv (TODO: get rid of it in favor of mise)

# brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig pyenv
PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d $PYENV_ROOT/bin ]] && eval "$(pyenv init - zsh)"

# ----------------
# Mise (my own one)

# if [[ "$HOST" == "radium-fed" && "$OSTYPE" == linux* ]]; then
if [[ "$OSTYPE" == linux* ]]; then
    # for interactive shells
    eval "$(mise activate zsh)"
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
    /usr/local/bin/override \
    "$PYENV_ROOT/shims"
  do
    [[ -d "$d" ]] && export PATH="$d:$PATH"
  done
}
_zsh_prioritize_path
