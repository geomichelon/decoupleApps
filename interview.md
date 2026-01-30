# Interview — Modularization at Scale (DecoupledApps-iOS)

## Tough questions + short answers

1) **How do you prevent “shared hell” when defining common contracts?**
- Minimal, stable contracts with a named owner
- No business logic or UI inside shared modules
- Growth budget and mandatory review

2) **How do you guarantee a module doesn’t depend on another via transitive imports?**
- Layer/BU dependency lint
- Audit indirect imports and per-module budgets
- Explicit dependencies in manifest/podspec

3) **What stops a new modular monolith from forming?**
- BU boundaries and anti-cycle rules
- Composition Root as the only multi‑BU integration point
- Graph growth metrics and alerts

4) **Why contracts + DI instead of direct calls?**
- Explicit, testable, swappable coupling
- Enables independent targets and gradual extraction
- Reduces cross regressions

5) **How do you resolve cycles without hacks?**
- Invert dependencies via Domain ports
- Events and async contracts
- Orchestration moved to Composition Root

6) **When do you choose CocoaPods vs SPM?**
- CocoaPods: granular control, isolated bundles, strong legacy
- SPM: native integration, less infra, simpler DX
- Decision driven by scale, tooling, and standards

7) **How do you prove build improvement reliably?**
- Fixed scenarios and median of multiple runs
- Controlled environment with raw logs
- Before/after comparison per scenario

8) **What had the biggest impact on build time?**
- Reducing transitive dependencies
- Isolating high‑churn modules
- Removing global scripts and oversized targets

9) **How do you keep APIs compatible while modules evolve in parallel?**
- Lightweight contract versioning (v1/v2)
- Backward compatibility and deprecation policy
- CI with contract tests

10) **How do you decide extraction order?**
- Infra + contracts first, then Domain and Feature
- Prioritize stable, high‑impact BUs
- Reassess with risk and dependency metrics

11) **How do you avoid hidden dependencies in navigation?**
- Routing via protocols in `SharedContracts`
- Implementations injected by Composition Root
- No direct imports between Features

12) **What is the biggest trade‑off?**
- Agility and autonomy vs. governance cost
- Higher discipline in contracts and reviews
- Higher initial complexity, ongoing gains
