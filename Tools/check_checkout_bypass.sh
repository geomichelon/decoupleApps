#!/usr/bin/env bash
set -euo pipefail

# Checkout bypass check (best-effort)
# Fails if:
# - Apps/ directly instantiate CheckoutFeatureView without either CheckoutEntryPoint or CheckoutFeatureFactory present in the same file.
# - Apps/ instantiate CheckoutFeatureView without any auth gating marker (authStore.current or SignInRequired).
# - Apps/ reference SampleCheckout.context (bypass path).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$ROOT_DIR/Apps"

errors=0

while IFS= read -r -d '' file; do
  if grep -q "CheckoutFeatureView(" "$file"; then
    if ! grep -Eq "CheckoutEntryPoint|CheckoutFeatureFactory" "$file"; then
      echo "Bypass violation: $file instantiates CheckoutFeatureView without EntryPoint/Factory"
      errors=1
    fi
    if ! grep -Eq "authStore\.current|SignInRequired" "$file"; then
      echo "Gating violation: $file uses CheckoutFeatureView without auth gating markers"
      errors=1
    fi
  fi

  if grep -q "SampleCheckout\.context" "$file"; then
    echo "Bypass violation: $file references SampleCheckout.context"
    errors=1
  fi

done < <(find "$APPS_DIR" -name "*.swift" -print0)

if [[ $errors -ne 0 ]]; then
  exit 1
fi

echo "Checkout bypass check: OK"
