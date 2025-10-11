# Note: These are prepened to the current path, so the last one take priority
export PATH=$HOME/bin:$PATH
export PATH=/opt/homebrew/opt/ruby/bin:$PATH
export PATH=/usr/local/bin/override:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh-custom"

DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(fzf-tab colored-man-pages) # zsh-syntax-highlighting must come at end

source $ZSH/oh-my-zsh.sh

export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"

# Disable auto-removal of ending slash for directory paths when pressing space after tab completion
setopt no_auto_remove_slash

# remove path duplicates
typeset -U PATH

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline for paths autocompletions while typing
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=yellow
ZSH_HIGHLIGHT_STYLES[path]=fg=cyan
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[comment]='fg=blue,bg=black'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
