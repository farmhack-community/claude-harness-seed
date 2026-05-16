#!/usr/bin/env bash
# Claude Code SessionStart hook.
# Prints inherited-memory counts + translation note when a new session opens.
# Quiet when there's no ancestor-memory dir (fresh box that never ran `farmhack replay sync`).

set -u

USER_NAME="$(id -un)"
ANCESTOR_DIR="${HOME}/.claude/projects/-home-${USER_NAME}/ancestor-memory"
TRANSLATION_MAP="/etc/farmhack/box-translation.yml"

[ -d "$ANCESTOR_DIR" ] || exit 0

count_memories=0
count_plans=0
boxes=()

for box_dir in "$ANCESTOR_DIR"/*/; do
  [ -d "$box_dir" ] || continue
  box_name="$(basename "$box_dir")"
  boxes+=("$box_name")

  if [ -d "$box_dir/memories" ]; then
    n=$(find "$box_dir/memories" -maxdepth 1 -name '*.md' | wc -l)
    count_memories=$((count_memories + n))
  fi
  if [ -d "$box_dir/plans" ]; then
    n=$(find "$box_dir/plans" -maxdepth 1 -name '*.md' | wc -l)
    count_plans=$((count_plans + n))
  fi
done

[ ${#boxes[@]} -eq 0 ] && exit 0

printf 'Inherited from %s: %d memories, %d plans (read-only under ancestor-memory/)\n' \
  "$(IFS=,; echo "${boxes[*]}")" "$count_memories" "$count_plans"

if [ -f "$TRANSLATION_MAP" ]; then
  printf 'Path/IP translations available at %s — substitute when following ancestor memories.\n' "$TRANSLATION_MAP"
fi
