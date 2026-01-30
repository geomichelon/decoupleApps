# 04 — Migration Plan

> Outline da estrategia incremental (strangler) e checkpoints.

## Objetivo
- Extrair modulos e apps com risco controlado
- Reduzir acoplamento sem parar o produto

## Ordem de extracao (com justificativa)
1) Infra transversal (Network, Persistence, Analytics)
2) SharedContracts (protocols/DTOs/events)
3) Domain por BU (Catalog -> Checkout -> Profile)
4) Feature por BU (Catalog -> Checkout -> Profile)
5) UI/DesignSystem e SharedComponents
6) Composition Roots (SuperApp + Apps por BU)

## Quebra de dependencias transitivas
- Mapear hubs e dependencias indiretas
- Substituir imports indiretos por contratos
- Quebrar “utility modules” em servicos focados
- Orcamentos de dependencia por modulo

## Lidar com ciclos (sem gambiarra)
- Inversao de dependencia via ports no Domain
- Eventos e contratos assincronos
- Orquestracao no Composition Root
- Revisao de boundaries quando ciclos persistirem

## Checkpoints por etapa
- Infra + Contracts: unit, smoke, lint
- Domain por BU: unit + smoke por BU
- Feature por BU: integracao local + fluxos criticos
- Composition Roots: build por app + checklist de release

## Compatibilidade de APIs internas
- Versionamento leve e backward compatibility
- Deprecacao com prazo e owner
- Contratos minimos e documentados

## Criterios de “done” por modulo
- Compila isoladamente
- Lint de camada/BU aprovado
- Testes essenciais passando
- API publica documentada
- Metricas dentro do budget
- Ownership definido

## Referencias internas
- `00-Architecture.md`
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
