#!/usr/bin/env bash
set -euo pipefail

# Rules enforced (SPM target dependencies + source scan for Domain):
# 1) *Feature cannot depend on *Feature.
# 2) *Domain must not import SwiftUI or UIKit.
# 3) Core* and *Contracts cannot depend on *Feature.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/Modules"
SOURCES_DIR="$ROOT_DIR/Modules/Sources"

if ! command -v swift >/dev/null 2>&1; then
  echo "swift not found. Install Xcode or Swift toolchain." >&2
  exit 1
fi

DUMP_JSON="$(swift package --package-path "$PACKAGE_DIR" dump-package)"

SOURCES_DIR="$SOURCES_DIR" DUMP_JSON="$DUMP_JSON" python3 - <<'PY'
import json
import os
import sys
from pathlib import Path

data = json.loads(os.environ["DUMP_JSON"])
sources_dir = Path(os.environ["SOURCES_DIR"])

targets = data.get("targets", [])
all_targets = {t["name"] for t in targets}

def is_feature(name: str) -> bool:
    return name.endswith("Feature")

def is_domain(name: str) -> bool:
    return name.endswith("Domain")

def is_core(name: str) -> bool:
    return name.startswith("Core") or name == "Core"

def is_contracts(name: str) -> bool:
    return name.endswith("Contracts") or name == "SharedContracts"

def dep_name(dep) -> str | None:
    if isinstance(dep, dict):
        if "name" in dep:
            return dep.get("name")
        if "byName" in dep and isinstance(dep.get("byName"), list):
            return dep["byName"][0]
    return None

errors = []

for t in targets:
    src = t["name"]
    deps = []
    for dep in t.get("dependencies", []):
        name = dep_name(dep)
        if name:
            deps.append(name)
    for dep in deps:
        if dep not in all_targets:
            continue
        if is_feature(src) and is_feature(dep):
            errors.append(f"Rule violation: {src} (Feature) depends on {dep} (Feature)")
        if (is_core(src) or is_contracts(src)) and is_feature(dep):
            errors.append(f"Rule violation: {src} (Core/Contracts) depends on {dep} (Feature)")

# Domain source scan for SwiftUI/UIKit imports
for t in targets:
    name = t["name"]
    if not is_domain(name):
        continue
    module_dir = sources_dir / name
    if not module_dir.exists():
        continue
    for path in module_dir.rglob("*.swift"):
        content = path.read_text(encoding="utf-8")
        for line in content.splitlines():
            line = line.strip()
            if line.startswith("import SwiftUI") or line.startswith("import UIKit"):
                errors.append(f"Rule violation: {name} (Domain) imports UI framework in {path}")

if errors:
    print("Dependency rules violations:")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)

print("Dependency rules: OK")
PY
