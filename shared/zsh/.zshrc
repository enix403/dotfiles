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

# NOTE: PATH/env setup and `typeset -U PATH` live in the base config (.zshenv),
# which zsh always sources before this file. Everything below is interactive-only.

# Load $fg_bold / $bg / $reset_color color assoc arrays (used by colored-man-pages)
autoload -U colors && colors

# ==============================
# ==== Config / cache paths ====
# ==============================
# $ZSH_DIR is the zsh root; $ZSH_CONFIG_DIR/ holds the autoloaded config files
# (base.*/int.*), while vendored lib/ and thirdparty/ live directly under
# $ZSH_DIR. Normally already set by .zshenv; the fallbacks keep this file usable
# if sourced on its own.
ZSH_DIR="${ZSH_DIR:-$HOME/dotfiles/shared/zsh}"
ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-$ZSH_DIR/config}"
ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# =====================
# ==== Completion  ====
# =====================
# Initialize the completion system once (cached in $ZSH_CACHE_DIR). This must
# run before anything that calls `compdef` (e.g. lib/directories.zsh below and
# our custom kubectl completions).
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"
# bash-style completion scripts (some tools ship these)
autoload -Uz bashcompinit && bashcompinit

# ===============================
# ==== Vendored OMZ lib bits ====
# ===============================
# Small self-contained pieces we used to get from Oh My Zsh's lib/.
# (nav aliases + auto_pushd, interactive keybindings, completion zstyles)
source "$ZSH_DIR/lib/completion.zsh"
source "$ZSH_DIR/lib/directories.zsh"
source "$ZSH_DIR/lib/key-bindings.zsh"

# =================
# ==== Plugins ====
# =================

# colored-man-pages (vendored, was an OMZ plugin)
source "$ZSH_DIR/thirdparty/colored-man-pages/colored-man-pages.plugin.zsh"

# fzf-tab (vendored). Must load AFTER compinit and BEFORE zsh-syntax-highlighting.
source "$ZSH_DIR/thirdparty/fzf-tab/fzf-tab.plugin.zsh"

# ==========================
# ==== Custom shell cfg ====
# ==========================
# Auto-source our interactive config files (int.aliases.*, plus int.x-* work
# symlinks and any int.*.local.zsh). The base.* files were already sourced by
# .zshenv. (N) => no error if the glob matches nothing. Sorted alphabetically,
# preserving the numeric load-ordering in the filenames.
for _cfg in "$ZSH_CONFIG_DIR"/int.*.zsh(N); do
  source "$_cfg"
done
unset _cfg

# ===================
# ==== Syntax HL ====
# ===================
# Configuration for the zsh-syntax-highlighting plugin (sourced last, below).

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

# zsh-syntax-highlighting (vendored) MUST be sourced last.
source "$ZSH_DIR/thirdparty/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# =======================
# ==== Third Parties ====
# =======================

# --- window title script ---
source "$ZSH_DIR/thirdparty/zsh-window-title.zsh"

# ======================
# ====== Starship ======
# ======================

export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"
