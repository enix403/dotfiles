if [[ "$HOST" == "radium-fed" && "$OSTYPE" == linux* ]]; then
    eval "$(mise activate zsh --shims)" # for non-interactive shells
fi