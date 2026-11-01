# Helpers for the _apply scripts. Source it; don't run it.

# Repo root, wherever it was cloned.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# link <target> <link path>
#
# Symlink <link path> -> <target>, safely:
#   - already a symlink resolving to <target>: left alone
#   - a symlink pointing elsewhere: replaced
#   - a real file or directory: moved aside to <link path>.pre-dotfiles.<timestamp>
#   - <target> missing: skipped with a warning
link() {
    local target=$1 dest=$2
    if [ ! -e "$target" ]; then
        echo "skip    $dest (missing $target)" >&2
        return 0
    fi
    if [ -L "$dest" ]; then
        if [ -e "$dest" ] && [ "$(realpath "$dest")" = "$(realpath "$target")" ]; then
            return 0
        fi
        echo "relink  $dest (was -> $(readlink "$dest"))"
    elif [ -e "$dest" ]; then
        local backup
        backup="$dest.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
        mv "$dest" "$backup"
        echo "backup  $dest -> $backup"
    else
        echo "link    $dest"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$target" "$dest"
}
