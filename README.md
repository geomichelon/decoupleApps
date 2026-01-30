# DecoupledApps-iOS — README Outline (complete)

Author: George Michelon

> Suggested README structure. Replace bullets with final content as the repo evolves.

## Table of Contents
1. Context and problem
2. Objective
3. Target architecture and principles
4. Dependency graph
5. Inter-module contracts
6. Navigation
7. Dependency strategy
8. Build performance
9. Incremental migration strategy
10. Tests and governance
11. Roadmap
12. Trade-offs FAQ
13. How to run

## 1. Context and problem (thousands of modules / agility)
- Super-app scenario: scope, team, and dependency growth
- Main pain: coupled complexity slows releases and onboarding
- Scale signals: thousands of modules, long builds, cross regressions
- Impact: high change cost, unclear ownership, rework

## 2. Objective (app extraction by business unit)
- Turn a super-app into independent apps by business unit
- Keep governance and consistency without blocking autonomy
- Prove extraction is incremental, safe, and measurable
- Demonstrate domain boundaries and stable contracts

## 3. Target architecture and principles (Clean Architecture + boundaries)
- Layers and responsibilities (entities, use cases, interface)
- Explicit boundaries between domains and infrastructure
- Dependency rule and flow direction
- Change isolation and contract stability
- Modularization and decoupling principles

### Business units (BUs)
- Catalog, Checkout, and Profile as main domains
- Each BU with Feature, Domain, and public contracts
- UI/DesignSystem is cross-cutting; Infra is technical implementations
- Composition Root assembles BU apps and SuperApp

### Module list by category
**Feature**
- Feature/CatalogFeature
- Feature/CheckoutFeature
- Feature/ProfileFeature

**Domain**
- Domain/CatalogDomain
- Domain/CheckoutDomain
- Domain/ProfileDomain
- Domain/SharedContracts

**Infra**
- Infra/Network
- Infra/Persistence
- Infra/Analytics
- Infra/Payments
- Infra/Auth

**UI/DesignSystem**
- UI/DesignSystem
- UI/SharedComponents

**Composition Root**
- App/SuperApp
- App/CatalogApp
- App/CheckoutApp
- App/ProfileApp
- App/CompositionKits

## 4. Dependency graph (overview)
- High-level view of the dependency graph
- Core vs domain vs infrastructure modules
- Allowed flow and forbidden dependencies
- How the graph is generated/validated

### Allowed dependencies matrix + anti-cycle rules
- Feature → Domain, UI/DesignSystem, SharedContracts, Infra (via abstractions)
- Domain → SharedContracts (optional)
- Infra → Domain (only to implement ports)
- UI/DesignSystem → (no dependencies upward)
- Composition Root → all layers

**Anti-cycle**
- No Feature depends on another BU Feature
- Domain does not depend on another BU Domain (only SharedContracts)
- Infra never depends on Feature
- Composition Root is the only place aware of multiple BUs
- Cycles are blocked by lint (A→B→C→A)

### Text graph (layers + main dependencies)
- Composition Root → Features (Catalog/Checkout/Profile) + UI + Infra
- Feature/* → Domain/* + UI + SharedContracts
- Infra/* → Domain/* (ports)
- Domain/* → SharedContracts
- UI/DesignSystem → (no dependencies above)

### BU targets (app extraction)
**SuperApp**
- Includes: CatalogFeature, CheckoutFeature, ProfileFeature + Domains + Infra + UI
- Goal: full compatibility during migration

**CatalogApp**
- Includes: CatalogFeature + CatalogDomain + SharedContracts + UI + base Infra
- Goal: validate isolated catalog extraction

**CheckoutApp**
- Includes: CheckoutFeature + CheckoutDomain + SharedContracts + UI + payments Infra
- Goal: isolate critical purchase flow

**ProfileApp**
- Includes: ProfileFeature + ProfileDomain + SharedContracts + UI + auth Infra
- Goal: separate auth and account management

## 5. Inter-module contracts (public API)
- Contract types: **protocols**, **DTOs**, **events**
- Contract location: `Domain/SharedContracts`
- Compatibility and versioning rules
- Avoid “Shared Hell”: minimal, stable contracts with owner
- Treat transitive dependencies as public (audit indirect imports)

**Conceptual signatures (text):**
- `protocol CheckoutRouting` — “start checkout flow with purchase context”
- `struct CheckoutContextDTO` — “minimal data: items, price, promos, source”
- `protocol AuthStateProviding` — “publish authenticated state and expiration”
- `event AuthStateChanged` — “login, logout, refresh, expiry”
- `struct AuthSnapshotDTO` — “minimal state for cross-module use”

## 6. Navigation (Coordinator/Router via protocol)
- Navigation decoupled by public contract (e.g., `CheckoutRouting`)
- `CatalogFeature` depends on the contract, not `CheckoutFeature`
- `Composition Root` injects the concrete router implementation
- Benefits: UI isolation, contract-based tests, implementation swap

**Catalog → Checkout flow (no direct import):**
- Catalog emits navigation intent via contract
- Composition Root resolves target and instantiates flow
- Checkout receives context via stable DTO

## 7. Dependency strategy (CocoaPods + SPM)

### A) CocoaPods (podspecs and subspecs)
**Module/target organization**
- Pods by layer: Domain, Feature, Infra, UI
- Subspecs by BU: Catalog, Checkout, Profile
- Composition Roots as targets consuming explicit pods
- Dedicated `SharedContracts` pod for public contracts

**Resources (strings/images)**
- Bundle per pod with standardized naming
- Strings/localization per module
- Explicit bundle imports

**Avoid transitive dependencies**
- Explicit `podspec` and minimal subspecs
- Layer/BU lint and header auditing

**Trade-offs (build, maintenance, DX, CI)**
- High granularity control; more podspec maintenance
- Pod resolution can impact build
- CI with per-pod cache, but more pipeline complexity

**When to choose (large company)**
- Strong CocoaPods legacy
- Need fine-grained public API control
- Many resources and isolated bundles

**Document in README**
- “Dependencies (CocoaPods)” section
- “Resource Bundles” section
- “Public API Policies” section
- “Dependency Rules” section

### B) Swift Package Manager (SPM)
**Module/target organization**
- Packages by layer; targets by BU
- `SharedContracts` as isolated target
- Composition Roots as app targets

**Resources (strings/images)**
- Resources per target and module bundle
- Consistent access conventions and paths

**Avoid transitive dependencies**
- Small, focused targets
- Lint for forbidden imports by layer/BU
- Mandatory review for manifest changes

**Trade-offs (build, maintenance, DX, CI)**
- Simple native integration
- Less auxiliary infra
- Build granularity can be lower

**When to choose (large company)**
- Swift ecosystem standardization
- Fast onboarding and consistent DX
- Progressive migration to SPM

**Document in README**
- “Dependencies (SPM)” section
- “Resources per Module” section
- “Boundary Rules” section
- “Package Governance” section

## 8. Build performance

### Measurement plan (metrics and methodology)
- Compare **baseline (before)** vs **modular (after)**
- Measure **build time**, **feedback time**, **CI stability**
- Controlled environment, 5–10 runs per scenario, use median
- Scenarios: clean build, incremental, link time, scripts
- Raw logs + results sheet + notes

### Metrics table (to fill)

| Metric | Baseline (before) | Modular (after) | Delta | Notes |
|---|---:|---:|---:|---|
| Clean build (s) |  |  |  |  |
| Incremental (same module) (s) |  |  |  |  |
| Incremental (contract change) (s) |  |  |  |  |
| Link time (s) |  |  |  |  |
| Script phases total (s) |  |  |  |  |
| Cache hit (CI) (%) |  |  |  |  |
| Flaky failures (CI) |  |  |  |  |
| Feedback time (s) |  |  |  |  |

### Optimization roadmap (highest impact first)
- Isolate “hot” modules with high change frequency
- Reduce transitive dependencies and unnecessary imports
- Remove global script phases; move to specific modules
- Split large targets by BU
- Separate resources and bundles per module to avoid recompiles
- Review linking and CI caching by module

### How to present results (README + Docs)
- README: 2–3 metrics with % improvement
- Docs: methodology, logs, screenshots, full tables

### Arm traps (look good, get worse)
- Giant shared modules that become a new monolith
- Excessive dynamic frameworks
- Global scripts running on all targets
- Utility modules pulling half the graph
- Over-splitting without real gains

## 9. Incremental migration strategy (strangler)

### Extraction order (with rationale)
1) Cross-cutting Infra (Network, Persistence, Analytics)
2) SharedContracts (protocols/DTOs/events)
3) Domain per BU (Catalog → Checkout → Profile)
4) Feature per BU (Catalog → Checkout → Profile)
5) UI/DesignSystem and SharedComponents
6) Composition Roots (SuperApp + BU Apps)

### Breaking transitive dependencies
- Map current graph and coupling hubs
- Replace indirect imports with explicit contracts
- Split “utility modules” into focused services
- Enforce dependency budgets per module
- Layer/BU lint to block cross-dependencies

### Handling cycles (no hacks)
- Move interfaces to Domain, implementations to Infra
- Invert dependencies via contracts (protocol callbacks)
- Move orchestration to Composition Root
- Create event module (SharedContracts)
- Re-evaluate boundaries if cycles persist

### Checkpoints per stage (tests and safety)
- Infra + Contracts: unit, smoke, lint
- Domain per BU: unit + BU smoke
- Feature per BU: local integration + critical flows
- Composition Roots: per-app build + release checklist

### Internal API compatibility
- Lightweight contract versioning (v1/v2)
- Backward compatibility by default
- Deprecation with deadline and owner
- Minimal contracts, documented

### “Done” criteria per module
- Compiles in isolation with explicit dependencies
- Layer/BU lint passes
- Essential module tests passing
- Public API documented
- Build metrics within budget
- Ownership defined

## 10. Tests and governance (ownership, rules, anti-cycle)
- Ownership per domain with clear responsibilities
- Dependency rules and automated enforcement
- Anti-cycle policy and violation detection
- Test strategy: unit, integration, contract

## 11. Roadmap (next steps)
- Next app/BU extractions
- Architecture tooling evolution
- Performance and quality targets
- Team adoption and onboarding

## 12. Trade-offs FAQ (frameworks, linking, scripts)
- Dynamic vs static frameworks
- SPM vs CocoaPods: costs and benefits
- Script phases and build impact
- App size and linking implications

## 13. How to run (text-only steps)
- Environment prerequisites
- Install dependencies
- Open and build the project
- Run basic tests
