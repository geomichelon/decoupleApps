# 01 — Dependency Graph Rules

> Outline with dependency graph rules and anti-cycle policy.

## Goal
- Ensure explicit, predictable dependencies
- Avoid cross-BU coupling
- Block cycles and invalid transitive dependencies

## Layer rules
- Feature -> Domain, UI/DesignSystem, SharedContracts, Infra (via abstractions)
- Domain -> SharedContracts (optional)
- Infra -> Domain (only to implement ports)
- UI/DesignSystem -> no dependencies upward
- Composition Root -> all layers

## BU rules
- A BU Feature must not depend on another BU Feature
- A BU Domain must not depend on another BU Domain (only SharedContracts)
- Infra never depends on Feature
- Composition Root is the only place that integrates multiple BUs

## Anti-cycle
- No cycles allowed (A->B->C->A)
- Detected cycles block merge
- No exceptions

## Transitive dependencies
- Transitive dependencies count as public
- Indirect imports are forbidden
- Periodic graph audit

## Enforcement
- Layer/BU dependency lint
- Dependency budget per module
- Mandatory review for new dependencies

## Violation signals
- Fast growth of SharedContracts
- “Utility” modules becoming hubs
- Features pulling Infra directly

## References
- `00-Architecture.md`
- `02-Module-API-Contracts.md`
- `05-Ownership-and-Governance.md`
