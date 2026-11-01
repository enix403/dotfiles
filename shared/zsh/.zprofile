# On macOS login shells, /etc/zprofile runs path_helper *after* .zshenv and
# prepends the system dirs (/usr/bin, /bin, ...) to the front, demoting our
# custom PATH dirs (e.g. shadowing GNU tools in /usr/local/bin/override with
# BSD ones in /bin). Re-assert our priority now that path_helper has run.
# _zsh_prioritize_path is defined by config/base.paths.*.zsh, sourced in .zshenv.
if [[ "$OSTYPE" == darwin* ]] && typeset -f _zsh_prioritize_path >/dev/null; then
    _zsh_prioritize_path
    # That just pushed Homebrew in front of mise's tool dirs again; let mise
    # re-apply its PATH so its tools keep priority in login shells too.
    (( $+functions[_mise_hook] )) && _mise_hook --force
fi
