from dataclasses import dataclass

@dataclass
class KeyboardDevice:
    name: str
    is_built_in: bool
    # vendor_id: int
    # product_id: int
    # list of (vendor_id, product_id)
    idens: list[tuple[int, int]]

    @classmethod
    def built_in(cls, name):
        return cls(
            name=name,
            is_built_in=True,
            # vendor_id=-1,
            # product_id=-1,
            idens=[]
        )


    @classmethod
    def external(cls, name, idens):
        return cls(
            name=name,
            is_built_in=False,
            # vendor_id=vendor_id,
            # product_id=product_id,
            idens=idens
        )

    def build_conditions(self):
        if self.is_built_in:
            return [{ "is_built_in_keyboard": True }]

        else:
            return [
                {
                    "vendor_id": vendor_id,
                    "product_id": product_id,
                }
                for (vendor_id, product_id) in self.idens
            ]


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
    "down_arrow": "down_arrow",
    "up_arrow": "up_arrow",
    "left_arrow": "left_arrow",
    "right_arrow": "right_arrow",
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
            ident_condition
            for device in devices
            for ident_condition in device.build_conditions()
        ]
    }

complex_modifications_rules = []

def mappings(
    devices: list[KeyboardDevice] = [],
    desc: str = "",
    apps: list[str] = [],
    maps: list[str] = []
):
    manipulators = []

    conds = []
    if apps:
        conds.append(build_apps_conditions(apps))

    if devices:
        conds.append(build_devices_conditions(devices))

        label = ','.join([d.name for d in devices])
        prefix = f"[{label}] "
        desc = prefix + desc

    for rule in maps:
        from_, to_ = parse_rule(rule)
        manipulator = {
            "type": "basic",
            "from": from_,
            "to": to_,
        }

        if conds:
            manipulator["conditions"] = conds

        manipulators.append(manipulator)

    res = {
        "description": desc,
        "manipulators": manipulators
    }

    complex_modifications_rules.append(res)

def build_karabiner_config(profile_meta: dict):
    profile = {
        **profile_meta,
        "complex_modifications": {
            "rules": complex_modifications_rules
        }
    }

    karabiner_json = {
        "profiles": [profile]
    }

    return karabiner_json
