# smart_copy.py — kitty kitten for context-aware clipboard copy
#
# Bound to kitty_mod+shift+c (ctrl+shift+c by default). Behavior:
#   - If text is selected: copy the selection (same as default ctrl+shift+c)
#   - If nothing is selected: copy the output of the last non-empty command
#
# With --with-cmd (bound to kitty_mod+alt+c), ignores any selection and copies
# the last command line (prefixed with "❯ "), a blank line, then that command's output. Pressing
# kitty_mod+shift+c twice within DOUBLE_PRESS_SECS does the same thing when
# nothing is selected (the first press still copies normally; the second
# overwrites the clipboard).
#
# Requirements:
#   - kitty shell integration must be active (on by default for bash/zsh/fish)
#     so kitty can track command output boundaries
#   - In kitty.conf:
#       map kitty_mod+shift+c kitten smart_copy.py
#       map kitty_mod+alt+c   kitten smart_copy.py --with-cmd

import subprocess
import sys
import time
from kittens.tui.handler import result_handler
from kitty.window import CommandOutput
# CommandOutput enum values (from kitty.window):
#   last_run        = 0 — output of the last command, even if empty
#   first_on_screen = 1 — output of the first command visible on screen
#   last_visited    = 2 — output of the last command scrolled to via hotkey
#   last_non_empty  = 3 — output of the last command that produced output

DOUBLE_PRESS_SECS = 0.4

# Ordered list of clipboard commands to try per platform. The first one that
# exists and succeeds wins; if none are available we silently do nothing.
if sys.platform == 'darwin':
    _CLIPBOARD_CMDS = [['pbcopy']]
else:
    # Wayland first, then X11 fallbacks
    _CLIPBOARD_CMDS = [
        ['wl-copy'],
        ['xclip', '-selection', 'clipboard'],
        ['xsel', '--clipboard', '--input'],
    ]


def main(args):
    # Required entry point for kittens; no terminal UI needed here.
    pass

def set_clipboard(text):
    data = text.encode()
    for cmd in _CLIPBOARD_CMDS:
        try:
            # FIX: Use DEVNULL instead of capture_output=True so that Wayland 
            # background daemons don't keep the stdout/stderr pipes open.
            result = subprocess.run(
                cmd, 
                input=data, 
                stdout=subprocess.DEVNULL, 
                stderr=subprocess.DEVNULL
            )
            if result.returncode == 0:
                return
        except FileNotFoundError:
            continue  # binary not installed, try next   


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    if '--with-cmd' not in args and w.screen.has_selection():
        # Text is selected: let kitty copy it natively (handles both primary
        # and clipboard, respects copy_on_select, etc.). A selection always
        # wins, however many times the key is pressed.
        w.copy_to_clipboard()
        return

    # Remember the last press on the boss (persists across kitten invocations,
    # unlike module globals) to detect a quick double press in the same window.
    now = time.monotonic()
    last_wid, last_time = getattr(boss, '_smart_copy_last_press', (None, 0.0))
    double_press = last_wid == target_window_id and now - last_time < DOUBLE_PRESS_SECS
    # Reset after a double press so a third quick press starts a new cycle.
    boss._smart_copy_last_press = (None, 0.0) if double_press else (target_window_id, now)

    if '--with-cmd' in args or double_press:
        # last_cmd_cmdline is sent by zsh shell integration (OSC 133;C). Pair it
        # with last_run (not last_non_empty) so the output belongs to that command.
        cmdline = getattr(w, 'last_cmd_cmdline', '')
        if not cmdline:
            return
        try:
            output = w.cmd_output(CommandOutput.last_run, False)
        except (AttributeError, TypeError):
            output = ''
        cmdline = f'❯ {cmdline}'
        set_clipboard(f'{cmdline}\n\n{output}' if output.strip() else cmdline)
        return

    # No selection: grab the last command output that wasn't empty.
    # Falls back silently if shell integration isn't active or no output exists.
    try:
        text = w.cmd_output(CommandOutput.last_non_empty, False)
    except (AttributeError, TypeError):
        return

    if text and text.strip():
        set_clipboard(text)
