#!/usr/bin/env python3
"""
Generates per-OS VSCode keybindings.json from a canonical keybinds.txt file
plus vendored default keybinding data for each OS.

Usage:
    python3 generate.py [--input keybinds.txt] [--defaults-dir defaults] [--out-dir out]
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

# -- Canonical modifier translation ------------------------------------------
# `mod`   -> cmd on macOS, ctrl on Linux  (the physical bottom-left key)
# `super` -> alt on macOS (Option), meta on Linux (Win) (the key next to it)
# `alt`, `shift`, `ctrl`, `cmd`, `meta` pass through unchanged as escape hatches.

MODIFIERS_CANONICAL = {"mod", "super", "alt", "shift", "ctrl", "cmd", "meta", "win"}

MODIFIER_MAP = {
    "macos": {"mod": "cmd",  "super": "alt",  "win": "alt"},
    "linux": {"mod": "ctrl", "super": "meta", "win": "meta"},
}

# Order used when emitting normalized chords (matches VSCode's own convention).
MODIFIER_ORDER = ["ctrl", "shift", "alt", "cmd", "meta"]


# -- Keybind model -----------------------------------------------------------

@dataclass
class Keybind:
    key: str                 # canonical chord sequence as written by the user
    command: str
    when: str | None = None
    args: dict | None = None
    os: str | None = None    # None | "macos" | "linux"  (None = both)
    # App scope. None = common bind (goes to every generated file). Any other
    # value is a free-form app name; the bind is only included in that app's
    # per-OS output file and does NOT contribute to auto-unbind.
    app: str | None = None
    # If set, this entry was a raw JSON pass-through: emit the dict verbatim
    # (with `key` rewritten for the target OS) and skip auto-unbinding.
    raw: dict[str, object] | None = None
    source_line: int = 0


@dataclass
class DefaultEntry:
    key: str
    command: str
    when: str | None
    args: dict | None
    # Normalized form used for matching; tuple of (frozenset(mods), main_key)
    # per chord in the sequence.
    norm: tuple = field(default_factory=tuple)


# -- Parser for keybinds.txt -------------------------------------------------

def _strip_comments(text: str) -> str:
    """Remove /* ... */ block comments, respecting "..." string literals so
    that JSON containing '/*' inside a string survives intact. Newlines inside
    a stripped comment are preserved so line numbers stay accurate."""
    out: list[str] = []
    i, n = 0, len(text)
    in_str = False
    escape = False
    while i < n:
        c = text[i]
        if in_str:
            out.append(c)
            if escape:
                escape = False
            elif c == "\\":
                escape = True
            elif c == '"':
                in_str = False
            i += 1
            continue
        if c == '"':
            in_str = True
            out.append(c)
            i += 1
            continue
        if c == "/" and i + 1 < n and text[i + 1] == "*":
            # Skip until closing */, but keep newlines.
            j = i + 2
            while j < n and not (text[j] == "*" and j + 1 < n and text[j + 1] == "/"):
                if text[j] == "\n":
                    out.append("\n")
                j += 1
            i = j + 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def _strip_line_comment(line: str) -> str:
    """Remove trailing # or // line comments, respecting quotes."""
    in_single = in_double = False
    i = 0
    while i < len(line):
        c = line[i]
        if c == "'" and not in_double:
            in_single = not in_single
        elif c == '"' and not in_single:
            in_double = not in_double
        elif not in_single and not in_double:
            if c == "#":
                return line[:i]
            if c == "/" and i + 1 < len(line) and line[i + 1] == "/":
                return line[:i]
        i += 1
    return line


def parse_keybinds(path: Path) -> list[Keybind]:
    raw = path.read_text(encoding="utf-8")
    raw = _strip_comments(raw)

    # Group logical lines: a line starting in col 0 begins a new keybind;
    # indented lines continue the previous one.
    logical: list[tuple[int, str]] = []  # (source_line_no, text)
    for lineno, line in enumerate(raw.splitlines(), start=1):
        stripped = _strip_line_comment(line).rstrip()
        if not stripped.strip():
            continue
        if line[:1] in (" ", "\t") and logical:
            prev_lineno, prev_text = logical[-1]
            logical[-1] = (prev_lineno, prev_text + " " + stripped.strip())
        else:
            logical.append((lineno, stripped))

    binds: list[Keybind] = []
    for lineno, text in logical:
        binds.append(_parse_one(text, lineno))
    return binds


def _parse_one(text: str, lineno: int) -> Keybind:
    if text.lstrip().startswith("{"):
        return _parse_json_record(text.lstrip(), lineno)
    if "->" not in text:
        raise SyntaxError(f"line {lineno}: missing '->' separator: {text!r}")
    lhs, rhs = text.split("->", 1)
    chord = lhs.strip()
    if not chord:
        raise SyntaxError(f"line {lineno}: missing chord before '->'")

    rhs = rhs.strip()
    command, parts = _split_rhs_labels(rhs, lineno)

    os_val = _validate_os(parts.get("os"), lineno)
    app_val = _validate_app(parts.get("app"), lineno)

    args = None
    if "args" in parts:
        try:
            args = json.loads(parts["args"])
        except json.JSONDecodeError as e:
            raise SyntaxError(f"line {lineno}: invalid args JSON: {e}") from e

    when = parts.get("when") or None

    if not command:
        raise SyntaxError(f"line {lineno}: missing command")
    if re.search(r"\s", command):
        raise SyntaxError(f"line {lineno}: command contains whitespace: {command!r}")

    return Keybind(
        key=chord, command=command, when=when, args=args,
        os=os_val, app=app_val, source_line=lineno,
    )


def _validate_os(val: str | None, lineno: int) -> str | None:
    if val is None:
        return None
    if val not in ("macos", "linux", "both"):
        raise SyntaxError(
            f"line {lineno}: os: must be 'macos', 'linux', or 'both' (got {val!r})"
        )
    return None if val == "both" else val


_APP_NAME_RE = re.compile(r"^[a-z0-9][a-z0-9_-]*$", re.IGNORECASE)


def _validate_app(val: str | None, lineno: int) -> str | None:
    if val is None:
        return None
    if not _APP_NAME_RE.match(val):
        raise SyntaxError(
            f"line {lineno}: app: name must be alphanumeric/_/- "
            f"(got {val!r})"
        )
    return val


def _parse_json_record(text: str, lineno: int) -> Keybind:
    """Parse `{...}` pass-through entries. The JSON object must contain at
    minimum `key` and `command`; any other fields are preserved verbatim.
    An optional trailing `os: <target>` after the closing `}` restricts the
    entry to a single OS. Modifier translation (mod/super) still applies to
    the `key` field."""
    end = _find_json_end(text)
    if end is None:
        raise SyntaxError(f"line {lineno}: unterminated JSON object")
    json_part = text[:end]
    tail = text[end:].strip()

    try:
        parsed: object = json.loads(json_part)
    except json.JSONDecodeError as e:
        raise SyntaxError(f"line {lineno}: invalid JSON: {e}") from e
    if not isinstance(parsed, dict):
        raise SyntaxError(f"line {lineno}: expected JSON object, got {type(parsed).__name__}")
    obj: dict[str, object] = parsed

    key = obj.get("key")
    command = obj.get("command")
    if not isinstance(key, str) or not key:
        raise SyntaxError(f"line {lineno}: JSON object missing string 'key'")
    if not isinstance(command, str) or not command:
        raise SyntaxError(f"line {lineno}: JSON object missing string 'command'")

    os_val, app_val = _parse_json_tail(tail, lineno)

    when = obj.get("when")
    args = obj.get("args")
    return Keybind(
        key=key,
        command=command,
        when=when if isinstance(when, str) else None,
        args=args if isinstance(args, dict) else None,
        os=os_val,
        app=app_val,
        raw=obj,
        source_line=lineno,
    )


def _parse_json_tail(tail: str, lineno: int) -> tuple[str | None, str | None]:
    """Parse optional trailing `os: X` and/or `app: Y` after a raw JSON block.
    Labels may appear in any order, each at most once."""
    os_val: str | None = None
    app_val: str | None = None
    rest = tail.strip()
    while rest:
        m = re.match(r"(os|app)\s*:\s*(\S+)\s*", rest)
        if not m:
            raise SyntaxError(
                f"line {lineno}: unexpected trailing text after JSON: {rest!r}"
                f" (only `os: <target>` and `app: <name>` are allowed)"
            )
        label, value = m.group(1), m.group(2)
        if label == "os":
            if os_val is not None:
                raise SyntaxError(f"line {lineno}: duplicate os: label after JSON")
            os_val = _validate_os(value, lineno)
        else:
            if app_val is not None:
                raise SyntaxError(f"line {lineno}: duplicate app: label after JSON")
            app_val = _validate_app(value, lineno)
        rest = rest[m.end():]
    return os_val, app_val


def _find_json_end(text: str) -> int | None:
    """Return the index one past the matching `}` for the object starting at
    text[0]=='{'. Quote- and escape-aware."""
    depth = 0
    in_str = False
    escape = False
    for i, c in enumerate(text):
        if in_str:
            if escape:
                escape = False
            elif c == "\\":
                escape = True
            elif c == '"':
                in_str = False
            continue
        if c == '"':
            in_str = True
        elif c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return i + 1
    return None


# Labels recognised on the right-hand side. Fixed order: os, app, when, args.
_RHS_LABELS = ("os", "app", "when", "args")


def _split_rhs_labels(rhs: str, lineno: int) -> tuple[str, dict[str, str]]:
    """Parse 'command [os: X] [when: Y] [args: JSON]' — labels must appear
    in that order. Returns (command, {label: raw_value})."""
    positions: dict[str, re.Match[str]] = {}
    for label in _RHS_LABELS:
        m = re.search(rf"(?<!\S)\b{label}\s*:\s*", rhs)
        if m:
            positions[label] = m

    present = [(positions[l], l) for l in _RHS_LABELS if l in positions]
    for i in range(1, len(present)):
        if present[i][0].start() < present[i - 1][0].start():
            raise SyntaxError(
                f"line {lineno}: labels must appear in order os:, app:, when:, args:"
            )

    parts: dict[str, str] = {}
    next_start = len(rhs)
    for m, label in reversed(present):
        parts[label] = rhs[m.end():next_start].strip()
        next_start = m.start()
    command = rhs[:next_start].strip()
    return command, parts


# -- Default keybindings loading + normalization -----------------------------

_LEADING_COMMENT_RE = re.compile(r"^\s*//[^\n]*\n", re.MULTILINE)


def load_defaults(path: Path) -> list[DefaultEntry]:
    """Load vendored codebling JSON; first line is a // banner comment."""
    text = path.read_text(encoding="utf-8")
    # Strip any leading // line comments until the first non-comment line.
    lines = []
    started = False
    for line in text.splitlines():
        if not started and line.lstrip().startswith("//"):
            continue
        started = True
        lines.append(line)
    data = json.loads("\n".join(lines))

    entries: list[DefaultEntry] = []
    for raw in data:
        entries.append(DefaultEntry(
            key=raw["key"],
            command=raw["command"],
            when=raw.get("when"),
            args=raw.get("args"),
            norm=normalize_chord_sequence(raw["key"]),
        ))
    return entries


def normalize_chord_sequence(key: str) -> tuple:
    """Normalize 'shift+cmd+k cmd+s' -> (({shift,cmd}, 'k'), ({cmd}, 's'))."""
    return tuple(_normalize_chord(c) for c in key.split())


def _normalize_chord(chord: str) -> tuple:
    parts = [p.strip().lower() for p in chord.split("+") if p.strip()]
    if not parts:
        return (frozenset(), "")
    # The last part is the main key; everything before it is a modifier.
    mods = frozenset(parts[:-1])
    main = parts[-1]
    return (mods, main)


# -- Canonical -> OS-specific rewriting --------------------------------------

def resolve_for_os(chord_sequence: str, target_os: str) -> str:
    """Rewrite canonical modifiers (mod/super/win) to OS-specific ones."""
    mapping = MODIFIER_MAP[target_os]
    out_chords = []
    for chord in chord_sequence.split():
        parts = chord.split("+")
        if not parts:
            continue
        mods, main = parts[:-1], parts[-1]
        resolved_mods = []
        for m in mods:
            m_lc = m.lower()
            resolved_mods.append(mapping.get(m_lc, m_lc))
        # Dedupe while keeping a stable order, then sort by MODIFIER_ORDER.
        seen = set()
        uniq = []
        for m in resolved_mods:
            if m not in seen:
                seen.add(m)
                uniq.append(m)
        uniq.sort(key=lambda m: MODIFIER_ORDER.index(m) if m in MODIFIER_ORDER else 99)
        out_chords.append("+".join([*uniq, main.lower()]))
    return " ".join(out_chords)


# -- Core generation ---------------------------------------------------------

def generate_for_os(
    binds: list[Keybind],
    defaults: list[DefaultEntry],
    target_os: str,
    current_app: str | None = None,
) -> list[dict[str, object]]:
    """Produce the list of entries for one output file.

    - current_app=None generates the base file: common binds only (b.app is None).
    - current_app=X generates the per-app file: common binds + binds tagged
      `app: X`. App-tagged binds do not contribute to auto-unbind.
    """
    # Drop binds restricted to a different OS.
    binds = [b for b in binds if b.os is None or b.os == target_os]

    # Filter by app scope.
    if current_app is None:
        binds = [b for b in binds if b.app is None]
    else:
        binds = [b for b in binds if b.app is None or b.app == current_app]

    # Auto-unbind applies only to DSL-style positive, non-app-scoped binds.
    # Raw JSON records are pure pass-through; DSL targeted unbinds (command
    # starting with `-`) are emitted verbatim without triggering auto-unbind;
    # app-tagged binds are also pass-through so the user can override a
    # single command per-app without side effects.
    dsl_positives = [
        b for b in binds
        if b.raw is None and not b.command.startswith("-") and b.app is None
    ]

    # Index defaults by command for command-based auto-unbind ("move"
    # semantics): when the user binds a command at a new chord, remove it
    # from its original default chord(s) in the current OS.
    defaults_by_command: dict[str, list[DefaultEntry]] = {}
    for d in defaults:
        defaults_by_command.setdefault(d.command, []).append(d)

    # Chord-based auto-unbind: for each chord the user rebinds, unbind all
    # defaults that live on that exact chord in this OS.
    unbind_norms: dict[tuple, str] = {}  # norm -> resolved key string
    for b in dsl_positives:
        resolved_key = resolve_for_os(b.key, target_os)
        norm = normalize_chord_sequence(resolved_key)
        if norm not in unbind_norms:
            unbind_norms[norm] = resolved_key

    entries: list[dict[str, object]] = []
    emitted_unbinds: set[tuple[str, str, str | None]] = set()

    def _emit_unbind(key: str, command: str, when: str | None) -> None:
        # Note: unbinds match by (key, command, when) only — args are not
        # part of the identity, so we omit them here.
        ident = (key, command, when)
        if ident in emitted_unbinds:
            return
        emitted_unbinds.add(ident)
        entry: dict[str, object] = {"key": key, "command": "-" + command}
        if when is not None:
            entry["when"] = when
        entries.append(entry)

    # 1. Chord-based unbinds.
    for norm, resolved_key in unbind_norms.items():
        for d in [d for d in defaults if d.norm == norm]:
            _emit_unbind(resolved_key, d.command, d.when)

    # 2. Command-based unbinds (move semantics). For each positive, look up
    #    the command in this OS's defaults and unbind every chord it lives
    #    on, so the old default location stops firing. Commands not in the
    #    defaults index (typically extension commands) are skipped — the
    #    user must supply an explicit targeted unbind for those.
    for b in dsl_positives:
        for d in defaults_by_command.get(b.command, []):
            _emit_unbind(d.key, d.command, d.when)

    # 3. Emit user entries (positives, targeted unbinds, and raw JSON) in
    #    declaration order. Dedup against auto-emitted unbinds so a user's
    #    explicit `-cmd` that duplicates an auto-unbind is collapsed.
    for b in binds:
        resolved_key = resolve_for_os(b.key, target_os)
        if b.raw is not None:
            out = dict(b.raw)
            out["key"] = resolved_key
            entries.append(out)
            continue
        if b.command.startswith("-"):
            ident = (resolved_key, b.command[1:], b.when)
            if ident in emitted_unbinds:
                continue
            emitted_unbinds.add(ident)
        entry = {"key": resolved_key, "command": b.command}
        if b.when is not None:
            entry["when"] = b.when
        if b.args is not None:
            entry["args"] = b.args
        entries.append(entry)

    return entries


# -- Output formatting -------------------------------------------------------

def format_output(entries: list[dict[str, object]], banner: str) -> str:
    """Compact, reviewable JSON: one keybind per line. Known fields come
    first in a friendly order; any extra fields (from raw JSON pass-through)
    follow in their original order."""
    known = ("key", "command", "when", "args")
    lines = ["// " + banner, "[ "]
    for i, e in enumerate(entries):
        ordered: dict[str, object] = {}
        for k in known:
            if k in e:
                ordered[k] = e[k]
        for k, v in e.items():
            if k not in ordered:
                ordered[k] = v
        suffix = "," if i < len(entries) - 1 else ""
        lines.append("  " + json.dumps(ordered, ensure_ascii=False) + suffix)
    lines.append("]")
    lines.append("")
    return "\n".join(lines)


# -- CLI ---------------------------------------------------------------------

BANNER = (
    "AUTO-GENERATED by vscode-keybinds-gen — do not edit by hand. "
    "Edit keybinds.txt and re-run generate.py."
)


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--input", type=Path, default=Path("keybinds.txt"))
    p.add_argument("--defaults-dir", type=Path, default=Path("defaults"))
    p.add_argument("--out-dir", type=Path, default=Path("out"))
    p.add_argument("--os", choices=["macos", "linux", "both"], default="both")
    args = p.parse_args(argv)

    if not args.input.exists():
        print(f"error: input file not found: {args.input}", file=sys.stderr)
        return 2

    binds = parse_keybinds(args.input)
    args.out_dir.mkdir(parents=True, exist_ok=True)

    apps = sorted({b.app for b in binds if b.app is not None})
    targets = ["macos", "linux"] if args.os == "both" else [args.os]

    for target in targets:
        defaults_path = args.defaults_dir / f"{target}.keybindings.json"
        if not defaults_path.exists():
            print(f"error: missing defaults: {defaults_path}", file=sys.stderr)
            return 2
        defaults = load_defaults(defaults_path)

        # Base file: common binds only.
        entries = generate_for_os(binds, defaults, target, current_app=None)
        out_path = args.out_dir / f"keybinds.{target}.json"
        out_path.write_text(format_output(entries, BANNER), encoding="utf-8")
        print(f"wrote {out_path} ({len(entries)} entries)")

        # Per-app file: common + app-tagged.
        for app in apps:
            entries = generate_for_os(binds, defaults, target, current_app=app)
            out_path = args.out_dir / f"keybinds.{app}.{target}.json"
            out_path.write_text(format_output(entries, BANNER), encoding="utf-8")
            print(f"wrote {out_path} ({len(entries)} entries)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
