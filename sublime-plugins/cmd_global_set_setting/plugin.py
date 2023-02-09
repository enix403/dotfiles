import sublime
import sublime_plugin


class GlobalSetSettingCommand(sublime_plugin.ApplicationCommand):
    def run(self, setting, value):
        s = sublime.load_settings("Preferences.sublime-settings")
        s.set(setting, value)
        sublime.save_settings("Preferences.sublime-settings")