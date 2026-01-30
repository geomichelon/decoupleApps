# 99 — Implementation Notes (PR Checklist)

## Scope
- Enforce auth gating for Checkout at composition roots.
- Remove checkout bypass paths.
- Ensure checkout view refreshes when context changes.
- Propagate auth changes via a shared AuthStore.

## Compliance Checklist

### Docs/00 — Architecture
- [ ] Composition roots enforce auth gating policies (checkout requires auth).
- [ ] No contract signature changes.
- [ ] No Feature-to-Feature dependencies introduced.

### Docs/01 — Dependency Graph Rules
- [ ] Feature depends only on Domain + Contracts (+ UI/DesignSystem).
- [ ] Infra depends on Contracts/Core only.
- [ ] Composition roots own routing/gating.

### Docs/02 — Contracts/EntryPoints
- [ ] CheckoutEntryPoint invoked only when authenticated.
- [ ] EntryPoint remains the only path to start checkout.

### State & Auth
- [ ] Shared AuthStore is the single source of truth.
- [ ] Profile updates AuthStore (no local-only snapshot).
- [ ] Checkout UI refreshes on context changes.

### Tests / Checks
- [ ] Best-effort bypass check in Tools (fails on direct CheckoutFeatureView usage without entrypoint in Apps).

## Files to change (why)
- `Modules/Sources/InfraAuth/InfraAuth.swift` — shared AuthStore implementation.
- `Modules/Sources/ProfileFeature/ProfileFeatureView.swift` — bind to shared AuthStore.
- `Apps/SuperApp/SuperApp.swift` — gating, routing, remove bypass, refresh on context change.
- `Apps/CheckoutApp/CheckoutApp.swift` — gating + contract-driven flow.
- `Docs/99-Implementation-Notes.md` — record rationale for checkout refresh (`.id(context)`).
- `Docs/00-Architecture.md` — explicit gating policy.
- `Docs/02-Module-API-Contracts.md` — precondition for CheckoutEntryPoint.
- `Docs/05-Ownership-and-Governance.md` — rule against bypass.
- `Tools/check_checkout_bypass.sh` — new check.
- `.github/workflows/ci.yml` — include new check.

## Notes
- Checkout view uses `.id(context)` at the composition root to recreate the view model on new checkout sessions.

## Tuist Introduction Checklist

### Conformance
- [ ] SPM remains the source of truth for module dependencies (`Modules/Package.swift`).
- [ ] Tuist only generates workspace/projects/schemes for existing apps.
- [ ] No module structure or layering changes.
- [ ] CI path based on SPM remains unchanged.

### Minimal changes
- [ ] Added `Project.swift`/`Workspace.swift` without duplicating modules.
- [ ] App targets depend on SPM products (no Tuist targets for modules).
- [ ] Tuist scripts are additive and optional.

### Files to change (Tuist)
- `Tuist.swift` — generation settings.
- `Tuist/Dependencies.swift` — empty SPM dependencies (no external packages).
- `Project.swift` / `Workspace.swift` — app targets + workspace only.
- `Tools/tuist_*.sh` — bootstrap, generate, build.
- `.github/workflows/ci.yml` — optional Tuist validation job.
- `Docs/01-Dependency-Graph-Rules.md` — SPM source of truth.
- `Docs/03-Build-Performance.md` — optional Tuist build path.
- `README.md` — SPM vs Tuist section + commands.
