# 02 — Module API Contracts

> Outline for contracts, types, and versioning policy.

## Goal
- Define how modules communicate without direct imports
- Avoid hidden dependencies and “shared hell”

## Contract types
- **Protocols**: capabilities and ports (e.g., routing, state providing)
- **DTOs**: minimal, stable data between modules
- **Events**: domain facts for async integration

## Preconditions
- `CheckoutEntryPoint` must only be invoked when authenticated.

## Location
- Public contracts live in `Domain/SharedContracts`
- No dependencies on Feature, Infra, or UI

## Versioning and compatibility
- Lightweight versioning (v1, v2) per contract
- Backward compatibility by default
- Deprecation with deadline and owner

## Design rules
- Minimal contracts with clear scope
- DTOs contain data only, no logic
- Events named after business facts
- Avoid “god contracts”

## Deprecation & Versioning Policy

### Definitions
- **Contract**: public API surface in `SharedContracts` (protocols, DTOs, events).
- **Consumer**: any module/app target that imports and uses a contract.
- **Owner**: accountable team/person for a contract’s stability and lifecycle.
- **Breaking change**: change that requires consumer code modifications to compile or behave correctly.
- **Deprecation**: formally marking a contract as scheduled for removal.

### Versioning strategy (v1/v2 coexistence)
- Prefer **additive changes**; avoid breaking changes when possible.
- For breaking changes, introduce **v2 alongside v1**:
  - New type/entrypoint names (e.g., `CheckoutEntryPointV2`).
  - New DTOs/events with explicit version suffixes.
  - Keep v1 intact until all consumers migrate.
- Deprecate v1 only after v2 is fully adopted.

### Compatibility window
- Default window: **2 release cycles** or **30–60 days**, whichever is longer.
- Exceptions require owner + platform approval and must be documented in this file.
- Critical security fixes may shorten the window with explicit approval.

### v1 → v2 flow (conceptual timeline)
1) **Design**: propose v2 contract; review by owner + platform.
2) **Publish**: ship v2 next to v1; update docs and migration guidance.
3) **Adopt**: migrate consumers (SuperApp + BU apps).
4) **Deprecate**: mark v1 for removal with timeline.
5) **Remove**: delete v1 after window and zero usage.

### Removal checklist (high level)
- Confirm no consumers via search/telemetry (if available).
- Update all targets (SuperApp + BU apps).
- CI gates pass (dependency rules, import boundaries, contract checks).
- Remove v1 and update docs.

## Publication and governance
- Mandatory review for new contracts
- Short docs with usage examples
- Contract growth metrics

## Risks and mitigations
- Bloated contracts -> split by domain
- Cross coupling -> reinforce boundaries
- Breaking compatibility -> deprecation policy

## References
- `00-Architecture.md`
- `01-Dependency-Graph-Rules.md`
