#!/usr/bin/env bash
set -euo pipefail

# Import boundary rules (best-effort):
# - *Feature must not import any other *Feature.
# - *Domain must not import SwiftUI or UIKit.
# - Core* and *Contracts must not import *Feature.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCES_DIR="$ROOT_DIR/Modules/Sources"
APPS_DIR="$ROOT_DIR/Apps"

SOURCES_DIR="$SOURCES_DIR" APPS_DIR="$APPS_DIR" python3 - <<'PY'
import os
import re
import sys
from pathlib import Path

sources_dir = Path(os.environ["SOURCES_DIR"])
apps_dir = Path(os.environ["APPS_DIR"])

errors = []

def is_feature(name: str) -> bool:
    return name.endswith("Feature")

def is_domain(name: str) -> bool:
    return name.endswith("Domain")

def is_core(name: str) -> bool:
    return name.startswith("Core") or name == "Core"

def is_contracts(name: str) -> bool:
    return name.endswith("Contracts") or name == "SharedContracts"

# Scan Modules/Sources/<ModuleName>
for path in sources_dir.rglob("*.swift"):
    parts = path.relative_to(sources_dir).parts
    if not parts:
        continue
    module_name = parts[0]

    content = path.read_text(encoding="utf-8")
    for line in content.splitlines():
        line = line.strip()
        if not line.startswith("import "):
            continue
        imported = line.replace("import ", "").split()[0]

        # Feature must not import another Feature
        if is_feature(module_name) and is_feature(imported) and imported != module_name:
            errors.append(f"Import violation: {module_name} imports {imported} in {path}")

        # Domain must not import SwiftUI/UIKit
        if is_domain(module_name) and imported in {"SwiftUI", "UIKit"}:
            errors.append(f"Import violation: {module_name} imports {imported} in {path}")

        # Core/Contracts must not import Feature
        if (is_core(module_name) or is_contracts(module_name)) and is_feature(imported):
            errors.append(f"Import violation: {module_name} imports {imported} in {path}")

# Best-effort scan Apps/ for Feature-to-Feature imports (should not exist in Apps)
for path in apps_dir.rglob("*.swift"):
    content = path.read_text(encoding="utf-8")
    imported = [
        line.replace("import ", "").split()[0]
        for line in content.splitlines()
        if line.strip().startswith("import ")
    ]
    # no rule enforcement here; placeholder for future app-level rules

if errors:
    print("Import boundary violations:")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)

print("Import boundaries: OK")
PY
