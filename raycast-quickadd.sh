#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Capture Idea (macOS)
# @raycast.mode silent
# @raycast.packageName Obsidian
# @raycast.icon https://obsidian.md/images/obsidian-logo-gradient.svg
# @raycast.description Capture an idea into Obsidian through QuickAdd on macOS.
#
# Optional arguments:
# @raycast.argument1 { "type": "text", "placeholder": "Idea text" }

set -euo pipefail

IDEA_TEXT="${1-}"
VAULT_NAME="Forge"
CHOICE_NAME="Capture Idea"

if [[ -z "${IDEA_TEXT// }" ]]; then
  echo "Idea text is required" >&2
  exit 1
fi

if command -v obsidian >/dev/null 2>&1; then
  OUTPUT="$(obsidian "vault=$VAULT_NAME" quickadd "choice=$CHOICE_NAME" "value-idea=$IDEA_TEXT" 2>&1)" || {
    printf '%s\n' "$OUTPUT" >&2
    exit 1
  }

  printf 'Idea Captured\n'
  exit 0
fi

python3 - "$VAULT_NAME" "$CHOICE_NAME" "$IDEA_TEXT" <<'PY'
import sys
import urllib.parse
import subprocess

vault, choice, idea = sys.argv[1:4]
uri = (
    "obsidian://quickadd"
    f"?vault={urllib.parse.quote(vault)}"
    f"&choice={urllib.parse.quote(choice)}"
    f"&value-idea={urllib.parse.quote(idea)}"
)
subprocess.run(["open", uri], check=True)
PY

printf 'Idea Captured\n'