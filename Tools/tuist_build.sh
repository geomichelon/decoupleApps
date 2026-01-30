#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -d "$HOME/.tuist/bin" ]; then
  export PATH="$HOME/.tuist/bin:$PATH"
fi

WORKSPACE="${WORKSPACE:-DecoupledApps-iOS-Tuist.xcworkspace}"
SCHEME="${SCHEME:-SuperApp}"
DESTINATION="${DESTINATION:-generic/platform=iOS Simulator}"

if [ ! -d "$WORKSPACE" ]; then
  echo "Workspace '$WORKSPACE' not found. Run Tools/tuist_generate.sh first." >&2
  exit 1
fi

xcodebuild \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  CODE_SIGNING_ALLOWED=NO \
  build
