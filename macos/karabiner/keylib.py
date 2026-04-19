"""Karabiner Elements config builder.

Describe keyboards declaratively via `Layout`; the library expands each layout
into the chord-level `complex_modifications` rules that Karabiner consumes.
"""

from dataclasses import dataclass, field
from typing import Iterable


# ---------------------------------------------------------------------------
# Key name translation: local shorthand -> Karabiner key_code
# ---------------------------------------------------------------------------

KARABINER_KEY_NAMES: dict[str, str] = {
    # modifiers
    "cmd": "left_command",
    "opt": "left_option",
    "ctrl": "left_control",
    "shift": "left_shift",
    "fn": "fn",

    # symbols
    "`":  "grave_accent_and_tilde",
    "-":  "hyphen",
    "=":  "equal_sign",
    "[":  "open_bracket",
    "]":  "close_bracket",
    "\\": "backslash",
    ";":  "semicolon",
    "'":  "quote",
    ",":  "comma",
    ".":  "period",
    "/":  "slash",

    # named keys
    "space":  "spacebar",
    "enter":  "return_or_enter",
    "tab":    "tab",
    "escape": "escape",
    "delete": "delete_or_backspace",

    # arrows (pass-through, listed for completeness)
    "left":  "left_arrow",
    "right": "right_arrow",
    "up":    "up_arrow",
    "down":  "down_arrow",
}

def _kcode(name: str) -> str:
    return KARABINER_KEY_NAMES.get(name, name)


# ---------------------------------------------------------------------------
# KeySet: iterable groups of key names used when expanding chords
# ---------------------------------------------------------------------------

class _Keys(list):
    """list subclass with `-` for "everything except these" expansions."""
    def __sub__(self, other):
        drop = set(other) if isinstance(other, (list, tuple, set)) else {other}
        return _Keys(x for x in self if x not in drop)


class KeySet:
    letters   = _Keys("abcdefghijklmnopqrstuvwxyz")
    digits    = _Keys("0123456789")
    symbols   = _Keys("`-=[]\\;',./")
    printable = _Keys([*letters, *digits, *symbols])
    special   = _Keys(["delete", "space", "enter", "tab", "escape"])
    h_arrows  = _Keys(["left", "right"])
    v_arrows  = _Keys(["up", "down"])
    arrows    = _Keys([*h_arrows, *v_arrows])


# ---------------------------------------------------------------------------
# Devices
# ---------------------------------------------------------------------------

@dataclass
class KeyboardDevice:
    name: str
    is_built_in: bool
    idens: list[tuple[int, int]]  # (vendor_id, product_id) pairs

    @classmethod
    def built_in(cls, name: str) -> "KeyboardDevice":
        return cls(name=name, is_built_in=True, idens=[])

    @classmethod
    def external(cls, name: str, idens: list[tuple[int, int]]) -> "KeyboardDevice":
        return cls(name=name, is_built_in=False, idens=idens)

    def device_identifiers(self) -> list[dict]:
        if self.is_built_in:
            return [{"is_built_in_keyboard": True}]
        return [{"vendor_id": v, "product_id": p} for (v, p) in self.idens]


# ---------------------------------------------------------------------------
# Chord parsing
# ---------------------------------------------------------------------------

@dataclass
class Chord:
    mods: list[str]  # Karabiner key_codes for modifiers, e.g. "left_command"
    key: str         # Karabiner key_code for the main key

    @classmethod
    def parse(cls, s: str) -> "Chord":
        parts = [_kcode(p.strip()) for p in s.split("+")]
        return cls(mods=parts[:-1], key=parts[-1])

    def as_from(self) -> dict:
        return {
            "modifiers": {
                "mandatory": [*self.mods],
            },
            "key_code": self.key,
        }

    def as_to(self) -> dict:
        return {"modifiers": self.mods, "key_code": self.key}


# ---------------------------------------------------------------------------
# Rule registry
# ---------------------------------------------------------------------------

_rules: list[dict] = []


def _apps_condition(bundle_ids: list[str]) -> dict:
    return {
        "type": "frontmost_application_if",
        "bundle_identifiers": ["^" + b.replace(".", "\\.") + "$" for b in bundle_ids],
    }


def _devices_condition(devices: list[KeyboardDevice]) -> dict:
    return {
        "type": "device_if",
        "identifiers": [ident for d in devices for ident in d.device_identifiers()],
    }


def _register(desc: str, devices: list[KeyboardDevice], apps: list[str], manipulators: list[dict]) -> None:
    conds = []
    if apps:
        conds.append(_apps_condition(apps))
    if devices:
        conds.append(_devices_condition(devices))
        desc = f"[{','.join(d.name for d in devices)}] {desc}"

    if conds:
        for m in manipulators:
            m["conditions"] = conds

    _rules.append({"description": desc, "manipulators": manipulators})


# ---------------------------------------------------------------------------
# Public rule helpers
# ---------------------------------------------------------------------------

def mappings(
    *,
    desc: str,
    maps: list[str],
    devices: list[KeyboardDevice] | None = None,
    apps: list[str] | None = None,
) -> None:
    """Register chord->chord mappings. Each entry in `maps` is `"from == to"`."""
    manipulators = []
    for rule in maps:
        left, right = [Chord.parse(s.strip()) for s in rule.split("==")]
        manipulators.append({"type": "basic", "from": left.as_from(), "to": [right.as_to()]})
    _register(desc, devices or [], apps or [], manipulators)


def shell_mappings(
    *,
    desc: str,
    maps: list[tuple[str, str]],
    devices: list[KeyboardDevice] | None = None,
    apps: list[str] | None = None,
) -> None:
    """Register chord->shell_command mappings."""
    manipulators = [
        {
            "type": "basic",
            "from": Chord.parse(trigger).as_from(),
            "to": [{"shell_command": cmd}],
        }
        for trigger, cmd in maps
    ]
    _register(desc, devices or [], apps or [], manipulators)


# ---------------------------------------------------------------------------
# Chord expansion
# ---------------------------------------------------------------------------

def _flatten(items: Iterable) -> list[str]:
    out = []
    for item in items:
        if isinstance(item, (list, tuple)):
            out.extend(_flatten(item))
        else:
            out.append(item.strip())
    return out


def chords(from_prefix: str, to_prefix: str, keys: Iterable) -> list[str]:
    """Expand `[a, b]` with prefixes `X`/`Y` into `["X+a == Y+a", "X+b == Y+b"]`."""
    fp, tp = from_prefix.strip(), to_prefix.strip()
    return [f"{fp}+{k} == {tp}+{k}" for k in _flatten(keys)]


# ---------------------------------------------------------------------------
# Layout: a keyboard's physical -> intended modifier mapping
# ---------------------------------------------------------------------------

# Keys that need a word-level cursor-movement override when pressed with the
# "linux-ctrl" modifier (the physical modifier that is remapped to `cmd`).
_CURSOR_KEYS = ["left", "right", "delete"]
_CURSOR_ARROW_KEYS = ["left", "right"]


@dataclass
class Layout:
    device: KeyboardDevice
    # physical modifier -> intended modifier (shorthand names: fn/cmd/opt/ctrl)
    modifier_map: dict[str, str] = field(default_factory=dict)

    def _linux_ctrl_key(self) -> str | None:
        for phys, intended in self.modifier_map.items():
            if intended == "cmd":
                return phys
        return None

    def register(self) -> None:
        self._register_cursor_movement()
        self._register_modifier_remaps()

    # ----- step 1: cursor-movement exceptions (higher priority) -----
    def _register_cursor_movement(self) -> None:
        phys = self._linux_ctrl_key()
        if phys is None:
            return

        mappings(
            desc="Cursor movement by word",
            devices=[self.device],
            maps=[
                *chords(phys,           "opt",       _CURSOR_KEYS),
                *chords(f"{phys}+shift", "opt+shift", _CURSOR_ARROW_KEYS),
            ],
        )

    # ----- step 2: general chord translation per modifier -----
    def _register_modifier_remaps(self) -> None:
        linux_ctrl = self._linux_ctrl_key()

        for phys, intended in self.modifier_map.items():
            if phys == linux_ctrl:
                # Cursor-movement rule owns {delete, left, right} — exclude here.
                plain_keys = KeySet.printable + (KeySet.special - "delete") + KeySet.v_arrows
                shift_keys = KeySet.printable + (KeySet.special - "delete") + KeySet.v_arrows
            else:
                plain_keys = KeySet.printable + KeySet.special + KeySet.arrows
                shift_keys = KeySet.printable + KeySet.special + KeySet.arrows

            mappings(
                desc=f"{phys} -> {intended}",
                devices=[self.device],
                maps=chords(phys, intended, plain_keys),
            )
            mappings(
                desc=f"{phys}+shift -> {intended}+shift",
                devices=[self.device],
                maps=chords(f"{phys}+shift", f"{intended}+shift", shift_keys),
            )


# ---------------------------------------------------------------------------
# Build final karabiner.json structure
# ---------------------------------------------------------------------------

def build_karabiner_config(profile_meta: dict) -> dict:
    profile = {
        **profile_meta,
        "complex_modifications": {"rules": list(_rules)},
    }
    return {"profiles": [profile]}
