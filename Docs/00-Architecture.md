# 00 — Architecture

> Outline with principles, layers, and boundaries for DecoupledApps-iOS.

## Purpose
- Describe the target architecture and its rationale
- Define clear boundaries between modules and business units
- Serve as a reference for future decisions

## Principles
- Decoupling by business unit (BU)
- Minimal, stable public contracts
- Dependencies always point toward Domain
- Composition Root as the single assembly point
- Incremental evolution (strangler)
- Composition roots enforce auth gating policies (e.g., checkout requires auth)

## Layers
- **Feature**: UI orchestration and use cases
- **Domain**: business rules, entities, contracts
- **Infra**: technical implementations (network, persistence, analytics)
- **UI/DesignSystem**: reusable UI components
- **Composition Root**: assembly and dependency injection

## Boundaries
- BUs (Catalog, Checkout, Profile) do not import each other
- Integrations happen via contracts in `SharedContracts`
- Infra never depends on Feature
- UI/DesignSystem does not depend on Feature/Domain/Infra
- Composition Root is the only place aware of multiple BUs

## Structural decisions
- Contracts (protocols/DTOs/events) live in Domain
- Navigation via protocols to avoid direct coupling
- Anti-cycle rules are mandatory
- Documentation and metrics are part of governance

## References
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
- `03-Build-Performance.md`
- `04-Migration-Plan.md`
- `05-Ownership-and-Governance.md`

## Assumptions
- Dependency manager: Swift Package Manager (SPM) with a local package in the repo.
- “Core” is a technical utility module, not business logic.
- New app targets coexist with the legacy target during migration.
- AuthStore is implemented in InfraAuth as an infrastructure implementation of auth contracts.
