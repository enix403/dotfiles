# ====================
# ==== Native ZSH ====
# ====================

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

# Disable auto-removal of ending slash for directory paths when pressing space after tab completion
setopt no_auto_remove_slash

# remove path duplicates
typeset -U PATH

# ===================
# ==== Oh My ZSH ====
# ===================

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/oh-my-zsh-custom"

# Prevent OMZ from changing title. TODO: why is this here btw ? is it needed ?
DISABLE_AUTO_TITLE="true"

# Prevent OMZ from running git status for its prompts. (TODO: is this needed ?)
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    colored-man-pages
    fzf-tab
    # zsh-syntax-highlighting must come at end
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ===================
# ==== Syntax HL ====
# ===================

# Configuration for zsh-syntax-highlighting plugin above

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

# =======================
# ==== Third Parties ====
# =======================

# --- window title script ---
source $ZSH_CUSTOM/thirdparty/zsh-window-title.zsh

# ======================
# ====== Starship ======
# ======================

export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"

# ===================
# ====== Other ======
# ===================

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
