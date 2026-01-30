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

## Tooling
Scripts live in `Tools/`:
- `benchmark_build.sh` — captures build/test timings into `Tools/results/`.
- `run_tests.sh` — runs SPM tests (and optional Xcode tests).

Run locally:
- `bash Tools/benchmark_build.sh`
- `bash Tools/run_tests.sh`

Environment overrides:
- `SCHEME=SuperApp DESTINATION='platform=iOS Simulator,name=iPhone 15' bash Tools/benchmark_build.sh`
- `RUN_XCODEBUILD=1 SCHEME=SuperApp DESTINATION='platform=iOS Simulator,name=iPhone 15' bash Tools/run_tests.sh`

Results:
- Files are stored under `Tools/results/` with timestamped names.
- Commit results only if you intend to share benchmarks.

## Arm traps
- Giant shared modules
- Too many dynamic frameworks
- Global scripts on every target
- Over-splitting without real gains

## References
- `04-Migration-Plan.md`
