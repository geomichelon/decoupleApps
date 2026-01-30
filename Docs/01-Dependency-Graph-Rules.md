# 01 — Dependency Graph Rules

> Outline com regras do grafo de dependencias e politica anti-ciclo.

## Objetivo
- Garantir dependencias explicitas e previsiveis
- Evitar acoplamento cruzado entre BUs
- Bloquear ciclos e dependencias transitivas indevidas

## Regras de camadas
- Feature -> Domain, UI/DesignSystem, SharedContracts, Infra (via abstracoes)
- Domain -> SharedContracts (opcional)
- Infra -> Domain (somente para implementar ports)
- UI/DesignSystem -> sem dependencias acima
- Composition Root -> todas as camadas

## Regras por BU
- Feature de uma BU nao depende de Feature de outra BU
- Domain de uma BU nao depende de Domain de outra BU (apenas SharedContracts)
- Infra nao depende de Feature
- Composition Root e o unico ponto que integra multiplas BUs

## Anti-ciclo
- Nenhum ciclo permitido (A->B->C->A)
- Ciclos detectados bloqueiam merge
- Excecoes sao proibidas

## Dependencias transitivas
- Dependencias transitivas contam como publicas
- Proibido importar modulo indiretamente
- Auditoria periodica do grafo

## Mecanismos de enforcement
- Lint de dependencias por camada e BU
- Orcamento de dependencias por modulo
- Revisao obrigatoria para novas dependencias

## Sinais de violacao
- Crescimento rapido de SharedContracts
- Modulos “utility” que viram hub
- Features que “puxam” Infra diretamente

## Referencias internas
- `00-Architecture.md`
- `02-Module-API-Contracts.md`
- `05-Ownership-and-Governance.md`
