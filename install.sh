#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
ADAPTERS_DIR="$SCRIPT_DIR/adapters"

usage() {
  echo "Usage: $0 <model> [target-project-root]"
  echo ""
  echo "Models: claude, codex, antigravity, all"
  echo ""
  echo "Examples:"
  echo "  $0 claude              # Install to current directory"
  echo "  $0 codex /path/to/proj # Install to specific project"
  echo "  $0 all                 # Install for all models"
  exit 1
}

install_for_model() {
  local model="$1"
  local project_root="$2"
  local adapter="$ADAPTERS_DIR/$model.json"

  if [ ! -f "$adapter" ]; then
    echo "Error: Unknown model '$model'. Available: claude, codex, antigravity"
    exit 1
  fi

  local skills_dir
  skills_dir=$(python3 -c "import json; print(json.load(open('$adapter'))['skills_dir'])" 2>/dev/null \
    || node -e "console.log(require('$adapter').skills_dir)" 2>/dev/null \
    || grep -o '"skills_dir"[[:space:]]*:[[:space:]]*"[^"]*"' "$adapter" | sed 's/.*"\([^"]*\)"$/\1/')

  local target="$project_root/$skills_dir"
  echo "Installing AI Radija Tools for $model -> $target"

  for skill_dir in "$SKILLS_SRC"/ai-radija-*/; do
    local skill_name
    skill_name=$(basename "$skill_dir")
    mkdir -p "$target/$skill_name"
    cp "$skill_dir/SKILL.md" "$target/$skill_name/SKILL.md"
  done

  local count
  count=$(ls -d "$SKILLS_SRC"/ai-radija-*/ 2>/dev/null | wc -l)
  echo "  Installed $count skills."
}

[ $# -lt 1 ] && usage

MODEL="$1"
PROJECT_ROOT="${2:-.}"

if [ "$MODEL" = "all" ]; then
  for adapter in "$ADAPTERS_DIR"/*.json; do
    m=$(basename "$adapter" .json)
    install_for_model "$m" "$PROJECT_ROOT"
  done
else
  install_for_model "$MODEL" "$PROJECT_ROOT"
fi

echo "Done."
