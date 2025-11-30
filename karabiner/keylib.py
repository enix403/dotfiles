from typing import Any
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

@dataclass
class KeyCombination:
    mods: list[str]
    key: str

    @staticmethod
    def _norm(key: str) -> str:
        return local_to_karabiner_map.get(key, key)

    @classmethod
    def parse(cls, s: str):
        keys = [cls._norm(k.strip()) for k in s.split("+")]

        mods = keys[:-1]
        key = keys[-1]

        return cls(mods, key)

    def create_from_definition(self):
        return {
            "modifiers": {
                "mandatory": self.mods,
                # "optional": ["any"]
            },
            "key_code": self.key
        }

    def create_to_definition(self):
        return {
            "modifiers": self.mods,
            "key_code": self.key
        }


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

def _register_flows(
    devices: list[KeyboardDevice] = [],
    desc: str = "",
    apps: list[str] = [],
    flows: list[tuple[Any, Any]] = []
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

    for from_, to_ in flows:
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

def global_shell_mappings(
    devices: list[KeyboardDevice] = [],
    desc: str = "",
    apps: list[str] = [],
    maps: list[tuple[str, str]] = []
):
    def parse_map(rule: tuple[str, str]):
        trigger = KeyCombination.parse(rule[0])
        cmd = rule[1]

        from_ = trigger.create_from_definition()
        to_ = {
            "shell_command": cmd,
        }

        return from_, to_

    _register_flows(
        devices,
        desc,
        apps,
        flows=[parse_map(rule) for rule in maps],
    )

def mappings(
    devices: list[KeyboardDevice] = [],
    desc: str = "",
    apps: list[str] = [],
    maps: list[str] = []
):
    def parse_map(rule: str):
        left, right = [KeyCombination.parse(x.strip()) for x in rule.split("==")]

        from_ = left.create_from_definition()
        to_ = right.create_to_definition()

        return from_, to_

    _register_flows(
        devices,
        desc,
        apps,
        flows=[parse_map(rule) for rule in maps],
    )

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
    printable = SubtractableList([ *letters, *digits, *symbols ])
    # special = SubtractableList(["tab", "escape", "delete", "enter", "space"])
    special = SubtractableList(["delete", "space", "enter", "tab", "escape"])

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

