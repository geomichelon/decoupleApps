#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="$ROOT_DIR/Tools/dependency-rules.yml"
PACKAGE_DIR="$ROOT_DIR/Modules"

if ! command -v swift >/dev/null 2>&1; then
  echo "swift not found. Install Xcode or Swift toolchain." >&2
  exit 1
fi

DUMP_JSON="$(swift package --package-path "$PACKAGE_DIR" dump-package)"

RULES_FILE="$RULES_FILE" DUMP_JSON="$DUMP_JSON" python3 - <<'PY'
import json
import os
import re
import sys

rules_path = os.environ.get("RULES_FILE")
package_dump = os.environ.get("DUMP_JSON")

rules = json.loads(open(rules_path, "r", encoding="utf-8").read())
data = json.loads(package_dump)

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


targets = data.get("targets", [])
all_targets = {t["name"] for t in targets}

deps_map = {}
for t in targets:
    deps = []
    for dep in t.get("dependencies", []):
        if dep.get("type") == "target":
            deps.append(dep.get("name"))
    deps_map[t["name"]] = deps

errors = []

for src, deps in deps_map.items():
    src_group = group_for(src)
    if src_group not in allow:
        errors.append(f"Unknown group for target '{src}'")
        continue
    for dep in deps:
        if dep not in all_targets:
            continue
        dep_group = group_for(dep)
        if dep_group == "Unknown":
            errors.append(f"Unknown group for dependency '{dep}' (from {src})")
            continue
        if dep_group not in allow[src_group]:
            errors.append(f"Rule violation: {src} ({src_group}) -> {dep} ({dep_group})")

# Cycle detection
visited = {}
stack = []

def visit(node: str):
    state = visited.get(node, "unvisited")
    if state == "visiting":
        cycle = " -> ".join(stack + [node])
        errors.append(f"Cycle detected: {cycle}")
        return
    if state == "visited":
        return
    visited[node] = "visiting"
    stack.append(node)
    for dep in deps_map.get(node, []):
        if dep in all_targets:
            visit(dep)
    stack.pop()
    visited[node] = "visited"

for node in all_targets:
    if visited.get(node) != "visited":
        visit(node)

if errors:
    print("Dependency rule violations:")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)

print("Dependency rules: OK")
PY
