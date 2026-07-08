#!/usr/bin/env bash
# scan-local-skills.sh — Scan locally installed skills.
# Usage: bash scan-local-skills.sh [--json | --table]

set -euo pipefail

FORMAT="${1:---table}"

SKILL_ROOTS=(
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
  "$HOME/.codex/skills/.system"
)

TMPFILE=$(mktemp)

for ROOT in "${SKILL_ROOTS[@]}"; do
  [ ! -d "$ROOT" ] && continue
  while IFS= read -r -d '' SKILL_MD; do
    SKILL_DIR=$(dirname "$SKILL_MD")
    NAME=$(awk '/^name:/ {sub(/^name:[[:space:]]*/, ""); gsub(/"/, ""); print; exit}' "$SKILL_MD" 2>/dev/null || echo "")
    DESC=$(awk '/^description:/ {sub(/^description:[[:space:]]*/, ""); gsub(/"/, ""); print; exit}' "$SKILL_MD" 2>/dev/null || echo "")
    [ -z "$NAME" ] && continue
    printf '%s\t%s\t%s\n' "$NAME" "$DESC" "$SKILL_DIR" >> "$TMPFILE"
  done < <(find "$ROOT" -name "SKILL.md" -not -path "*/node_modules/*" -maxdepth 4 -print0 2>/dev/null)
done

if [ "$FORMAT" = "--json" ]; then
  echo "["
  FIRST=true
  while IFS=$'\t' read -r NAME DESC PATH; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo ","; fi
    printf '  {"name":"%s","description":"%s","path":"%s"}' \
      "$(echo "$NAME" | sed 's/\\/\\\\/g; s/"/\\"/g')" \
      "$(echo "$DESC" | sed 's/\\/\\\\/g; s/"/\\"/g')" \
      "$(echo "$PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  done < "$TMPFILE"
  echo ""
  echo "]"
else
  COUNT=$(wc -l < "$TMPFILE" | tr -d ' ')
  echo "Installed Skills ($COUNT):"
  echo "========================"
  echo ""
  sort -t$'\t' -k1,1 "$TMPFILE" | while IFS=$'\t' read -r NAME DESC PATH; do
    printf "  %-35s %s\n" "$NAME" "$DESC"
    printf "  %-35s %s\n" "" "  → $PATH"
    echo ""
  done
fi

rm -f "$TMPFILE"
