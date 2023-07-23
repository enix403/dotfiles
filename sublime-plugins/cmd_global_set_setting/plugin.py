import sublime
import sublime_plugin
from Default.side_bar import *


class GlobalSetSettingCommand(sublime_plugin.ApplicationCommand):
    def run(self, setting, value):
        s = sublime.load_settings("Preferences.sublime-settings")
        s.set(setting, value)
        sublime.save_settings("Preferences.sublime-settings")


class DeleteFileCommand(sublime_plugin.WindowCommand):
    def run(self, files):
        if len(files) == 1:
            message = "Delete File %s?" % files[0]
        else:
            message = "Delete %d Files?" % len(files)

        if sublime.ok_cancel_dialog(message, "Delete") != True:
            return

        # Import send2trash on demand, to avoid initialising ctypes for as long as possible
        import Default.send2trash as send2trash
        for f in files:
            v = self.window.find_open_file(f)
            if v != None and not v.close():
                return

            send2trash.send2trash(f)

    def is_visible(self, files):
        return len(files) > 0