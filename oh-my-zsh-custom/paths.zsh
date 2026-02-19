# Note: These are *prepened* to the current path, so the last one take priority
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin/override:$PATH"

# Less important with low chance of ambigiguity. These are appended.
# Order matters less
export PATH="$PATH:$HOME/.cargo/bin"

# TODO: how to manage with multiple python versions ?
# export PATH="$PATH:$HOME/Library/Python/3.9/bin"

# not needed for now
# export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# ----------------
# Pyenv

# brew install pyenv
# brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)" # not needed for my specific usecase

# -----------
# rbenv

eval "$(rbenv init - --no-rehash zsh)"

# ---------
# Mise

# >>> mise bootstrap managed by local-dev >>>
# mise activation marker not set due to;
# less pollute the shell rc files directly.
# Please refer to the .envrc file in the project directory for mise activation instructions.
# TO manually activate mise, run the mise activate zsh command in your shell.
# <<< end mise bootstrap managed by local-dev <<<

# >>> local-dev managed PATH >>>
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then export PATH="$HOME/.local/bin:$PATH"; fi
# <<< end local-dev managed PATH <<<
# >>> direnv bootstrap managed by local-dev >>>
# eval "$(direnv hook zsh)" ## commented out in favour of daff
# <<< end direnv bootstrap managed by local-dev <<<
