alias mkf="touch"
alias mkd="mkdir"
alias cls="clear"
alias where="which"
alias more=less
alias ip="ip -c"

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

alias kr="killall -9 ranger" # Ranger likes to freeze a lot, and I Ctrl+Z my way out of it and use this alias to clean it up

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias gitlog="git log --oneline --color=always"
alias sclone="git clone --depth 1 --single-branch"    # Shallow clone a git repo

export DOTFILES_PATH=~/dotfiles

alias rscopy="rsync -av --progress"
alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges
alias kitty_ssh="kitty +kitten ssh"
alias icat="kitty +kitten icat"
alias gpu_vendor='glxinfo | grep --color "server glx vendor string"'
alias fix_indent="prettier --tab-width 4 --write"
alias dotfiles='cd "$DOTFILES_PATH"'
alias diskusage="df -h | grep -vE \"^(tmpfs|run|dev)\""
alias bat='bat --theme="gruvbox-dark"'
alias rh='ranger ~ && clear'
alias rr='ranger . && clear'
alias feh_img="feh --scale-down --auto-zoom --draw-filename"
alias gdf="git difftool --dir-diff"
alias redfilter='redshift -PO'
alias resetredfilter='redshift -PO 6500'

# ================ functions for common tasks ================

function set_active_wall() {
    local active_wall_target=~/Pictures/wallpapers/ACTIVE_WALLPAPER
    rm -rf "$active_wall_target"
    ln -rs "$1" "$active_wall_target"
    feh --bg-scale "$active_wall_target"
}


function opendotfiles() { subl "$@" "$DOTFILES_PATH" }
function network_info() { http --json get "http://ifconfig.me/all.json" }
function clear_history() { echo "" > $HISTFILE; exec $SHELL; }

function icat_url { curl "$1" -o - --silent | icat --stdin yes }
function wall_url { curl "$1" -o - | feh --bg-scale - }

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall;"
        --cmd="map q chain shell echo %d > "$tempfile"; quit;"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

function viewcolor() { 
    if [[ $1 == '' ]];
    then
        cat << EOF
Usage: viewcolor COLOR [SIZE]

Previews the given color
      COLOR is the color to display e.g 'blue', 'rgb(123, 56, 7)'
      SIZE is the output image size in the format WIDTHxHEIGHT e.g: 32x32

Example:
      viewcolor 'blue'
      viewcolor '#ff0000' 100x100
      viewcolor 'rgb(10, 20, 30)'

For supported COLOR formats, see https://www.imagemagick.org/script/color.php

Note: ImageMagick and icat are required
EOF
    return 2;
    fi
    echo; convert -size ${2:-100x100} "xc:$1" png:- | icat --align=left 
}

# Do some math: mth "56 + 80"
function mth() { echo $(( $1 )) }

# Make executable files
function mkf_exe() { 
    all_args=( "$@" ) 
    touch "${all_args[@]}"
    chmod +x "${all_args[@]}" 
} 

# Returns a random ASCII key of the specified length: gen_rand_key 60
function gen_rand_key() {
    tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]_{|}' </dev/urandom | head -c ${1:-64}; echo
}

# Print each argument given on a new line (I need it sometimes for debugging)
function print_sep_lines() {
    for arg in "$@"
    do
        echo $arg;
    done
}
