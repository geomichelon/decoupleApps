#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$ROOT_DIR/Apps"

errors=0

while IFS= read -r -d '' file; do
  if grep -q "CheckoutFeatureView(" "$file"; then
    if ! grep -Eq "CheckoutEntryPoint|CheckoutFeatureFactory" "$file"; then
      echo "Bypass violation: $file instantiates CheckoutFeatureView without EntryPoint/Factory"
      errors=1
    fi
  fi
  # Also block direct instantiation when auth gating is missing (best effort)
  if grep -q "CheckoutFeatureView(" "$file" && ! grep -Eq "Sign in required|SignInRequired|authStore\\.current" "$file"; then
    echo "Gating warning: $file uses CheckoutFeatureView without auth gating markers"
    errors=1
  fi
  
  # Enforce no SampleCheckout.context usage in SuperApp
  if grep -q "SampleCheckout.context" "$file"; then
    echo "Bypass violation: $file references SampleCheckout.context"
    errors=1
  fi

  

done < <(find "$APPS_DIR" -name "*.swift" -print0)

if [[ $errors -ne 0 ]]; then
  exit 1
fi

echo "Checkout bypass check: OK"
