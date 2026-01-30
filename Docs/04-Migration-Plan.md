# 04 — Migration Plan

> Outline for the incremental strategy (strangler) and checkpoints.

## Goal
- Extract modules and apps with controlled risk
- Reduce coupling without stopping the product

## Extraction order (with rationale)
1) Cross-cutting Infra (Network, Persistence, Analytics)
2) SharedContracts (protocols/DTOs/events)
3) Domain per BU (Catalog -> Checkout -> Profile)
4) Feature per BU (Catalog -> Checkout -> Profile)
5) UI/DesignSystem and SharedComponents
6) Composition Roots (SuperApp + BU Apps)

## Breaking transitive dependencies
- Map hubs and indirect dependencies
- Replace indirect imports with contracts
- Split “utility modules” into focused services
- Dependency budgets per module

## Handling cycles (no hacks)
- Invert dependencies via Domain ports
- Events and async contracts
- Orchestration in Composition Root
- Revisit boundaries when cycles persist

## Checkpoints per stage
- Infra + Contracts: unit, smoke, lint
- Domain per BU: unit + BU smoke
- Feature per BU: local integration + critical flows
- Composition Roots: per-app build + release checklist

## Internal API compatibility
- Lightweight versioning and backward compatibility
- Deprecation with deadline and owner
- Minimal, documented contracts

## “Done” criteria per module
- Compiles in isolation
- Layer/BU lint approved
- Essential tests passing
- Public API documented
- Metrics within budget
- Ownership defined

## References
- `00-Architecture.md`
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
