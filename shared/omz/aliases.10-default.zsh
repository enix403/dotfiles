export DOTFILES_PATH=~/dotfiles
alias dt='cd "$DOTFILES_PATH"'
alias dtv='(cd "$DOTFILES_PATH"; nvim .)'

# ======= Absolute Necessaties =========

unalias l
alias ls="LC_COLLATE=C ls --color=auto -lh --group-directories-first"
alias la="ls -A"
alias l1="LC_COLLATE=C \ls --color=auto -1h --group-directories-first"
alias la1="l1 -A"
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
alias grep='grep --color=auto'

# ======= Core CLI Tools =========
# These are *existing cli and linux core* tools/commnds, tweaked to my liking

alias sudo='sudo ' # trailing space allows for recursive alias expansion
alias xargs='xargs '
alias ip="ip -c"
alias uz="unzip"
alias df='df -h'
alias free='free -h'
alias diskusage="df -h | grep -vE \"^(tmpfs|run|dev)\" | (sed -u 1q; sort)"
alias ddu="du -Pcshx"
alias rscopy="rsync -av --progress"
alias mnt='sudo mount -o umask=0022,gid="$GID",uid="$UID"' # mount with user previliges
alias {bat,bt}='bat --theme="Catppuccin Mocha" --style=plain'
alias feh="feh --scale-down --auto-zoom --draw-filename --action9 \";feh --bg-scale '%f'\""
alias fdf="fd -t f -H"
alias fdd="fd -t d -H"

# I learned this the hard way... :)
function rm() {
  local PROTECTED_DIRS=(
    "/Applications"
    "/Library"
    "/System"
    "/usr/local"
    "/opt"
    "/Volumes"
    "/etc"
    "$HOME"
    "$HOME/Documents"
    "$HOME/code"
    "$HOME/col"
    "$HOME/MyBackups"
    "$HOME/dotfiles"
    "$HOME/kb"
    "$HOME/tmp"
  )

  local TARGETS=()
  local DANGEROUS=0

  # collect non-flag args
  for arg in "$@"; do
    [[ "$arg" == -* ]] && continue
    TARGETS+=("${arg:a}")   # <-- FIX
  done

  # check targets
  for t in "${TARGETS[@]}"; do
    # deleting any home directory
    if [[ "$t" == /Users/* && "$t" != /Users/*/* ]]; then
      DANGEROUS=1
    fi

    # deleting protected dirs or their parents
    for p in "${PROTECTED_DIRS[@]}"; do
      if [[ "$t" == "$p" ]]; then
        DANGEROUS=1
      fi
    done
  done

  if (( DANGEROUS )); then
    echo
    echo -e "\033[1;31m================== DANGEROUS RM ==================\033[0m"
    echo -e "\033[1;31mYOU ARE ABOUT TO DELETE A PROTECTED LOCATION:\033[0m"
    printf '\033[1;31m - %s\033[0m\n' "${TARGETS[@]}"
    echo -e "\033[1;31m=================================================\033[0m"
    echo

    read -r "REPLY1?Type 'yes' to continue: "
    echo
    [[ "$REPLY1" != "yes" ]] && { echo "Aborted."; return 1; }

    read -r "REPLY2?Type 'yes' AGAIN to confirm: "
    echo
    [[ "$REPLY2" != "yes" ]] && { echo "Aborted."; return 1; }
  fi

  command rm "$@"
}

# ======= Custom Shortcuts =========
# These are new custom workflows/shortcuts

alias mee="source .me.env 1>/dev/null 2>&1 || :"
alias acv="source .venv/bin/activate && mee"

alias btj="bat -l json"
alias bty="bat -l yaml"

alias otj="otree -t json"
alias oty="otree -t yaml"

# alias kff="killall -9 firefox"

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

# Function to jump to the directory of a file or into a directory
function cdd() {
    if [ -z "$1" ]; then
        echo "Usage: cdd <path>"
        return 1
    fi

    if [ -d "$1" ]; then
        cd "$1"
    else
        cd "$(dirname "$1")"
    fi
}

function st() {
  date '+%I:%M %p, %A '$(date +%d | awk '{d=$1+0; if (d%10==1 && d!=11) s="st"; else if (d%10==2 && d!=12) s="nd"; else if (d%10==3 && d!=13) s="rd"; else s="th"; printf "%02d%s", d, s;}')', %b %Y';
}

# Convert Unix timestamp to ISO 8601 UTC
function tiso() {
  local input=${1:-$(date +%s)}

  if date --version >/dev/null 2>&1; then
    # GNU (Linux)
    date -u -d "@$input" +"%Y-%m-%dT%H:%M:%SZ"
  else
    # BSD (macOS)
    date -u -r "$input" +"%Y-%m-%dT%H:%M:%SZ"
  fi
}

# Convert ISO 8601 UTC string to Unix timestamp
function tunix() {
  local input="$1"
  if [[ -z "$input" ]]; then
    date +%s
    return
  fi

  if date --version >/dev/null 2>&1; then
    # GNU (Linux)
    date -u -d "$input" +%s
  else
    # BSD (macOS)
    date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$input" "+%s"
  fi
}

alias kb='cd ~/kb'
alias kbv='(cd ~/kb; nvim .)'

function qr() {
  # 1. Validate that an argument was provided
  if [[ -z "$1" ]]; then
    echo "Usage: q <number 1-30>"
    return 1
  fi

  # 2. Validate that the input is an integer between 1 and 30
  if ! [[ "$1" =~ ^[0-9]+$ ]] || (( $1 < 1 || $1 > 30 )); then
    echo "Error: Input must be an integer between 1 and 30."
    return 1
  fi

  # 3. Pad the input number to 2 digits (e.g., 1 -> 01, 15 -> 15)
  # Uses printf to format the string
  local padded_num=$(printf "%02d" "$1")

  # 4. Define the file path
  local file_path="$HOME/code/plays/merge-q-pdf/output/qp-${padded_num}.pdf"

  # 5. Check if the file exists before trying to open it
  if [[ -f "$file_path" ]]; then
    echo "Opening $file_path..."
    open "$file_path"
  else
    echo "Error: File not found at:"
    echo "$file_path"
    return 1
  fi
}

# ===========================
# ---------- Tools ----------
# ===========================
# Dedicated aliases for each tool

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

if (( $+commands[kubecolor] )); then
  alias k='kubecolor'
  # Nested: Only try to bind completion if kubecolor was chosen
  if (( $+functions[compdef] && $+functions[_kubectl] )); then
    compdef kubecolor=kubectl
  fi
else
  alias k='kubectl'
fi

function kx() {
  if [ $# -eq 0 ]; then
    # "kx" lists all available kubernetes contexts
    kubectl config current-context
  elif [ $# -eq 1 ]; then
    # "kx <context> sets the given context as current"
    kubectl config use-context "$1"
  elif [ $# -eq 2 ]; then
    # "kx <context> <namespace>" sets context and default namespace
    kubectl config use-context "$1"
    kubectl config set-context --current --namespace="$2"
  else
    echo "Usage: kx [context] [namespace]" >&2
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

function kc() {
  if [[ -z "$1" ]]; then
    # Show current context and its namespace
    ctx=$(kubectl config current-context 2>/dev/null)
    ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    ns=${ns:-default}
    echo "Context: $ctx"
    echo "Namespace: $ns"
  else
    # Set namespace for current context
    kubectl config set-context --current --namespace="$1"
  fi
}

function kcc() {
  # Clear namespace for current context
  kubectl config set-context --current --namespace=""
}

alias nerd="nerdctl -n k8s.io"

# logs of all kube pods
function ksl() {
    # If no arguments are provided, exit early
    [[ $# -eq 0 ]] && { echo "Usage: ksl [flags] <instance_name>"; return 1; }

    # Extract the last argument
    local instance_name="${@: -1}"

    # Extract everything EXCEPT the last argument
    # We use a check to ensure we don't duplicate the single argument
    local other_params=""
    if [ $# -gt 1 ]; then
        other_params="${@:1:$#-1}"
    fi

    kubectl logs \
        --max-log-requests 100 \
        --all-containers=true \
        --tail=-1 \
        --prefix \
        -f \
        -l "app.kubernetes.io/instance=${instance_name}" \
        $other_params
}

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

# ========== Bundle ==========

alias b="bundle"
alias be="bundle exec"

# ========== Python and Related ==========

function py() {
  if command -v python >/dev/null 2>&1; then
    python "$@"
  elif command -v python3 >/dev/null 2>&1; then
    python3 "$@"
  else
    echo "❌ Neither 'python' nor 'python3' is available in PATH." >&2
    return 1
  fi
}
alias ipy="ipython"
alias jl="jupyter-lab"
alias jconv="jupyter nbconvert --to script"

# ========== Bazel ==========

alias bz="bazel"
alias bzt="bazel test --test_output=all --test_arg=-test.v --cache_test_results=no --runs_per_test=1 --local_test_jobs=1"

# ========== VSCode/Cursor ==========

alias cr="cursor"

# ========== Copilot CLI ==========

alias cop="copilot"
