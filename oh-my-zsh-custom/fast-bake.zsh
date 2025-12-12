# https://unix.stackexchange.com/a/115431
source ${0:a:h}/work-secrets.sh

# ============================
# ========== Direnv ==========
# ============================

# Direnv ACtivate
alias dac='eval "$(direnv export /bin/zsh)"'

_get_app_name_from_pwd() {
  local pwd_curr="$(pwd)"
  local base_path="$MY_ALL_REPOS"
  local app_name
  # ensure current directory is under base_path
  if [[ "$pwd_curr" != "$base_path"/* ]]; then
    echo "error: current directory is not under $base_path" >&2
    return 1
  fi

  # extract the immediate subdirectory name under base_path
  # example: if pwd=base_path/foo/bar → app_name="foo"
  app_name="${pwd_curr#$base_path/}"       # remove prefix
  app_name="${app_name%%/*}"               # keep only first path component

  if [[ -z "$app_name" || "$app_name" == "$pwd_curr" ]]; then
    echo "error: could not determine app name" >&2
    return 1
  fi

  echo "$app_name"
}

# use prebaked nix envs instead of doing invoking direnv every
# single time
_activate_prebaked_direnv() {
  # construct env file path
  local app_name
  app_name="$(_get_app_name_from_pwd)" || return 1
  local app_env_path="$BAKED_ENVS_PATH/${app_name}-env.sh"

  # source if exists
  if [[ -f "$app_env_path" ]]; then
    source "$app_env_path"
  else
    echo "no env file found for app '$app_name' ($app_env_path)" >&2
    return 1
  fi
}
alias daf="_activate_prebaked_direnv"

# Fresh re-bake the env
_rebake_app_direnv() {
  local app_name app_repo_path app_env_path backup_path

  # Get current app name
  app_name="$(_get_app_name_from_pwd)" || return 1
  app_repo_path="$MY_ALL_REPOS/$app_name"
  app_env_path="$BAKED_ENVS_PATH/${app_name}-env.sh"
  backup_path="${app_env_path}.bak"

  echo "🔄 Rebaking env for app: $app_name"

  # Ensure app repo exists
  if [[ ! -d "$app_repo_path" ]]; then
    echo "error: app repo not found at $app_repo_path" >&2
    return 1
  fi

  # Backup existing baked env if it exists
  if [[ -f "$app_env_path" ]]; then
    cp "$app_env_path" "$backup_path"
    echo "📦 Backed up previous env to: $backup_path"
  fi

  # Attempt to rebake inside the app directory
  (
    cd "$app_repo_path" || exit 1
    if ! direnv export zsh > "$app_env_path"; then
      echo "❌ Error: direnv export failed for $app_name" >&2
      exit 2
    fi
  )

  local rebake_status=$?
  if (( rebake_status != 0 )); then
    # Restore backup on failure
    if [[ -f "$backup_path" ]]; then
      mv -f "$backup_path" "$app_env_path"
      echo "♻️  Restored previous env from backup."
    fi
    return $rebake_status
  fi

  echo "✅ Baked env saved to: $app_env_path"

  # Remove backup after success
  [[ -f "$backup_path" ]] && rm -f "$backup_path"

  # Apply the freshly baked env
  _activate_prebaked_direnv || return 1

  echo "✨ Direnv environment applied for '$app_name'"
}
alias daff="_rebake_app_direnv"

