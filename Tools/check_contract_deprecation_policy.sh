#!/usr/bin/env bash
set -euo pipefail

# Contract deprecation policy enforcement (PR-only):
# - If contracts changed, require updates in Docs/02 or contracts changelog/deprecations or ADR.
# - If breaking/removal detected, require DEPRECATIONS entry with Owner/Deadline/Replacement.

if [[ "${GITHUB_EVENT_NAME:-}" != "pull_request" ]]; then
  echo "Skipping contract deprecation policy check (not pull_request)."
  exit 0
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Ensure base branch is available
if ! git show-ref --verify --quiet refs/remotes/origin/main; then
  git fetch origin main
fi

CHANGED_FILES=$(git diff --name-only origin/main...HEAD)

# Contract paths (best-effort)
CONTRACT_PATHS_REGEX='^(Modules/(Contracts|SharedContracts)|Modules/Sources/SharedContracts|Modules/Sources/Contracts)/'

contracts_changed=false
breaking_change=false
removal_detected=false

while IFS= read -r file; do
  if [[ "$file" =~ $CONTRACT_PATHS_REGEX ]]; then
    contracts_changed=true
  fi

done <<< "$CHANGED_FILES"

if [[ "$contracts_changed" == "false" ]]; then
  echo "No contract changes detected."
  exit 0
fi

# Detect removals and heuristic breaking changes
DIFF_OUTPUT=$(git diff origin/main...HEAD -- Modules/Sources/SharedContracts Modules/Contracts Modules/Sources/Contracts 2>/dev/null || true)

if echo "$DIFF_OUTPUT" | grep -qE '^deleted file mode'; then
  removal_detected=true
fi

if echo "$DIFF_OUTPUT" | grep -qE '^[-][[:space:]]*public (protocol|struct|enum|class)'; then
  breaking_change=true
fi

# Require doc changes for contract changes
DOC_OK=false
for doc in \
  "Docs/02-Module-API-Contracts.md" \
  "Docs/contracts/CHANGELOG.md" \
  "Docs/contracts/DEPRECATIONS.md" \
  "Docs/decisions"; do
  if echo "$CHANGED_FILES" | grep -q "$doc"; then
    DOC_OK=true
  fi
done

if [[ "$DOC_OK" == "false" ]]; then
  echo "Contract changes detected but required docs were not updated." >&2
  echo "Update at least one of:" >&2
  echo "- Docs/02-Module-API-Contracts.md" >&2
  echo "- Docs/contracts/CHANGELOG.md" >&2
  echo "- Docs/contracts/DEPRECATIONS.md" >&2
  echo "- Docs/decisions/ADR-*.md" >&2
  exit 1
fi

# If breaking/removal, enforce DEPRECATIONS update with Owner/Deadline/Replacement
if [[ "$breaking_change" == "true" || "$removal_detected" == "true" ]]; then
  if ! echo "$CHANGED_FILES" | grep -q "Docs/contracts/DEPRECATIONS.md"; then
    echo "Breaking/removal detected: update Docs/contracts/DEPRECATIONS.md" >&2
    exit 1
  fi
  if ! git diff origin/main...HEAD -- Docs/contracts/DEPRECATIONS.md | grep -q "Owner:"; then
    echo "DEPRECATIONS.md must include 'Owner:'" >&2
    exit 1
  fi
  if ! git diff origin/main...HEAD -- Docs/contracts/DEPRECATIONS.md | grep -q "Deadline:"; then
    echo "DEPRECATIONS.md must include 'Deadline:'" >&2
    exit 1
  fi
  if ! git diff origin/main...HEAD -- Docs/contracts/DEPRECATIONS.md | grep -q "Replacement:"; then
    echo "DEPRECATIONS.md must include 'Replacement:'" >&2
    exit 1
  fi
fi

echo "Contract deprecation policy: OK"
