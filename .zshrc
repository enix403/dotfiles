# History file location
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=50000

# Make history more robust
setopt HIST_IGNORE_ALL_DUPS      # Don't record duplicate commands
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY          # Add timestamps

# Real fix: prevent overwrites
setopt APPEND_HISTORY            # Append, don't overwrite
setopt INC_APPEND_HISTORY        # Write as you go, not only on exit
setopt SHARE_HISTORY             # Share history between sessions
setopt HIST_FCNTL_LOCK           # Prevent race condition truncation

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/oh-my-zsh-custom"

DISABLE_AUTO_TITLE="true"

# brew install olets/tap/zsh-window-title
source /opt/homebrew/share/zsh-window-title/zsh-window-title.zsh

DISABLE_UNTRACKED_FILES_DIRTY="true"
# git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
#   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
# plugins=(fast-syntax-highlighting)
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
