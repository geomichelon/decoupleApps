#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/Modules"
OUTPUT_DIR="$ROOT_DIR/Docs/diagrams"
OUTPUT_FILE="$OUTPUT_DIR/dependency-graph.mmd"
RULES_FILE="$ROOT_DIR/Tools/dependency-rules.yml"

mkdir -p "$OUTPUT_DIR"

DUMP_JSON="$(swift package --package-path "$PACKAGE_DIR" dump-package)"

RULES_FILE="$RULES_FILE" DUMP_JSON="$DUMP_JSON" OUTPUT_FILE="$OUTPUT_FILE" python3 - <<'PY'
import json
import os
import re

rules = json.loads(open(os.environ["RULES_FILE"], "r", encoding="utf-8").read())
patterns = rules.get("groups", {})
overrides = rules.get("overrides", {})

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

edges = []
by_group = {}
for t in targets:
    name = t["name"]
    group = group_for(name)
    by_group.setdefault(group, []).append(name)
    for dep in t.get("dependencies", []):
        if dep.get("type") == "target" and dep.get("name") in all_targets:
            edges.append((name, dep.get("name")))

lines = ["graph TD"]
for group, names in by_group.items():
    lines.append(f"  subgraph {group}")
    for n in sorted(names):
        lines.append(f"    {n}")
    lines.append("  end")

for src, dst in edges:
    lines.append(f"  {src} --> {dst}")

out_path = os.environ["OUTPUT_FILE"]
with open(out_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Wrote {out_path}")
PY
