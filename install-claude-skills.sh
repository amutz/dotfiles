#!/usr/bin/env bash
# Link the Claude Code skills in claude/skills/ into ~/.claude/skills.
# Safe to re-run; kept separate from install.sh so lightweight environments
# (e.g. a Claude Code cloud setup script) can run it without the nvim install.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.claude/skills

for skill in "$DOTFILES_DIR"/claude/skills/*/; do
  name="$(basename "$skill")"
  target="$HOME/.claude/skills/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Skipping $name: $target exists and is not a symlink"
    continue
  fi
  ln -sfn "${skill%/}" "$target"
  echo "Linked skill: $name"
done
