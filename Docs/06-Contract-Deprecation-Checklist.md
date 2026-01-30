# 06 — Contract Deprecation Checklist

Use this checklist for PRs that introduce or remove contract versions.

## Definitions
- **Contract**: public API surface in `SharedContracts` (protocols, DTOs, events).
- **Consumer**: any module/app target that imports and uses the contract.
- **Owner**: accountable person/team for contract lifecycle.
- **Breaking change**: requires consumer changes to compile or behave correctly.
- **Deprecation**: formal notice that a contract will be removed.

## Change classification
- [ ] Additive change (safe)
- [ ] Breaking change (requires v2)

## v1 → v2 introduction
- [ ] New v2 contract published alongside v1
- [ ] Migration guidance documented in `Docs/02`
- [ ] Owners and consumers notified

## Compatibility window
- [ ] Window defined (e.g., 2 releases or 30–60 days)
- [ ] Exceptions approved and documented

## Removal checklist
- [ ] Usage audit completed (search + CI checks)
- [ ] SuperApp + BU apps migrated
- [ ] CI gates green (deps, imports, tests)
- [ ] v1 removed and docs updated

## Approvals
- [ ] Contract owner approval
- [ ] Platform/architecture approval for removal
