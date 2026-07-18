export EDITOR=nvim

# Pager defaults (previously provided by Oh My Zsh's lib/misc.zsh).
# Set only if not already defined, so an explicit override still wins.
# `-R` lets less render raw color escapes (used by git/delta) and is what
# restores wheel-scroll behavior in the pager.
: ${PAGER:=less}
: ${LESS:=-R}
export PAGER LESS

# fzf: `--color=16` draws the UI from the terminal's 16 ANSI colors, so fzf
# follows whatever palette `settheme` sets on kitty. Append, don't
# clobber, any FZF_DEFAULT_OPTS set elsewhere.
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--color=16"