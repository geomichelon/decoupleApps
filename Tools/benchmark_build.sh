#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT_DIR/Tools/results"
PROJECT="$ROOT_DIR/DecoupledApps-iOS.xcodeproj"
SCHEME="${SCHEME:-SuperApp}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 15}"

mkdir -p "$RESULTS_DIR"
TS="$(date +%Y%m%d-%H%M%S)"
OUT="$RESULTS_DIR/build-benchmark-$TS.txt"

{
  echo "Benchmark timestamp: $TS"
  echo "Scheme: $SCHEME"
  echo "Destination: $DESTINATION"
  echo ""
  echo "== xcodebuild (clean build) =="
  /usr/bin/time -p xcodebuild -project "$PROJECT" -scheme "$SCHEME" -destination "$DESTINATION" clean build
  echo ""
  echo "== swift test (Modules) =="
  /usr/bin/time -p swift test --package-path "$ROOT_DIR/Modules"
} | tee "$OUT"

echo "Saved: $OUT"
