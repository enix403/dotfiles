alias mkf="touch"
alias mkd="mkdir"
alias cls="clear"
alias where="which"

alias grep='grep --color=auto'

alias ls="ls --color=auto -lh --group-directories-first"
alias la="ls --color=auto -Alh --group-directories-first"
alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges

alias gitlog="git log --oneline --color=always"

# ================ functions for common tasks ================

function network-info() { http --json get "http://ifconfig.me/all.json" }
function deldockerlogs() { sudo find /var/lib/docker/containers/ -type f -name "*.log" -delete }
function mth() { echo $(( "$1" )) }
function mkf-exe() { touch $1 && chmod +x $1; } # make an executable file (script)

function gen-rand-key() {
    tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]_{|}' </dev/urandom | head -c $1; echo
}

function start-sublime-project() {
    project_file=$(find . -maxdepth 1 -type f -iname "*.sublime-project" | head -1)
    if [[ $project_file != "" ]]
    then
       echo "Using project file: $project_file"
       subl --project $project_file
    else
        echo "No .sublime-project file found"
        return 1
    fi
}