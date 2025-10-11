export DOTFILES_PATH=~/dotfiles
alias dot='cd "$DOTFILES_PATH"'

# ======= Absolute Necessaties =========
# Things I cannot live without

unalias l
alias ls="LC_COLLATE=C ls --color=auto -lh --group-directories-first"
alias la="LC_COLLATE=C ls --color=auto -Alh --group-directories-first"
alias cls="clear"
alias where="which"
alias mkd="mkdir"
alias mkf="touch"
function mke() {
    # Make executable files
    all_args=( "$@" )
    touch "${all_args[@]}"
    chmod +x "${all_args[@]}"
}
alias cp="cp -i"
alias mv="mv -i"

# ======= Common Linux Tools =========
# Tools that I regularly use, tweaked to my liking

alias sudo='sudo '
alias xargs='xargs '
alias ip="ip -c"
alias uz="unzip"
alias df='df -h'
alias free='free -h'
alias grep='grep --color=auto'
alias diskusage="df -h | grep -vE \"^(tmpfs|run|dev)\" | (sed -u 1q; sort)"
alias ddu="du -Pcshx"
alias rscopy="rsync -av --progress"
alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges
alias bat='bat --theme=gruvbox-dark --style=header'
alias feh="feh --scale-down --auto-zoom --draw-filename --action9 \";feh --bg-scale '%f'\""

# Non essentials, but cool
alias tree="erd --human --icons --sort=name --dir-order=last --layout=inverted --suppress-size"

# ======= Custom Shortcuts =========
# My custom workflows/shortcuts

alias mee="source .me.env 1>/dev/null 2>&1 || :"
alias acv="source .venv/bin/activate && mee"

alias kff="killall -9 firefox"
alias kr="killall -9 ranger"

# Print the absolute path to the given file
function showp() { echo $(pwd)/"$@" }

# Do some math: mth "56 + 80"
function mth() { echo $(( $1 )) }

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

# ===========================
# ---------- Tools ----------
# ===========================
# Dedicated aliases for each tool

# ========== Ranger ==========

alias rh='ranger ~ && clear'
alias rr='ranger . && clear'

# ========== Yazi ==========

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# ========== Cloc ==========

alias cloc='cloc --vcs=git'

# ========== Git ==========

alias g="git"
alias sclone="git clone --depth 1 --single-branch"
function userignore() {
    local git_root;
    git_root=$(git rev-parse --show-toplevel) || return $?;
    vim "$git_root/.git/info/exclude"
}

# ========== Vim ==========

alias v="nvim"

# ========== Kubernetes ==========

alias k="kubectl"
function kx() {
    if [ $# -eq 0 ]; then
        # "kx" lists all available kubernetes contexts
        kubectl config current-context
    elif [ $# -eq 1 ]; then
        # "kx <context> sets the given context as current"
        kubectl config use-context "$1"
    else
        echo "Usage: kx [context-name]" >&2
        return 1
    fi
}
_kx() {
    local -a contexts
    contexts=($(kubectl config get-contexts -o name 2>/dev/null))
    _describe 'context' contexts
}
compdef _kx kx
alias kxx="kubectl config get-contexts"

# ========== Bundle ==========

alias b="bundle"
alias be="bundle exec"

# ========== Bazel ==========

alias bz="bazel"
