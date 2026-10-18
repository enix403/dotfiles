# Global Claude Rules

## GitHub Tasks

For any GitHub-related task, prefer the GitHub CLI (`gh`) by default.

## JSON manipulation

If you want to do any parsing/manipulation of JSON, use the `jq` cli tool. Avoid using one liner python scripts like `python -c '....'` for such tasks.

## Commit, push and CI

- On my feature branches, commit and push every change without asking, then watch the PR's CI in the background and report failures. Use Conventional Commits.
- Stage explicit file paths. `git add -A` is blocked by dcg.
- Still ask before: pushing to the default branch, force-pushing, opening or merging a PR, or posting to external services (issue trackers, chat).
- After each push to an open PR, update the PR description (`gh pr edit --body-file`) so it matches the code.

## PR scope

- Size the PR to the ask. Don't add flags, config plumbing, extra metrics or refactors that weren't requested, even ones discussed during design. Discussing a mechanism is not approval to build it.
- Do fix regressions the change itself introduces.
- Keep hardcoded values hardcoded (a named constant is fine). Prefer editing the existing function in place over extracting new files.
- List adjacent improvements under a "Follow-ups" heading in the PR body instead of shipping them.
- On fix PRs, never add or change a gRPC/HTTP response status code. Preserve the existing status and fields of a failure path. Raise the risk as a finding instead.

## PR descriptions

- Technical only. Don't motivate or justify the feature; reviewers already know why it exists. State the ticket, the inputs/systems it builds on, and how it works.

## Observability

- Never reword existing log message strings. Dashboards and alerts match on the literal text. Adding a new log line for a new branch is fine.
- Keep span and metric tags low-cardinality (counts, enums, event types). Error text and other free-form strings go in structured logs, never tags, even truncated.

## Code style

- Ruby: use `["a", "b"]`, never `%w[a b]`.
- JS/TS: use plain objects for string-keyed data; reach for `Map` only with a concrete reason.
- Bun scripts: use `` $`...` `` only for external commands. Do logic, parsing, file I/O and exits in JS (`Bun.file`, `Bun.argv`, `Bun.env`, `process.exit`).

## Shell gotchas

- In my shell, `mv`, `cp` (and possibly `rm`) are aliased to their `-i` variants, which hang non-interactive commands on an invisible prompt. Use `command mv -f`, `/bin/cp -f`, `command rm -f`, or the Edit/Write tools.
- If a command is interrupted, check on-disk state (`git status`) before saying what did or didn't run.
- dcg blocks any command containing `git push` alongside a `-f` flag, including `gh api ... -f`. Keep `git push` in its own Bash call and use `--raw-field`/`--field` with `gh api`.

## Claude config layout

My `~/.claude` is assembled by `claude-layers` (in my dotfiles `shared/bin`): `~/.claude/settings.json` and `~/.claude/CLAUDE.md` are generated, and `~/.claude/skills/*` are symlinks. Never edit those directly. Edit the layer sources instead: the public base in `~/dotfiles/shared/claude/`, or the private layers listed in `~/.claude/layers`. Then run `claude-layers`. Anything org- or employer-specific must never go in the dotfiles layer.
