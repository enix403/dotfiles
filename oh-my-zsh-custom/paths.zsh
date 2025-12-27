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
