#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT_DIR/Tools/results"
PROJECT="$ROOT_DIR/DecoupledApps-iOS.xcodeproj"
SCHEME="${SCHEME:-SuperApp}"
DESTINATION="${DESTINATION:-generic/platform=iOS Simulator}"

# Auto-detect a scheme if the default is not available
if ! xcodebuild -list -project "$PROJECT" | grep -q " $SCHEME"; then
  DETECTED_SCHEME=$(xcodebuild -list -project "$PROJECT" | awk '/Schemes:/{flag=1;next} /^$/{flag=0} flag{print $1; exit}')
  if [[ -n "${DETECTED_SCHEME:-}" ]]; then
    echo "Scheme '$SCHEME' not found. Using '$DETECTED_SCHEME' instead."
    SCHEME="$DETECTED_SCHEME"
  fi
fi

TS="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="$RESULTS_DIR/$TS"
mkdir -p "$OUT_DIR"

LOG_FILE="$OUT_DIR/${SCHEME}-build.log"

{
  echo "Benchmark timestamp: $TS"
  echo "Scheme: $SCHEME"
  echo "Destination: $DESTINATION"
  echo ""
  /usr/bin/time -p xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    CODE_SIGNING_ALLOWED=NO \
    clean build
} | tee "$LOG_FILE"

echo "Saved: $LOG_FILE"
