import json

class KeyboardDevice:
    pass

builtin = KeyboardDevice()
galaxy65 = KeyboardDevice()

local_to_karabiner_map = {
    "cmd": "command",
    "opt": "option",
    "ctrl": "control",
    "shift": "shift",

    "`": "grave_accent_and_tilde",
    "-": "hyphen",
    "=": "equal_sign",

    "[": "open_bracket",
    "]": "close_bracket",
    "\\": "backslash",

    ";": "semicolon",
    "'": "quote",

    ",": "comma",
    ".": "period",
    "/": "slash",

    "space": "spacebar",
    "enter": "return_or_enter",
    "tab": "tab",
    "escape": "escape",

    "delete": "delete_or_backspace",
    "down": "down_arrow",
    "up": "up_arrow",
    "left": "left_arrow",
    "right": "right_arrow",
}

def norm(key: str) -> str:
    return local_to_karabiner_map.get(key, key)

def break_into_modifiers_and_key(strokes: str):
    keys = [norm(s.strip()) for s in strokes.split("+")]

    mods = keys[:-1]
    key = keys[-1]

    return mods, key

def parse_rule(rule: str):
    left, right = rule.split("==")
    left, right = left.strip(), right.strip()

    left_mods, left_key = break_into_modifiers_and_key(left)
    right_mods, right_key = break_into_modifiers_and_key(right)

    from_ = {
        "modifiers": {
            "mandatory": left_mods,
            "optional": ["any"]
        },
        "key_code": left_key
    }
    to_ = {
        "modifiers": right_mods,
        "key_code": right_key
    }

    return from_, to_

def parse(
    devices: list[KeyboardDevice] = [],
    desc: str = "",
    apps: list[str] = [],
    maps: list[str] = []
):
    manipulators = []

    for rule in maps:
        from_, to_ = parse_rule(rule)
        manipulator = {
            "type": "basic",
            "from": from_,
            "to": to_,
        }

        manipulators.append(manipulator)

    res = {
        "description": desc,
        "manipulators": manipulators
    }

    print(json.dumps(res))


parse(
    devices=[builtin],
    desc="Terminal: <fn> to <ctrl>",
    apps=["com.google.Chrome"],
    maps=[
        "fn+a == ctrl+a",
        "fn+b == ctrl+b",
        "fn+c == ctrl+c",
        "fn+d == ctrl+d",
        "fn+e == ctrl+e",
        "fn+f == ctrl+f",
        "fn+g == ctrl+g",
        "fn+h == ctrl+h",
        "fn+i == ctrl+i",
        "fn+j == ctrl+j",
        "fn+k == ctrl+k",
        "fn+l == ctrl+l",
        "fn+m == ctrl+m",
        "fn+n == ctrl+n",
        "fn+o == ctrl+o",
        "fn+p == ctrl+p",
        "fn+q == ctrl+q",
        "fn+r == ctrl+r",
        "fn+s == ctrl+s",
        "fn+t == ctrl+t",
        "fn+u == ctrl+u",
        "fn+v == ctrl+v",
        "fn+w == ctrl+w",
        "fn+x == ctrl+x",
        "fn+y == ctrl+y",
        "fn+z == ctrl+z",

        "fn+0 == ctrl+0",
        "fn+1 == ctrl+1",
        "fn+2 == ctrl+2",
        "fn+3 == ctrl+3",
        "fn+4 == ctrl+4",
        "fn+5 == ctrl+5",
        "fn+6 == ctrl+6",
        "fn+7 == ctrl+7",
        "fn+8 == ctrl+8",
        "fn+9 == ctrl+9",

        "fn+` == ctrl+`",
        "fn+- == ctrl+-",
        "fn+= == ctrl+=",

        "fn+[ == ctrl+[",
        "fn+] == ctrl+]",
        "fn+\\ == ctrl+\\",

        "fn+; == ctrl+;",
        "fn+' == ctrl+'",

        "fn+, == ctrl+,",
        "fn+. == ctrl+.",
        "fn+/ == ctrl+/",

        "fn+space == ctrl+space",
        "fn+enter == ctrl+enter",
        "fn+tab == ctrl+tab",
        "fn+escape == ctrl+escape",
    ]
)
