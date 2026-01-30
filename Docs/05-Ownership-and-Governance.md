# 05 — Ownership and Governance

> Outline de ownership, PR checks e lint de arquitetura.

## Objetivo
- Definir responsabilidades claras por modulo e BU
- Garantir qualidade e estabilidade dos contratos

## Ownership
- Cada modulo tem um owner (time ou area)
- Owners aprovam mudancas em contratos e dependencias
- Rotas de escalacao para conflitos de arquitetura

## PR checks obrigatorios
- Lint de dependencias (camada/BU)
- Checagem de ciclos no grafo
- Testes essenciais do modulo
- Validacao de contrato (compatibilidade)

## Lint e automacao
- Regras por camada e por BU
- Budget de dependencias por modulo
- Alertas para crescimento de SharedContracts

## Politica de mudanca
- Mudancas que quebram contrato exigem deprecacao
- Documentacao atualizada como criterio de merge
- Revisao arquitetural para novas dependencias

## Riscos comuns
- Modulos “shared” virando monolito
- Dependencias transitivas nao auditadas
- Owners ausentes ou sem accountability

## Referencias internas
- `01-Dependency-Graph-Rules.md`
- `02-Module-API-Contracts.md`
