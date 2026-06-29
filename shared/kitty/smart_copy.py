import subprocess
from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    if w.screen.has_selection():
        w.copy_to_clipboard()
        return

    try:
        text = w.cmd_output(0, False)  # 0 = last_run, False = no ansi
    except (AttributeError, TypeError):
        return

    if text and text.strip():
        subprocess.run(['pbcopy'], input=text.encode())
