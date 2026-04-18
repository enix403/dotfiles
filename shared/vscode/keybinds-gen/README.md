# vscode-keybinds-gen

A small code-generator for VSCode (and Cursor, and any VSCode-derived editor)
keybindings. You edit one canonical, OS-agnostic source file
([keybinds.txt](keybinds.txt)), and the generator emits per-OS, per-app
`keybindings.json` files under [out/](out/).

Two scripts:

- [generate.py](generate.py) — reads [keybinds.txt](keybinds.txt) + the
  vendored default keybindings under [defaults/](defaults) and produces
  the files under [out/](out/).
- [refresh-defaults.py](refresh-defaults.py) — refreshes
  [defaults/](defaults) from the upstream
  [codebling/vs-code-default-keybindings](https://github.com/codebling/vs-code-default-keybindings)
  repo.

---

## Why

Maintaining `keybindings.json` by hand is painful for three reasons:

1. **Cross-OS drift.** `cmd+s` on macOS and `ctrl+s` on Linux are the
   "same" bind logically, but you have to write them twice and remember
   to keep them in sync.
2. **Moving a command leaves its old chord wired up.** If you rebind
   `editor.action.copyLinesDownAction` from `shift+alt+down` (the
   default) to `mod+shift+d`, VSCode still fires the command on the
   old chord unless you also emit `-editor.action.copyLinesDownAction`
   at `shift+alt+down`. Easy to forget, doubly annoying when the
   default differs per OS.
3. **Rebinding a chord leaves every other default on that chord firing.**
   If you bind `mod+enter -> notebook.cell.execute`, VSCode keeps firing
   `editor.action.insertLineAfter`, `workbench.action.chat.submitWithCodebase`,
   `mergeEditor.acceptMerge`, and a dozen more defaults on `cmd+enter`
   in their own contexts. Some of those you want to keep; some you
   don't. Writing the right set of `-command` entries by hand is
   tedious and drifts as VSCode ships new defaults.

This tool fixes all three: one canonical modifier vocabulary
(`mod`/`super`), **command-based auto-unbind** to clear a moved
command's old chord on every OS, and **chord-based auto-unbind
scoped by `when` clause** so you only disturb the exact context you're
replacing.

---

## How it works

```
          keybinds.txt           defaults/<os>.keybindings.json
              │                              │
              └──────────────┬───────────────┘
                             ▼
                         generate.py
                             ▼
     out/keybinds.<os>.json   out/keybinds.<app>.<os>.json ...
```

Per run, for each target OS, [generate.py](generate.py):

1. **Parses** [keybinds.txt](keybinds.txt) into a list of `Keybind`
   records.
2. **Loads** the vendored defaults for that OS (e.g.
   [defaults/macos.keybindings.json](defaults/macos.keybindings.json))
   into a list of `DefaultEntry` records, each with a normalized chord
   form for fast matching.
3. **Resolves** every canonical chord (`mod+shift+k`) into the
   OS-specific form (`shift+cmd+k` on macOS, `ctrl+shift+k` on Linux).
4. **Emits unbinds** for defaults that conflict with the new bindings
   (see [Auto-unbind](#auto-unbind) below).
5. **Emits** the user's own entries verbatim (with modifier translation
   applied).
6. **Writes** one file per `(app, os)` combination.

The "base" file, `keybinds.<os>.json`, only contains common bindings
(no `app:` tag). Each distinct `app:` label in [keybinds.txt](keybinds.txt)
produces an additional `keybinds.<app>.<os>.json` that contains the
common bindings **plus** that app's bindings. You symlink or copy the
right file into each editor's `User/keybindings.json` location.

---

## The source file: `keybinds.txt`

### Line syntax

```
<chord> [<chord>...] -> <command>
    [os: <target>] [app: <name>] [when: <expr>] [args: <json>]
```

Labels on the RHS must appear in that fixed order: `os`, `app`, `when`,
`args`. A line whose first character is whitespace **continues** the
previous logical entry, so long `when` clauses or JSON args can be
broken across lines.

Example:

```
mod+shift+o  -> workbench.action.terminal.newWithCwd
    when: editorIsOpen && resourceScheme == 'file'
    args: {"cwd": "${fileDirname}"}
```

### Modifier vocabulary

| Canonical | macOS   | Linux  | Notes                                 |
|-----------|---------|--------|---------------------------------------|
| `mod`     | `cmd`   | `ctrl` | Bottom-left physical key.             |
| `super`   | `alt`   | `meta` | Next key over (Option / Win).         |
| `win`     | `alt`   | `meta` | Alias of `super`.                     |
| `alt`     | `alt`   | `alt`  | Physical Alt (rarely used on macOS).  |
| `shift`   | `shift` | `shift`| Pass-through.                         |
| `ctrl`    | `ctrl`  | `ctrl` | Escape hatch — literal Ctrl on macOS. |
| `cmd`     | `cmd`   | `cmd`  | Escape hatch — macOS-only, emit raw.  |
| `meta`    | `meta`  | `meta` | Escape hatch — Linux Win key raw.     |

On emit, modifiers are deduped and sorted into VSCode's canonical
order: `ctrl, shift, alt, cmd, meta`. See
[`resolve_for_os`](generate.py#L379).

### Labels

| Label   | Values                               | Effect                                           |
|---------|--------------------------------------|--------------------------------------------------|
| `os`    | `macos` \| `linux` \| `both`         | Restrict this bind to one OS. Default: both.     |
| `app`   | alphanumeric/`_`/`-`                 | Restrict to one per-app output file (see below). |
| `when`  | any VSCode context expression        | Standard VSCode `when` clause, passed through.   |
| `args`  | JSON object (must be last)           | Standard VSCode `args`, passed through.          |

### Commands

- **Positive** (`command`) — binds the chord to the command.
- **Targeted unbind** (`-command`) — emits a negative binding at that
  chord. Does **not** trigger auto-unbind. Use for pure chord disables
  or to unbind extension commands that aren't in the upstream defaults.
- **Raw JSON pass-through** — a line starting with `{ ... }` is parsed
  as a JSON object and emitted verbatim (modifier translation is still
  applied to `key`). Optional trailing `os:` / `app:` labels apply. No
  auto-unbind. Use this for keybinding fields not covered by the DSL.

### Comments

- `#` or `//` for line comments (including trailing).
- `/* ... */` for block comments; quote- and newline-aware so comments
  inside JSON strings survive and line numbers stay accurate.

---

## Auto-unbind

Two independent mechanisms run for every **positive, non-app-scoped,
non-raw DSL** bind. Together they keep the output consistent with the
user's intent without manual bookkeeping.

### 1. Chord-based unbind (scoped by `when`)

For each positive bind, find every default on the **same resolved chord
sequence** whose `when` clause is **equal** to the bind's `when`
(treating both-missing as equal), and emit a negative binding for each
match.

> Defaults on the same chord with a *different* `when` are preserved.

Example — binding `mod+enter -> notebook.cell.execute` with a
notebook-specific `when` clause:

- ✅ Unbinds any default `cmd+enter` with that exact same `when`.
- ✅ Leaves `cmd+enter -> workbench.action.chat.submitWithCodebase when:
  ... && inChatInput && ...` untouched.
- ✅ Leaves `cmd+enter -> mergeEditor.acceptMerge when: isMergeEditor`
  untouched.
- ✅ Leaves `cmd+enter -> breadcrumbs.revealFocused when: breadcrumbsActive
  && breadcrumbsVisible` untouched.

This is the conservative default: you only disturb the exact context
you're replacing. If you *do* want to kill one of those sibling
defaults, add an explicit targeted `-command` line for it.

See [`generate.py:449-462`](generate.py#L449-L462).

### 2. Command-based unbind (move semantics)

For each positive bind, look up the command in the current OS's
defaults and emit a negative binding at **every chord** the command
currently lives on. This clears the command's old home so rebinding
`foo` to a new chord cleanly "moves" it.

Example — `mod+shift+d -> editor.action.copyLinesDownAction`:

- macOS defaults have `copyLinesDownAction` on `shift+alt+down` →
  emits `shift+alt+down -> -editor.action.copyLinesDownAction`.
- Linux defaults have it on the same chord → emits the same unbind for
  Linux.

Commands not present in the defaults index (typical for extension
commands like Cursor's `composer.*` or `aichat.*`) are silently skipped
— you must supply an explicit targeted unbind for those. See the
Cursor section of [keybinds.txt](keybinds.txt) for worked examples.

See [`generate.py:471-473`](generate.py#L471-L473).

### Opt-outs

Auto-unbind runs for **positive DSL binds that are not `app:`-tagged
and not raw JSON**. To opt out of auto-unbind, use one of:

- `-command` targeted unbind — pure scoping/disable, no side effects.
- `{ "key": "...", "command": "..." }` raw JSON — pure pass-through.
- `app: <name>` tag — app-scoped; relies on the base file's auto-unbind
  for the chord if needed, otherwise combine with explicit targeted
  unbinds.

### Deduplication

Unbinds are identified by `(key, command, when)`. `args` is
deliberately not part of the identity, because a VSCode unbind removes
a binding regardless of `args`. If your targeted `-command` collides
with an auto-emitted unbind, only one entry is kept — safe to write
both.

---

## Per-app scope

Every `app: <name>` used in [keybinds.txt](keybinds.txt) causes an
extra output file `keybinds.<name>.<os>.json` to be generated. That
file contains:

- Every common bind (no `app:` tag).
- Plus every bind tagged `app: <name>`.

The "base" file `keybinds.<os>.json` contains **only** the common binds
— app-tagged binds never leak into it.

App-scoped binds do **not** trigger auto-unbind of any kind. This is
because their commands are typically editor-specific extensions (e.g.
Cursor's `composer.startComposerPrompt`) that don't exist in the
upstream VSCode defaults, so auto-unbind would be both wrong (they're
not on any default chord to "move" from) and unsafe (chord-based
unbind could clobber a VSCode default you rely on). Pair them with
explicit targeted unbinds where needed.

A single bind can have at most one `app:` tag.

---

## CLI

### generate.py

```
python3 generate.py [--input keybinds.txt]
                    [--defaults-dir defaults]
                    [--out-dir out]
                    [--os macos|linux|both]
```

All arguments are optional; defaults match the repo layout. Exit code
`0` on success, `2` on input/missing-defaults errors.

### refresh-defaults.py

```
python3 refresh-defaults.py           # fetch + write
python3 refresh-defaults.py --check   # report-only
```

Pulls both `macos.keybindings.json` and `linux.keybindings.json` from
[`codebling/vs-code-default-keybindings`](https://github.com/codebling/vs-code-default-keybindings),
compares against the local copy, and either writes or reports a line
count diff plus the VSCode version banner. Exit code `1` if any fetch
fails or (in `--check` mode) if any file is out of date.

Run this when a new VSCode release changes the defaults; then re-run
`generate.py` to pick up any new chord conflicts.

---

## Repository layout

```
keybinds-gen/
├── generate.py              # the generator
├── refresh-defaults.py      # updater for defaults/
├── keybinds.txt             # canonical source of truth (edit this)
├── defaults/                # vendored upstream VSCode defaults
│   ├── macos.keybindings.json
│   └── linux.keybindings.json
└── out/                     # generated; wire these into your editor(s)
    ├── keybinds.macos.json
    ├── keybinds.linux.json
    ├── keybinds.cursor.macos.json
    └── keybinds.cursor.linux.json
```

The generated files are plain `keybindings.json` arrays with a leading
`// AUTO-GENERATED ...` banner line, one bind per output line for
review-friendly diffs. Known fields (`key`, `command`, `when`, `args`)
are emitted first; any extra fields from raw JSON pass-throughs follow
in their original order.

---

## Implementation notes

- **Parser.** Comment stripping is quote-aware so `/*` inside a JSON
  string survives. Newlines inside stripped block comments are
  preserved so line numbers reported in syntax errors remain accurate.
  See [`_strip_comments`](generate.py#L67).
- **Chord normalization.** `normalize_chord_sequence` maps a chord
  sequence to a tuple of `(frozenset(mods), main_key)` pairs. This is
  the key used for chord-based matching against defaults. Modifier
  order and casing don't affect matching.
- **Emit order.** Within each output file: chord-based unbinds first,
  then command-based unbinds, then the user's own entries in
  declaration order. This keeps the file grouped the way a reviewer
  would expect: "what we removed" above "what we added."
- **No dependencies.** Pure Python 3 stdlib — runs anywhere Python ≥
  3.10 is installed (uses `|` union types and PEP 604 syntax).

---

## Editing workflow

1. Edit [keybinds.txt](keybinds.txt).
2. Run `python3 generate.py`.
3. Review the diff in [out/](out/).
4. Reload your editor (it picks up `keybindings.json` live, no restart
   needed).

When you add a new chord that already has lots of defaults (like
`cmd+enter`, `cmd+k`, `cmd+p`), glance over the generated unbind block
for that chord to confirm you haven't nuked a context you care about.
If you did, either (a) narrow your bind's `when` clause so it doesn't
conflict, or (b) add an explicit targeted `-command` for just the
default you want to kill.
