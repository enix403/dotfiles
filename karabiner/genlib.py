import json
from dataclasses import dataclass

@dataclass
class KeyboardDevice:
    is_built_in: bool
    vendor_id: int
    product_id: int

    @classmethod
    def built_in(cls):
        return cls(
            is_built_in=True,
            vendor_id=-1,
            product_id=-1,
        )


    @classmethod
    def external(cls, vendor_id, product_id):
        return cls(
            is_built_in=False,
            vendor_id=vendor_id,
            product_id=product_id,
        )

    def build_condition(self):
        if self.is_built_in:
            return {
                "is_built_in_keyboard": True
            }

        else:
            return {
                "product_id": self.product_id,
                "vendor_id": self.vendor_id
            }


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

def build_apps_conditions(app_bundles: list[str]):
    return {
        "type": "frontmost_application_if",
        "bundle_identifiers": [
            "^" + b.replace(".", "\\.") + "$"
            for b in app_bundles
        ]
    }

def build_devices_conditions(devices: list[KeyboardDevice]):
    return {
        "type": "device_if",
        "identifiers": [
            device.build_condition()
            for device in devices
        ]
    }

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

        conds = []

        if apps:
            conds.append(build_apps_conditions(apps))

        if devices:
            conds.append(build_devices_conditions(devices))

        if conds:
            manipulator["conditions"] = conds

        manipulators.append(manipulator)

    res = {
        "description": desc,
        "manipulators": manipulators
    }

    print(json.dumps(res))
