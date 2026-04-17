#!/usr/bin/env python3
"""
Refresh vendored default VSCode keybindings from the upstream repo:
    https://github.com/codebling/vs-code-default-keybindings

For each target OS file, fetches the latest version and reports whether the
local copy is new, unchanged, or updated (with a line count diff and the
VSCode version banner from the file header).

Usage:
    python3 refresh-defaults.py            # fetch + write
    python3 refresh-defaults.py --check    # report-only, no writes
"""

from __future__ import annotations

import argparse
import sys
import urllib.error
import urllib.request
from pathlib import Path

BASE = "https://raw.githubusercontent.com/codebling/vs-code-default-keybindings/master"
FILES = (
    "macos.keybindings.json",
    "linux.keybindings.json",
)


def _banner(text: str) -> str:
    """Extract the leading '// ...' banner line (VSCode version info)."""
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("//"):
            return stripped[2:].strip()
        if stripped:
            break
    return "(no banner)"


def _fetch(url: str) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "vscode-keybinds-gen"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read()


def refresh_one(name: str, out_dir: Path, check_only: bool) -> tuple[str, str]:
    """Returns (status, detail) for a single file."""
    url = f"{BASE}/{name}"
    dest = out_dir / name
    try:
        remote = _fetch(url)
    except urllib.error.URLError as e:
        return ("error", f"fetch failed: {e}")

    remote_text = remote.decode("utf-8")
    remote_lines = remote_text.count("\n") + (0 if remote_text.endswith("\n") else 1)
    remote_banner = _banner(remote_text)

    if not dest.exists():
        if not check_only:
            dest.write_bytes(remote)
        return ("new", f"{remote_lines} lines — {remote_banner}")

    local = dest.read_bytes()
    if local == remote:
        return ("unchanged", remote_banner)

    local_text = local.decode("utf-8")
    local_lines = local_text.count("\n") + (0 if local_text.endswith("\n") else 1)
    local_banner = _banner(local_text)
    delta = remote_lines - local_lines
    sign = "+" if delta >= 0 else ""
    detail = f"{local_lines} -> {remote_lines} lines ({sign}{delta})"
    if remote_banner != local_banner:
        detail += f"\n                {local_banner}\n             -> {remote_banner}"
    if not check_only:
        dest.write_bytes(remote)
    return ("updated", detail)


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--check", action="store_true",
                   help="report only; do not write changes")
    p.add_argument("--out-dir", type=Path,
                   default=Path(__file__).parent / "defaults")
    args = p.parse_args(argv)

    args.out_dir.mkdir(parents=True, exist_ok=True)
    print(f"source: {BASE}")
    print(f"target: {args.out_dir}" + ("  (check-only)" if args.check else ""))
    print()

    any_error = False
    any_change = False
    for name in FILES:
        status, detail = refresh_one(name, args.out_dir, args.check)
        print(f"  [{status:<9}] {name}  {detail}")
        if status == "error":
            any_error = True
        elif status in ("new", "updated"):
            any_change = True

    print()
    if any_error:
        print("some files failed to refresh")
        return 1
    if args.check and any_change:
        print("defaults are out of date; re-run without --check to apply")
        return 1
    if args.check:
        print("all defaults up to date")
    else:
        print("done")
    return 0


if __name__ == "__main__":
    sys.exit(main())
