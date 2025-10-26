import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import json
from pathlib import Path
from genlib import (
    mappings,
    shell_mappings,
    KeyboardDevice,
    build_karabiner_config
)

# =====================================
# ============= Keyboards =============
# =====================================

builtin = KeyboardDevice.built_in(name="BL")
galaxy65 = KeyboardDevice.external(
    name="GX",
    idens=[
        (10473, 12645), # Wired mode
        (10473, 8192),  # Bluetooth mode
    ]
)

all_devices = [builtin, galaxy65]

# ====================================
# =========== Applications ===========
# ====================================

chrome = "com.google.Chrome"
terminals = ["net.kovidgoyal.kitty", "com.apple.Terminal"]
# finder = "com.apple.finder"

# ====================================
# ============= Keymaps ==============
# ====================================

# ========== Common ==========

shell_mappings(
    desc="Common Shell Mapping",
    maps=[
        ("opt+enter", "sh -c '/Applications/kitty.app/Contents/MacOS/kitty --single-instance --directory=/Users/qateef.ahmad --detach'"),
        ("opt+p", "open -a Launchpad"),
    ]
)

# -------------

class KeySet:
    # list, but supports the difference operator a - b
    class SubtractableList(list):
        def __sub__(self, other):
            # Support subtracting either another iterable or a single item
            if isinstance(other, (list, tuple, set)):
                to_remove = set(other)
            else:
                to_remove = {other}

            # Preserve order and duplicates (if not removed)
            return self.__class__(x for x in self if x not in to_remove)

    letters = SubtractableList("abcdefghijklmnopqrstuvwxyz")
    digits = SubtractableList("0123456789")
    symbols = SubtractableList("`-=[]\\;',./")
    # special = SubtractableList(["tab", "escape", "delete", "enter", "space"])
    special = SubtractableList(["space", "enter", "delete", "tab", "escape"])

    h_arrows = SubtractableList(["left_arrow", "right_arrow"])
    v_arrows = SubtractableList(["up_arrow", "down_arrow"])
    arrows = SubtractableList(["left_arrow", "up_arrow", "right_arrow", "down_arrow"])


def recursive_flatmap(iterable):
    for item in iterable:
        if isinstance(item, (list, tuple)):
            # Recursively yield items from the nested iterable
            yield from recursive_flatmap(item)
        else:
            yield item


# translate prefix
def tp(from_prefix: str, to_prefix: str, keys: list):
    from_prefix = from_prefix.strip()
    to_prefix = to_prefix.strip()

    keys_flat = [k.strip() for k in list(recursive_flatmap(keys))]

    return [
        f"{from_prefix}+{k} == {to_prefix}+{k}"
        for k in keys_flat
    ]


# ========== Built in keyboard ==========

mappings(
    devices=[builtin],
    apps=[chrome],
    desc="Chrome: Force Keymaps",
    maps=[
        "fn+shift+i == cmd+opt+i",
    ]
)

mappings(
    devices=[builtin],
    apps=terminals,
    desc="Terminal: <fn> to <ctrl>",
    maps=tp("fn", "ctrl", [
        KeySet.special - {"delete"},
        KeySet.letters,
        KeySet.digits,
        KeySet.symbols,
    ]),
)

mappings(
    devices=[builtin],
    apps=terminals,
    desc="Terminal: Special Copy and Paste actions",
    maps=tp("fn+shift", "cmd", ['c', 'v'])
)

mappings(
    devices=[builtin],
    apps=terminals,
    desc="Terminal: <fn> + <shift> to <ctrl> + <shift>",
    maps=tp("fn+shift", "ctrl+shift", [
        KeySet.special - {"delete"},
        KeySet.letters - {'c', 'v'},
        KeySet.digits,
        KeySet.symbols,
    ])
)


mappings(
    devices=[builtin],
    desc="(Deprecate) Global: Cursor Movement By Word",
    maps=[
        *tp("fn", "opt", ["delete"]),
        *tp("fn", "opt", KeySet.h_arrows),
        *tp("fn+shift", "opt+shift", KeySet.h_arrows),
    ]
)

mappings(
    devices=[builtin],
    desc="Global: <fn> to <cmd> (because macos cmd = app's ctrl)",
    maps=tp("fn", "cmd", [
        KeySet.special - {"delete"},
        KeySet.letters,
        KeySet.digits,
        KeySet.symbols,
    ])
)

mappings(
    devices=[builtin],
    desc="Global: <fn> + <shift> to <cmd> + <shift> (because macos cmd = app's ctrl)",
    maps=tp("fn+shift", "cmd+shift", [
        KeySet.special - {"delete"},
        KeySet.v_arrows,
        KeySet.letters,
        KeySet.digits,
        KeySet.symbols,
    ]),
)

mappings(
    devices=[builtin],
    desc="Global: <fn> + <opt> to <cmd> + <opt> (because macos cmd = app's ctrl)",
    maps=[
        "fn+opt+left_arrow == cmd+opt+left_arrow",
        "fn+opt+up_arrow == cmd+opt+up_arrow",
        "fn+opt+right_arrow == cmd+opt+right_arrow",
        "fn+opt+down_arrow == cmd+opt+down_arrow",
        "fn+opt+delete == cmd+opt+delete",
        "fn+opt+space == cmd+opt+space",
        "fn+opt+enter == cmd+opt+enter",
        "fn+opt+tab == cmd+opt+tab",
        "fn+opt+escape == cmd+opt+escape",
        "fn+opt+a == cmd+opt+a",
        "fn+opt+b == cmd+opt+b",
        "fn+opt+c == cmd+opt+c",
        "fn+opt+d == cmd+opt+d",
        "fn+opt+e == cmd+opt+e",
        "fn+opt+f == cmd+opt+f",
        "fn+opt+g == cmd+opt+g",
        "fn+opt+h == cmd+opt+h",
        "fn+opt+i == cmd+opt+i",
        "fn+opt+j == cmd+opt+j",
        "fn+opt+k == cmd+opt+k",
        "fn+opt+l == cmd+opt+l",
        "fn+opt+m == cmd+opt+m",
        "fn+opt+n == cmd+opt+n",
        "fn+opt+o == cmd+opt+o",
        "fn+opt+p == cmd+opt+p",
        "fn+opt+q == cmd+opt+q",
        "fn+opt+r == cmd+opt+r",
        "fn+opt+s == cmd+opt+s",
        "fn+opt+t == cmd+opt+t",
        "fn+opt+u == cmd+opt+u",
        "fn+opt+v == cmd+opt+v",
        "fn+opt+w == cmd+opt+w",
        "fn+opt+x == cmd+opt+x",
        "fn+opt+y == cmd+opt+y",
        "fn+opt+z == cmd+opt+z",
        "fn+opt+0 == cmd+opt+0",
        "fn+opt+1 == cmd+opt+1",
        "fn+opt+2 == cmd+opt+2",
        "fn+opt+3 == cmd+opt+3",
        "fn+opt+4 == cmd+opt+4",
        "fn+opt+5 == cmd+opt+5",
        "fn+opt+6 == cmd+opt+6",
        "fn+opt+7 == cmd+opt+7",
        "fn+opt+8 == cmd+opt+8",
        "fn+opt+9 == cmd+opt+9",
        "fn+opt+` == cmd+opt+`",
        "fn+opt+- == cmd+opt+-",
        "fn+opt+= == cmd+opt+=",
        "fn+opt+[ == cmd+opt+[",
        "fn+opt+] == cmd+opt+]",
        "fn+opt+\\ == cmd+opt+\\",
        "fn+opt+; == cmd+opt+;",
        "fn+opt+' == cmd+opt+'",
        "fn+opt+, == cmd+opt+,",
        "fn+opt+. == cmd+opt+.",
        "fn+opt+/ == cmd+opt+/",
    ]
)

# ========== Galaxy 65 keyboard ==========

mappings(
    devices=[galaxy65],
    apps=[chrome],
    desc="Chrome: Force Keymaps",
    maps=[
        "cmd+shift+i == cmd+opt+i",
    ]
)

mappings(
    devices=[galaxy65],
    apps=terminals,
    desc="Terminal: <fn> to <ctrl>",
    maps=[
        "cmd+space == ctrl+space",
        "cmd+enter == ctrl+enter",
        "cmd+tab == ctrl+tab",
        "cmd+escape == ctrl+escape",
        "cmd+a == ctrl+a",
        "cmd+b == ctrl+b",
        "cmd+c == ctrl+c",
        "cmd+d == ctrl+d",
        "cmd+e == ctrl+e",
        "cmd+f == ctrl+f",
        "cmd+g == ctrl+g",
        "cmd+h == ctrl+h",
        "cmd+i == ctrl+i",
        "cmd+j == ctrl+j",
        "cmd+k == ctrl+k",
        "cmd+l == ctrl+l",
        "cmd+m == ctrl+m",
        "cmd+n == ctrl+n",
        "cmd+o == ctrl+o",
        "cmd+p == ctrl+p",
        "cmd+q == ctrl+q",
        "cmd+r == ctrl+r",
        "cmd+s == ctrl+s",
        "cmd+t == ctrl+t",
        "cmd+u == ctrl+u",
        "cmd+v == ctrl+v",
        "cmd+w == ctrl+w",
        "cmd+x == ctrl+x",
        "cmd+y == ctrl+y",
        "cmd+z == ctrl+z",
        "cmd+0 == ctrl+0",
        "cmd+1 == ctrl+1",
        "cmd+2 == ctrl+2",
        "cmd+3 == ctrl+3",
        "cmd+4 == ctrl+4",
        "cmd+5 == ctrl+5",
        "cmd+6 == ctrl+6",
        "cmd+7 == ctrl+7",
        "cmd+8 == ctrl+8",
        "cmd+9 == ctrl+9",
        "cmd+` == ctrl+`",
        "cmd+- == ctrl+-",
        "cmd+= == ctrl+=",
        "cmd+[ == ctrl+[",
        "cmd+] == ctrl+]",
        "cmd+\\ == ctrl+\\",
        "cmd+; == ctrl+;",
        "cmd+' == ctrl+'",
        "cmd+, == ctrl+,",
        "cmd+. == ctrl+.",
        "cmd+/ == ctrl+/",
    ]
)

mappings(
    devices=[galaxy65],
    apps=terminals,
    desc="Terminal: Special Copy and Paste actions",
    maps=[
        "cmd+shift+c == cmd+c",
        "cmd+shift+v == cmd+v",
    ]
)

mappings(
    devices=[galaxy65],
    apps=terminals,
    desc="Terminal: <cmd> + <shift> to <ctrl> + <shift>",
    maps=[
        "cmd+shift+space == ctrl+shift+space",
        "cmd+shift+enter == ctrl+shift+enter",
        "cmd+shift+tab == ctrl+shift+tab",
        "cmd+shift+escape == ctrl+shift+escape",

        "cmd+shift+a == ctrl+shift+a",
        "cmd+shift+b == ctrl+shift+b",
        # "cmd+shift+c == ctrl+shift+c", # special
        "cmd+shift+d == ctrl+shift+d",
        "cmd+shift+e == ctrl+shift+e",
        "cmd+shift+f == ctrl+shift+f",
        "cmd+shift+g == ctrl+shift+g",
        "cmd+shift+h == ctrl+shift+h",
        "cmd+shift+i == ctrl+shift+i",
        "cmd+shift+j == ctrl+shift+j",
        "cmd+shift+k == ctrl+shift+k",
        "cmd+shift+l == ctrl+shift+l",
        "cmd+shift+m == ctrl+shift+m",
        "cmd+shift+n == ctrl+shift+n",
        "cmd+shift+o == ctrl+shift+o",
        "cmd+shift+p == ctrl+shift+p",
        "cmd+shift+q == ctrl+shift+q",
        "cmd+shift+r == ctrl+shift+r",
        "cmd+shift+s == ctrl+shift+s",
        "cmd+shift+t == ctrl+shift+t",
        "cmd+shift+u == ctrl+shift+u",
        # "cmd+shift+v == ctrl+shift+v", # special
        "cmd+shift+w == ctrl+shift+w",
        "cmd+shift+x == ctrl+shift+x",
        "cmd+shift+y == ctrl+shift+y",
        "cmd+shift+z == ctrl+shift+z",

        "cmd+shift+0 == ctrl+shift+0",
        "cmd+shift+1 == ctrl+shift+1",
        "cmd+shift+2 == ctrl+shift+2",
        "cmd+shift+3 == ctrl+shift+3",
        "cmd+shift+4 == ctrl+shift+4",
        "cmd+shift+5 == ctrl+shift+5",
        "cmd+shift+6 == ctrl+shift+6",
        "cmd+shift+7 == ctrl+shift+7",
        "cmd+shift+8 == ctrl+shift+8",
        "cmd+shift+9 == ctrl+shift+9",

        "cmd+shift+` == ctrl+shift+`",
        "cmd+shift+- == ctrl+shift+-",
        "cmd+shift+= == ctrl+shift+=",

        "cmd+shift+[ == ctrl+shift+[",
        "cmd+shift+] == ctrl+shift+]",
        "cmd+shift+\\ == ctrl+shift+\\",

        "cmd+shift+; == ctrl+shift+;",
        "cmd+shift+' == ctrl+shift+'",

        "cmd+shift+, == ctrl+shift+,",
        "cmd+shift+. == ctrl+shift+.",
        "cmd+shift+/ == ctrl+shift+/",
    ]
)

mappings(
    devices=[galaxy65],
    desc="(Deprecate) Global: Cursor Movement By Word",
    maps=[
        "cmd+delete == opt+delete",
        "cmd+left_arrow == opt+left_arrow",
        "cmd+right_arrow == opt+right_arrow",
        "cmd+shift+left_arrow == opt+shift+left_arrow",
        "cmd+shift+right_arrow == opt+shift+right_arrow",
    ]
)

# ====================================
# ============= Generate =============
# ====================================

output_path = Path(__file__).parent / "karabiner.json"
with output_path.open("w") as f:
    config = build_karabiner_config({
        "name": "Generated By genconfig.py",
        "selected": True,
        "devices": [
            {
                "ignore": False,
                "identifiers": {
                    "is_keyboard": True,
                    "is_pointing_device": True,
                    "vendor_id": vendor_id,
                    "product_id": product_id,
                }
            }
            for device in all_devices
            for (vendor_id, product_id) in device.idens
        ],
        "virtual_hid_keyboard": {
            "keyboard_type_v2": "ansi"
        }
    })

    json.dump(config, f, indent=2)

print(f"Output written to: {output_path}")
