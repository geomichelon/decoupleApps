# 00 — Architecture

> Outline com princípios, camadas e boundaries para o DecoupledApps-iOS.

## Propósito
- Descrever a arquitetura-alvo e o porquê do desenho
- Definir limites claros entre módulos e unidades de negócio
- Servir como referência para decisões futuras

## Princípios
- Desacoplamento por unidade de negócio (BU)
- Contratos públicos mínimos e estáveis
- Dependências sempre apontando para o Domain
- Composition Root como único ponto de montagem
- Evolução incremental (strangler)

## Camadas
- **Feature**: orquestração de UI e casos de uso
- **Domain**: regras de negócio, entidades e contratos
- **Infra**: implementações técnicas (network, persistence, analytics)
- **UI/DesignSystem**: componentes visuais reutilizáveis
- **Composition Root**: montagem e injeção de dependências

## Boundaries
- BUs (Catalog, Checkout, Profile) não importam entre si
- Integrações entre BUs ocorrem via contratos em `SharedContracts`
- Infra nunca depende de Feature
- UI/DesignSystem não depende de Feature/Domain/Infra
- Composition Root é o único ponto que conhece múltiplas BUs

## Decisões estruturais
- Contratos (protocols/DTOs/events) vivem no Domain
- Navegação via protocolos para evitar acoplamento direto
- Regras anti-ciclo obrigatórias
- Documentação e métricas como parte da governança

## Referências internas
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
- `03-Build-Performance.md`
- `04-Migration-Plan.md`
- `05-Ownership-and-Governance.md`

## Assumptions
- Gerenciador de dependências: Swift Package Manager (SPM) com pacote local no repositório.
- “Core” é um módulo técnico (infraestrutural) de utilitários básicos, sem regras de negócio.
- Targets de apps coexistem com o target legado atual até a migração completa.
