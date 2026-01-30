# 02 — Module API Contracts

> Outline for contracts, types, and versioning policy.

## Goal
- Define how modules communicate without direct imports
- Avoid hidden dependencies and “shared hell”

## Contract types
- **Protocols**: capabilities and ports (e.g., routing, state providing)
- **DTOs**: minimal, stable data between modules
- **Events**: domain facts for async integration

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
