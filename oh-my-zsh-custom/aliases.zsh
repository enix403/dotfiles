alias mkf="touch"
alias mkd="mkdir"
alias uz="unzip"
alias cls="clear"
alias where="which"
alias ip="ip -c"

alias cp="cp -i"                          # confirm before overwriting something
alias mv="mv -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -h'                      # human-readable sizes
alias grep='grep --color=auto'
unalias l
alias ls="LC_COLLATE=C ls --color=auto -lh --group-directories-first"
alias la="LC_COLLATE=C ls --color=auto -Alh --group-directories-first"
alias lsblk="lsblk --fs"
alias glow="glow -p"

# putting a whitespace after the second 'xargs' notifies the shell to also try and match an alias for
# the next token, thus allowing us to use shell aliases within the xargs command
# e.g `echo some-stuff | xargs la` will try to find an alias for the (next) `la` command, which it does
# find (see above aliases) so the command will become:
# `echo some-stuff | xargs ls --color=auto -Alh --group-directories-first`
alias xargs='xargs '
# Note: if you do want to use the actual 'la' command (not the alias) then just wrap it in quotes like: xargs "la"

alias sudo='sudo '

alias b="bundle"
alias be="bundle exec"
alias ghk="git checkout HEAD -- hooks/pre-commit"

alias cloc='cloc --vcs=git'

alias glog="git log --oneline --color=always"
alias sclone="git clone --depth 1 --single-branch"    # Shallow clone a git repo

export DOTFILES_PATH=~/dotfiles

alias v="nvim"
alias g="git"
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kl="kubectl logs"
alias bz="bazel"
alias kr="killall -9 ranger" # Ranger likes to freeze a lot, and I Ctrl+Z my way out of it and use this alias to clean it up
alias rscopy="rsync -av --progress"
alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges
alias kitty_ssh="kitty +kitten ssh"
alias dot='cd "$DOTFILES_PATH"'
alias diskusage="df -h | grep -vE \"^(tmpfs|run|dev)\" | (sed -u 1q; sort)"
alias bat='bat --theme=gruvbox-dark --style=header'
alias rh='ranger ~ && clear'
alias rr='ranger . && clear'
alias feh="feh --scale-down --auto-zoom --draw-filename --action9 \";feh --bg-scale '%f'\""
alias mee="source .me.env 1>/dev/null 2>&1 || :"
alias acv="source .venv/bin/activate && mee" # I mostly name my python virtual environments `.venv`

# Find files eating up diskspace ("ddu = debug du")
# ddu /some/folder/*
alias ddu="du -Pcshx"

alias kff="killall -9 firefox"

# ================ functions for common tasks ================

function showp() { echo $(pwd)/"$@" }

alias kxx="kubectl config get-contexts"
function kx() {
  # "kx" lists all available kubernetes contexts
  if [ $# -eq 0 ]; then
    kubectl config current-context
  elif [ $# -eq 1 ]; then
    # "kx <context> sets the given context as current"
    kubectl config use-context "$1"
  else
    echo "Usage: kx [context-name]" >&2
    return 1
  fi
}

# native zsh completion
_kx() {
  local -a contexts
  contexts=($(kubectl config get-contexts -o name 2>/dev/null))
  _describe 'context' contexts
}

compdef _kx kx

function userignore() {
    local git_root;
    git_root=$(git rev-parse --show-toplevel) || return $?;
    vim "$git_root/.git/info/exclude"
}


# Do some math: mth "56 + 80"
function mth() { echo $(( $1 )) }

# Make executable files
function mke() {
    all_args=( "$@" )
    touch "${all_args[@]}"
    chmod +x "${all_args[@]}"
}

# Returns a random ASCII key of the specified length: gen_rand_key 60
function gen_rand_key() {
    tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]_{|}' </dev/urandom | head -c ${1:-64}; echo
}

# Print each argument given on a new line (It is needed sometimes for debugging)
function echol() {
    for arg in "$@"
    do
        echo $arg;
    done
}
