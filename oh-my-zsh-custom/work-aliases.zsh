# =============================
# =========== Move ============
# =============================

# High-precedence custom shortcuts: name -> absolute path
typeset -g -A MOVE_CUSTOM_MAP
MOVE_CUSTOM_MAP=(
  spd $KT_SVC_PATH_SPD
  slf $KT_SVC_PATH_SLF
  sbc $KT_SVC_PATH_SBC
)

move() {
  local skip=false
  local arg dir_arg

  # Parse arguments (allow --skip before or after)
  for arg in "$@"; do
    if [[ "$arg" == "--skip" ]]; then
      skip=true
    else
      dir_arg="$arg"
    fi
  done

  if [[ -z "$dir_arg" ]]; then
    echo "Usage: move [--skip] <dir-or-shortcut>"
    return 1
  fi

  local target

  # High precedence: custom shortcuts
  if [[ -n "${MOVE_CUSTOM_MAP[$dir_arg]+set}" ]]; then
    target="${MOVE_CUSTOM_MAP[$dir_arg]}"
  else
    target="$MY_ALL_REPOS/$dir_arg"
  fi

  if [[ -d "$target" ]]; then
    cd "$target" || return 1
    if [[ $skip == true ]]; then
      echo "Direnv not loaded. Run 'dac' command to manually invoke direnv."
    else
      _activate_prebaked_direnv
    fi
  else
    echo "Directory not found: $target"
    return 1
  fi
}

# Completion function for move
_move_complete() {
  local base="$MY_ALL_REPOS"
  local -a dirs custom_keys

  # Custom shortcut names
  custom_keys=("${(@k)MOVE_CUSTOM_MAP}")

  # Directories one level deep under $MY_ALL_REPOS (skip dot dirs)
  dirs=($(find "$base" -mindepth 1 -maxdepth 1 -type d \
    -not -name ".*" -exec basename {} \; 2>/dev/null))

  # Combine: show custom shortcuts first, then normal dirs
  dirs=("${custom_keys[@]}" "${dirs[@]}")

  _describe 'directories' dirs
}

compdef _move_complete move

# ================================
# ====== Quick Port Forward ======
# ================================

# kp <service> [<env>]
# <env>: prw (default), stg, prod
# Hardcoded per-env map: service -> "kube-context|kube-namespace|kube-service|port"
# Port can be "8080" or "8080:80" (LOCAL[:REMOTE] syntax)

# Fill the following variables
# export KUBE_CTX_PRVW=
# export KUBE_CTX_STAG=
# export KUBE_CTX_PROD=

# export SVC_SLF_KUBE_NS=
# export SVC_SLF_KUBE_SVC=
# export SVC_SLF_KUBE_PORT=

# export SVC_SPD_KUBE_NS=
# export SVC_SPD_KUBE_SVC=
# export SVC_SPD_KUBE_PORT=

function kp() {
  if (( $# < 1 || $# > 2 )); then
    echo "Usage: kp <service> [prw|stg|prod]"
    return 1
  fi

  local svc="$1"
  local env="${2:-prw}"

  case "$env" in
    prw|stg|prod) ;;
    *)
      echo "Invalid env: $env. Expected one of: prw, stg, prod"
      return 1
      ;;
  esac

  # -------------------------
  # HARD-CODED SERVICE MAPS
  # -------------------------
  typeset -A KP_MAP_PRW KP_MAP_STG KP_MAP_PROD

  # PRW environment mappings
  KP_MAP_PRW=(
    # Examples (edit these to your real values)
    slf "$KUBE_CTX_PRVW|$SVC_SLF_KUBE_NS|${SVC_SLF_KUBE_SVC}-preview|$SVC_SLF_KUBE_PORT"
    spd "$KUBE_CTX_PRVW|$SVC_SPD_KUBE_NS|${SVC_SPD_KUBE_SVC}-preview|$SVC_SPD_KUBE_PORT"
  )

  # STG environment mappings
  KP_MAP_STG=(
    slf "$KUBE_CTX_STAG|$SVC_SLF_KUBE_NS|${SVC_SLF_KUBE_SVC}-staging|$SVC_SLF_KUBE_PORT"
    spd "$KUBE_CTX_STAG|$SVC_SPD_KUBE_NS|${SVC_SPD_KUBE_SVC}-staging|$SVC_SPD_KUBE_PORT"
  )

  # PROD environment mappings
  KP_MAP_PROD=(
    slf "$KUBE_CTX_PROD|$SVC_SLF_KUBE_NS|${SVC_SLF_KUBE_SVC}-production|$SVC_SLF_KUBE_PORT"
    spd "$KUBE_CTX_PROD|$SVC_SPD_KUBE_NS|${SVC_SPD_KUBE_SVC}-production|$SVC_SPD_KUBE_PORT"
  )

  # Select the env map without using namerefs (for older zsh)
  typeset -A MAP
  case "$env" in
    prw)  MAP=("${(@kv)KP_MAP_PRW}") ;;
    stg)  MAP=("${(@kv)KP_MAP_STG}") ;;
    prod) MAP=("${(@kv)KP_MAP_PROD}") ;;
  esac

  if [[ -z "${MAP[$svc]+set}" ]]; then
    echo "Unknown service '$svc' for env '$env'."
    echo "Known services for $env: ${(j:, :)${(k)MAP}}"
    return 1
  fi

  local entry="${MAP[$svc]}"
  local -a parts
  parts=("${(@s:|:)entry}")  # split by |

  if (( ${#parts} != 4 )); then
    echo "Malformed mapping for service '$svc' in env '$env': '$entry'"
    echo "Expected format: kube-context|kube-namespace|kube-service|port"
    return 1
  fi

  local kube_context="${parts[1]}"
  local kube_namespace="${parts[2]}"
  local kube_service="${parts[3]}"
  local port="${parts[4]}"

  if ! command -v kubectl >/dev/null 2>&1; then
    echo "kubectl not found in PATH"
    return 127
  fi

  echo "Running: kubectl --context='${kube_context}' port-forward --namespace '${kube_namespace}' svc/${kube_service} ${port}"
  kubectl --context="${kube_context}" port-forward --namespace "${kube_namespace}" "svc/${kube_service}" "${port}"
}

# function grpc_ui_spd() {
#     $(cd $k/kt && grpcui --plaintext --proto $SPD_PROTO_API_PATH localhost:$SVC_SPD_KUBE_PORT)
# }