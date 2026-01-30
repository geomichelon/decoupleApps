#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/Modules"
OUTPUT_DIR="$ROOT_DIR/Docs/diagrams"
OUTPUT_FILE="$OUTPUT_DIR/dependency-graph.mmd"

mkdir -p "$OUTPUT_DIR"

DUMP_JSON="$(swift package --package-path "$PACKAGE_DIR" dump-package)"

DUMP_JSON="$DUMP_JSON" OUTPUT_FILE="$OUTPUT_FILE" python3 - <<'PY'
import json
import os

package = json.loads(os.environ["DUMP_JSON"])

targets = package.get("targets", [])
all_targets = {t["name"] for t in targets}


def dep_name(dep) -> str | None:
    if isinstance(dep, dict):
        if "name" in dep:
            return dep.get("name")
        if "byName" in dep and isinstance(dep.get("byName"), list):
            return dep["byName"][0]
    return None

edges = []
for t in targets:
    src = t["name"]
    for dep in t.get("dependencies", []):
        name = dep_name(dep)
        if name and name in all_targets:
            edges.append((src, name))

lines = ["graph TD"]
for name in sorted(all_targets):
    lines.append(f"  {name}")

for src, dst in edges:
    lines.append(f"  {src} --> {dst}")

out_path = os.environ["OUTPUT_FILE"]
with open(out_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Wrote {out_path}")
PY
