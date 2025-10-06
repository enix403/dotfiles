# export QT_QPA_PLATFORMTHEME=qt5ct

export PATH=$HOME/bin:/usr/local/bin/override:$PATH
export PATH=/opt/homebrew/opt/ruby/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# function set_win_title(){
#    echo -ne "\033]0; $USER: $(basename "$PWD") \007"
#}

# precmd_functions+=(set_win_title)

DISABLE_AUTO_TITLE="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(colored-man-pages) # zsh-syntax-highlighting must come at end

ZSH_CUSTOM="$HOME/.config/oh-my-zsh-custom"
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
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)