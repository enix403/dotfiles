import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import json
from pathlib import Path
from genlib import mappings, KeyboardDevice, build_karabiner_config

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

chrome = ["com.google.Chrome"]
terminals = ["net.kovidgoyal.kitty", "com.apple.Terminal"]
finder = ["com.apple.finder"]

# ====================================
# ============= Keymaps ==============
# ====================================

# ========== Built in keyboard ==========


mappings(
    devices=[builtin],
    desc="Chrome: Force Keymaps",
    maps=[
        "fn+shift+i == cmd+opt+i",
    ]
)

mappings(
    devices=[builtin],
    apps=terminals,
    desc="Terminal: <fn> to <ctrl>",
    maps=[
        "fn+space == ctrl+space",
        "fn+enter == ctrl+enter",
        "fn+tab == ctrl+tab",
        "fn+escape == ctrl+escape",

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
    ]
)

mappings(
    devices=[builtin],
    apps=terminals,
    desc="Terminal: Special Copy and Paste actions",
    maps=[
        "fn+shift+c == cmd+c",
        "fn+shift+v == cmd+v",
    ]
)

mappings(
    devices=[builtin],
    desc="(Deprecate) Global: Cursor Movement By Word",
    maps=[
        "fn+delete == opt+delete",
        "fn+left_arrow == opt+left_arrow",
        "fn+right_arrow == opt+right_arrow",
    ]
)

mappings(
    devices=[builtin],
    desc="Global: <fn> to <cmd> (because macos cmd = app's ctrl)",
    maps=[
        "fn+space == cmd+space",
        "fn+enter == cmd+enter",
        "fn+tab == cmd+tab",
        "fn+escape == cmd+escape",

        "fn+a == cmd+a",
        "fn+b == cmd+b",
        "fn+c == cmd+c",
        "fn+d == cmd+d",
        "fn+e == cmd+e",
        "fn+f == cmd+f",
        "fn+g == cmd+g",
        "fn+h == cmd+h",
        "fn+i == cmd+i",
        "fn+j == cmd+j",
        "fn+k == cmd+k",
        "fn+l == cmd+l",
        "fn+m == cmd+m",
        "fn+n == cmd+n",
        "fn+o == cmd+o",
        "fn+p == cmd+p",
        "fn+q == cmd+q",
        "fn+r == cmd+r",
        "fn+s == cmd+s",
        "fn+t == cmd+t",
        "fn+u == cmd+u",
        "fn+v == cmd+v",
        "fn+w == cmd+w",
        "fn+x == cmd+x",
        "fn+y == cmd+y",
        "fn+z == cmd+z",

        "fn+0 == cmd+0",
        "fn+1 == cmd+1",
        "fn+2 == cmd+2",
        "fn+3 == cmd+3",
        "fn+4 == cmd+4",
        "fn+5 == cmd+5",
        "fn+6 == cmd+6",
        "fn+7 == cmd+7",
        "fn+8 == cmd+8",
        "fn+9 == cmd+9",

        "fn+` == cmd+`",
        "fn+- == cmd+-",
        "fn+= == cmd+=",

        "fn+[ == cmd+[",
        "fn+] == cmd+]",
        "fn+\\ == cmd+\\",

        "fn+; == cmd+;",
        "fn+' == cmd+'",

        "fn+, == cmd+,",
        "fn+. == cmd+.",
        "fn+/ == cmd+/",
    ]
)

mappings(
    devices=[builtin],
    desc="Global: <fn> + <shift> to <cmd> + <shift> (because macos cmd = app's ctrl)",
    maps=[
        "fn+shift+left_arrow == cmd+shift+left_arrow",
        "fn+shift+up_arrow == cmd+shift+up_arrow",
        "fn+shift+right_arrow == cmd+shift+right_arrow",
        "fn+shift+down_arrow == cmd+shift+down_arrow",
        "fn+shift+delete == cmd+shift+delete",
        "fn+shift+space == cmd+shift+space",
        "fn+shift+enter == cmd+shift+enter",
        "fn+shift+tab == cmd+shift+tab",
        "fn+shift+escape == cmd+shift+escape",
        "fn+shift+a == cmd+shift+a",
        "fn+shift+b == cmd+shift+b",
        "fn+shift+c == cmd+shift+c",
        "fn+shift+d == cmd+shift+d",
        "fn+shift+e == cmd+shift+e",
        "fn+shift+f == cmd+shift+f",
        "fn+shift+g == cmd+shift+g",
        "fn+shift+h == cmd+shift+h",
        "fn+shift+i == cmd+shift+i",
        "fn+shift+j == cmd+shift+j",
        "fn+shift+k == cmd+shift+k",
        "fn+shift+l == cmd+shift+l",
        "fn+shift+m == cmd+shift+m",
        "fn+shift+n == cmd+shift+n",
        "fn+shift+o == cmd+shift+o",
        "fn+shift+p == cmd+shift+p",
        "fn+shift+q == cmd+shift+q",
        "fn+shift+r == cmd+shift+r",
        "fn+shift+s == cmd+shift+s",
        "fn+shift+t == cmd+shift+t",
        "fn+shift+u == cmd+shift+u",
        "fn+shift+v == cmd+shift+v",
        "fn+shift+w == cmd+shift+w",
        "fn+shift+x == cmd+shift+x",
        "fn+shift+y == cmd+shift+y",
        "fn+shift+z == cmd+shift+z",
        "fn+shift+0 == cmd+shift+0",
        "fn+shift+1 == cmd+shift+1",
        "fn+shift+2 == cmd+shift+2",
        "fn+shift+3 == cmd+shift+3",
        "fn+shift+4 == cmd+shift+4",
        "fn+shift+5 == cmd+shift+5",
        "fn+shift+6 == cmd+shift+6",
        "fn+shift+7 == cmd+shift+7",
        "fn+shift+8 == cmd+shift+8",
        "fn+shift+9 == cmd+shift+9",
        "fn+shift+` == cmd+shift+`",
        "fn+shift+- == cmd+shift+-",
        "fn+shift+= == cmd+shift+=",
        "fn+shift+[ == cmd+shift+[",
        "fn+shift+] == cmd+shift+]",
        "fn+shift+\\ == cmd+shift+\\",
        "fn+shift+; == cmd+shift+;",
        "fn+shift+' == cmd+shift+'",
        "fn+shift+, == cmd+shift+,",
        "fn+shift+. == cmd+shift+.",
        "fn+shift+/ == cmd+shift+/",
    ]
)

# ========== Galaxy 65 keyboard ==========

mappings(
    devices=[galaxy65],
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
    desc="(Deprecate) Global: Cursor Movement By Word",
    maps=[
        "cmd+delete == opt+delete",
        "cmd+left_arrow == opt+left_arrow",
        "cmd+right_arrow == opt+right_arrow",
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