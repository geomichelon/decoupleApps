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
- Ensure CheckoutFeature is not instantiated outside router/gate in App targets

## CI/CD Governance
- **PR (CI)**: architecture gates + import boundaries + checkout gating check + SPM unit tests.
- **Main (CD-lite)**: build all app targets (SuperApp + BU apps) and upload logs.
- **Release (manual)**: Fastlane-driven archive/TestFlight via workflow_dispatch.
- `Package.swift` is the source of truth for the dependency graph.

## Release (TestFlight via Fastlane)
- CI **does not** sign or upload builds. Release is manual.
- Fastlane lives under `/fastlane` and uses **match** by default.
- Each target has its own lane:
  - `beta_superapp`, `beta_catalog`, `beta_checkout`, `beta_profile`

### Local release (example)
- `bundle install`
- `bundle exec fastlane beta_superapp`

### Required GitHub secrets
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY` (raw or base64 key content)
- `MATCH_GIT_URL`
- `MATCH_PASSWORD`

### Optional secrets (if not using API key)
- `FASTLANE_USER`
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`

### Signing strategy
- **Default**: `match` (recommended, readonly in CI)
- **Manual signing**: disable `match` and set export options in Fastfile

## Lint and automation
- Rules per layer and per BU
- Dependency budget per module
- Alerts for SharedContracts growth

## Change policy
- Breaking contract changes require deprecation
- Docs updates are a merge requirement
- Architecture review for new dependencies

## Contract Change Management

### PR checklist (required when contracts change)
- Identify contract **owner** and affected **consumers**.
- Classify change: **additive** vs **breaking**.
- For breaking changes, introduce **v2 alongside v1**.
- Update docs (`Docs/02`) with timeline and migration guidance.
- Confirm compatibility window and rollout plan.
- Update `Docs/contracts/CHANGELOG.md` and, if breaking/removal, `Docs/contracts/DEPRECATIONS.md`.

### Ownership & approvals
- Contract owner approves any breaking change.
- Platform/architecture review required for v1 removals.
- Release notes must include contract changes and deprecation dates.

### Recommended CI gates (documentation)
- Lint/graph checks to prevent forbidden dependencies.
- Contract usage checks to ensure v1 is still consumed before removal.
- Block merges if contract docs (`Docs/02`, `Docs/contracts/*`) are not updated for contract changes.

## Common risks
- “Shared” modules turning into a monolith
- Unaudited transitive dependencies
- Missing ownership/accountability

## References
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
