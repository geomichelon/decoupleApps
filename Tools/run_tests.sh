#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

swift test --package-path "$ROOT_DIR/Modules"

if [[ "${RUN_XCODEBUILD:-0}" == "1" ]]; then
  xcodebuild -project "$ROOT_DIR/DecoupledApps-iOS.xcodeproj" -scheme "${SCHEME:-SuperApp}" -destination "${DESTINATION:-platform=iOS Simulator,name=iPhone 15}" test
fi
