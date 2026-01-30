#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -d "$HOME/.tuist/bin" ]; then
  export PATH="$HOME/.tuist/bin:$PATH"
fi

if ! command -v tuist >/dev/null 2>&1; then
  echo "Tuist not found. Installing..."
  if command -v brew >/dev/null 2>&1; then
    if ! brew list --cask tuist >/dev/null 2>&1; then
      brew install --cask tuist || {
        brew tap tuist/tuist
        brew install tuist
      }
    fi
  else
    echo "Homebrew not found. Install Tuist manually with Homebrew:" >&2
    echo "  brew install --cask tuist" >&2
    exit 1
  fi
fi

if [ -n "${GITHUB_PATH:-}" ]; then
  echo "$HOME/.tuist/bin" >> "$GITHUB_PATH"
fi

echo "Tuist version: $(tuist version)"

if [ -f "Tuist/Dependencies.swift" ]; then
  tuist install
fi
