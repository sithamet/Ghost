#!/usr/bin/env bash
# Clone the mevkh-theme into Ghost's content/themes directory as a plain git repo.
#
# mevkh-theme is NOT a git submodule because Ghost's pre-commit hook strips
# submodule changes from commits. Instead we use a plain clone that lives in a
# gitignored path, matching how production (VPS) deploys the theme.
#
# Run this after `pnpm run setup` on a fresh clone of the Ghost fork.
#
# Idempotent: if the theme is already present, pulls the latest main.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GHOST_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
THEME_PATH="$GHOST_ROOT/ghost/core/content/themes/mevkh-theme"
THEME_REPO="https://github.com/sithamet/mevkh-theme.git"

if [ -d "$THEME_PATH/.git" ]; then
    echo "mevkh-theme already present, pulling latest..."
    cd "$THEME_PATH"
    git fetch origin main
    git reset --hard origin/main
    echo "✓ mevkh-theme updated to $(git log --oneline -1)"
else
    echo "Cloning mevkh-theme into $THEME_PATH..."
    git clone "$THEME_REPO" "$THEME_PATH"
    echo "✓ mevkh-theme cloned"
fi

echo
echo "Next: restart pnpm dev and activate mevkh-theme via Ghost Admin → Design."
