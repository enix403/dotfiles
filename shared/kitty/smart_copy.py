# smart_copy.py — kitty kitten for context-aware clipboard copy
#
# Bound to kitty_mod+shift+c (ctrl+shift+c by default). Behavior:
#   - If text is selected: copy the selection (same as default ctrl+shift+c)
#   - If nothing is selected: copy the output of the last non-empty command
#
# Requirements:
#   - kitty shell integration must be active (on by default for bash/zsh/fish)
#     so kitty can track command output boundaries
#   - In kitty.conf:
#       map kitty_mod+shift+c kitten smart_copy.py
#
# This kitten runs inside the kitty process (no_ui=True), so it has direct
# access to the window object and avoids the instance-targeting issues that
# come with shelling out to `kitty @`.

import subprocess
from kittens.tui.handler import result_handler
from kitty.window import CommandOutput
# CommandOutput enum values (from kitty.window):
#   last_run       = 0  — output of the last command, even if empty
#   first_on_screen= 1  — output of the first command visible on screen
#   last_visited   = 2  — output of the last command scrolled to via hotkey
#   last_non_empty = 3  — output of the last command that produced output


def main(args):
    # Required entry point for kittens; no terminal UI needed here.
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    if w.screen.has_selection():
        # Text is selected: let kitty copy it natively (handles both primary
        # and clipboard, respects copy_on_select, etc.)
        w.copy_to_clipboard()
        return

    # No selection: grab the last command output that wasn't empty.
    # Falls back silently if shell integration isn't active or no output exists.
    try:
        text = w.cmd_output(CommandOutput.last_non_empty, False)
    except (AttributeError, TypeError):
        return

    if text and text.strip():
        subprocess.run(['pbcopy'], input=text.encode())
