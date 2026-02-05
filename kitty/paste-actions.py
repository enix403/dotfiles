# This function is automatically called whenever pasting text into kitty, thanks to
# the "paste_actions filter" config.
# See: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.paste_actions
def filter_paste(text: str):
    return text.strip()
