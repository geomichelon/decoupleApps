# 03 — Build Performance

> Outline for metrics, methodology, and result presentation.

## Goal
- Prove build improvement and workflow efficiency
- Compare baseline (before) vs modular (after)

## Methodology
- Controlled environment (same Xcode and macOS)
- 5–10 runs per scenario, use median
- Scenarios: clean build, incremental, link time, scripts
- Raw logs + results sheet

## Metrics
- Clean build (s)
- Incremental per module (s)
- Incremental for contract change (s)
- Link time (s)
- Script phases total (s)
- Cache hit (CI) (%)
- Flaky failures (CI)
- Feedback time (s)

## How to collect
- Standardize scheme and target
- Run at the same time/environment
- Save logs and build screenshots

## Results presentation
- README: 2–3 metrics with % improvement
- Docs: full tables + screenshots + logs
- Separate scenarios (clean, incremental, link, scripts)

## Arm traps
- Giant shared modules
- Too many dynamic frameworks
- Global scripts on every target
- Over-splitting without real gains

## References
- `04-Migration-Plan.md`
