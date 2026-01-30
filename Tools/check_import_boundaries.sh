#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="$ROOT_DIR/Tools/dependency-rules.yml"
PACKAGE_DIR="$ROOT_DIR/Modules"
SOURCES_DIR="$ROOT_DIR/Modules/Sources"

DUMP_JSON="$(swift package --package-path "$PACKAGE_DIR" dump-package)"

RULES_FILE="$RULES_FILE" DUMP_JSON="$DUMP_JSON" SOURCES_DIR="$SOURCES_DIR" python3 - <<'PY'
import json
import os
import re
import sys
from pathlib import Path

rules = json.loads(open(os.environ["RULES_FILE"], "r", encoding="utf-8").read())
patterns = rules.get("groups", {})
overrides = rules.get("overrides", {})
allow = rules.get("allow", {})

ordered_groups = list(patterns.items())

def group_for(name: str) -> str:
    if name in overrides:
        return overrides[name]
    for group, pattern in ordered_groups:
        if re.match(pattern, name):
            return group
    return "Unknown"

package = json.loads(os.environ["DUMP_JSON"])

targets = package.get("targets", [])
all_targets = {t["name"] for t in targets}

sources_dir = Path(os.environ["SOURCES_DIR"])

errors = []

for path in sources_dir.rglob("*.swift"):
    parts = path.relative_to(sources_dir).parts
    if not parts:
        continue
    module_name = parts[0]
    if module_name not in all_targets:
        continue
    src_group = group_for(module_name)
    if src_group not in allow:
        errors.append(f"Unknown group for module {module_name}")
        continue

    content = path.read_text(encoding="utf-8")
    for line in content.splitlines():
        line = line.strip()
        if not line.startswith("import "):
            continue
        imported = line.replace("import ", "").split()[0]
        if imported == module_name:
            continue
        if imported not in all_targets:
            continue
        dep_group = group_for(imported)
        if dep_group == "Unknown":
            errors.append(f"Unknown dependency group: {module_name} imports {imported}")
            continue
        if dep_group not in allow[src_group]:
            errors.append(
                f"Import violation: {module_name} ({src_group}) imports {imported} ({dep_group}) in {path}"
            )

if errors:
    print("Import boundary violations:")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)

print("Import boundaries: OK")
PY
