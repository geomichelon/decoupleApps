# 05 — Ownership and Governance

> Outline for ownership, PR checks, and architecture lint.

## Goal
- Define clear responsibility per module and BU
- Ensure quality and contract stability

## Ownership
- Each module has an owner (team or area)
- Owners approve contract and dependency changes
- Escalation path for architecture conflicts

## Required PR checks
- Dependency lint (layer/BU)
- Cycle detection in the graph
- Essential module tests
- Contract validation (compatibility)

## Lint and automation
- Rules per layer and per BU
- Dependency budget per module
- Alerts for SharedContracts growth

## Change policy
- Breaking contract changes require deprecation
- Docs updates are a merge requirement
- Architecture review for new dependencies

## Common risks
- “Shared” modules turning into a monolith
- Unaudited transitive dependencies
- Missing ownership/accountability

## References
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
