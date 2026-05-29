# claude-harness-seed

The `~/.claude/` skeleton that the first-boot wizard's `claude_seed` step rsyncs onto every Farm Hack Box. Identical content on every box.

## Layout

```
dot-claude/
  settings.json         # harness defaults only; per-box overrides go in settings.local.json
  skills/               # future user-defined skills
  agents/               # future user-defined agent definitions
  hooks/
    SessionStart.sh     # prints ancestor index + translation note
  CLAUDE.md.template    # envsubst'd at seed time into ~/.claude/projects/-home-<user>/memory/CLAUDE.md
```

## What this repo deliberately does NOT ship

The CI deny-list (`deny-list.txt` + `scripts/check-deny-list.sh`) rejects any commit that adds files matching:

- `settings.local.json` — per-box mutable overrides; never committed
- `history.jsonl`, `sessions/`, `shell-snapshots/`, `paste-cache/`, `cache/`, `file-history/`, `telemetry/`, `session-env/`
- `mcp-needs-auth-cache.json`, `scheduled_tasks.lock`
- `keybindings.json` — user-personal, not box-personal
- Anything matching `*credential*`, `*token*`, `*.key`, `*-sign.pem`, `.credentials.json`

## Bootstrap flow

`/usr/local/sbin/farmhack-claude-seed` (defined in B1 of the workflow-archive plan):

1. `git clone <forgejo>/farmhack-boxes/claude-harness-seed.git ~/.claude-seed`
2. `rsync -a --chmod=u=rX ~/.claude-seed/dot-claude/ ~/.claude/`
3. `envsubst < ~/.claude-seed/dot-claude/CLAUDE.md.template > ~/.claude/projects/-home-<user>/memory/CLAUDE.md`

The hook + template are idempotent across re-runs.

## Plan

The design rationale and rollout plan for this seed live in the box operator's
private planning notes (not mirrored). Open an issue if you'd like context on a
specific convention.
