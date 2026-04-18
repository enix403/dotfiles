# Note: These are *prepened* to the current path, so the last one take priority

if [[ "$OSTYPE" == darwin* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

export PATH="$HOME/probin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin/override:$PATH"

# Less important with low chance of ambigiguity. These are appended.
# Order matters less
export PATH="$PATH:$HOME/.cargo/bin"

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
    eval "$(mise activate zsh)" # for interactive shells
fi

# ---------
# bun
BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"
