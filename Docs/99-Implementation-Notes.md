# 99 — Implementation Notes (PR Checklist)

## Scope
- CheckoutDomain + CheckoutFeature implementation.
- ProfileDomain + ProfileFeature implementation.

## Compliance Checklist

### Docs/00 — Architecture
- [ ] Domain has business rules only (no UI, no SwiftUI).
- [ ] Feature is UI/orchestration only (no cross‑BU logic).
- [ ] Composition Root remains in App targets.
- [ ] Contracts remain in `SharedContracts`.

### Docs/01 — Dependency Graph Rules
- [ ] CheckoutFeature depends only on CheckoutDomain + SharedContracts (+ DesignSystem/Core if needed).
- [ ] CheckoutDomain depends only on Foundation (+ SharedContracts optional).
- [ ] No dependency on CatalogFeature or ProfileFeature.
- [ ] No cycles introduced.

### Docs/02 — Contracts/EntryPoints
- [ ] Uses EntryPoint protocol from SharedContracts (`CheckoutEntryPoint`).
- [ ] DTOs/events remain in SharedContracts and are unchanged.
- [ ] Feature exposes an EntryPoint/factory implementation without inverse dependency.

### Tests (minimum)
- [ ] Domain unit tests cover add/remove/update quantity and totals.
- [ ] Validation (quantity > 0) tested.

### Profile-specific checks
- [ ] ProfileDomain uses contracts only (no UI).
- [ ] ProfileFeature uses `AuthStateProviding` + `AuthEventPublishing`.
- [ ] ProfileEntryPoint is respected (composition root handles navigation).
- [ ] Domain tests cover signed-in vs signed-out behavior.
