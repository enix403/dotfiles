alias mkf="touch"
alias mkd="mkdir"
alias cls="clear"
alias where="which"
alias more=less

alias cp="cp -i"                          # confirm before overwriting something
alias mv="mv -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -h'                      # human-readable sizes
alias grep='grep --color=auto'
alias ls="ls --color=auto -lh --group-directories-first"
alias la="ls --color=auto -Alh --group-directories-first"

# putting a whitespace after the second 'xargs' notifies the shell to also try and match an alias for
# the next token, thus allowing us to use shell aliases within the xargs command
# e.g `echo some-stuff | xargs la` will try to find an alias for the (next) `la` command, which it does
# find (see above aliases) so the command will become:
# `echo some-stuff | xargs ls --color=auto -Alh --group-directories-first`
alias xargs='xargs '
# Note: if you do want to use the actual 'la' command (not the alias) then just wrap it in quotes like: xargs "la"

alias sudo='sudo '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias gitlog="git log --oneline --color=always"
alias sclone="git clone --depth 1 --single-branch"    # Shallow clone a git repo

alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges
alias kitty_ssh="kitty +kitten ssh"
alias gpu_vendor='glxinfo | grep --color "server glx vendor string"'
alias dotfiles="cd ~/dotfiles"

# ================ functions for common tasks ================

function network-info() { http --json get "http://ifconfig.me/all.json" }
function deldockerlogs() { sudo find /var/lib/docker/containers/ -type f -name "*.log" -delete }

# Do some math: mth "56 + 80"
function mth() { echo $(( $1 )) }

# Make an executable file
function mkf-exe() { touch $1 && chmod +x $1; } 

# Give me a random generic key that can be used for a variety of purposes
# Note: It optionally takes an argument specifying the length of the key, for example: gen-rand-key 128
function gen-rand-key() {
    tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]_{|}' </dev/urandom | head -c ${1:-64}; echo
}

# Find a .sublime-project file in the current working directory and open it in sublime text 
function start-sublime-project() {
    project_file=$(find . -maxdepth 1 -type f -iname "*.sublime-project" | head -1)
    if [[ $project_file != "" ]]
    then
       echo "Using project file: $project_file"
       subl -a --project $project_file
    else
        echo "No .sublime-project file found"
        return 1
    fi
}

# Print each argument given on a new line (I need it sometimes for debugging)
function print_sep_lines() {
    for arg in "$@"
    do
        echo $arg;
    done
}
