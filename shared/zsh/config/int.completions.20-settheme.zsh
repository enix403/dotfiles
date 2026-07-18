# Completion for `settheme` — completes theme names from the script's own
# registry (via `settheme --names`), so it stays in sync automatically.
_settheme() {
  local -a themes
  themes=(${(f)"$(settheme --names 2>/dev/null)"})
  _describe -t themes 'theme' themes
}
compdef _settheme settheme
