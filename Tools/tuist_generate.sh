#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -d "$HOME/.tuist/bin" ]; then
  export PATH="$HOME/.tuist/bin:$PATH"
fi

if ! command -v tuist >/dev/null 2>&1; then
  echo "Tuist not found. Run Tools/tuist_bootstrap.sh first." >&2
  exit 1
fi

tuist generate --no-open
