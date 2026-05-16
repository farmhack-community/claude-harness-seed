#!/usr/bin/env bash
# CI lint: refuse to ship if any tracked file matches a pattern in deny-list.txt.
# Pure-substring match against the file path; one pattern per line.

set -eu

DENY="$(dirname "$0")/../deny-list.txt"
FAIL=0

while IFS= read -r pattern; do
  case "$pattern" in
    ''|'#'*) continue ;;
  esac
  while IFS= read -r path; do
    case "$path" in
      *"$pattern"*)
        echo "DENY ${path}  (matches '${pattern}')" >&2
        FAIL=1
        ;;
    esac
  done < <(git ls-files)
done < "$DENY"

if [ "$FAIL" -ne 0 ]; then
  echo "" >&2
  echo "Deny-list check FAILED. Remove the listed files or update deny-list.txt with a rationale." >&2
  exit 1
fi

echo "Deny-list check passed."
