# 02 — Module API Contracts

> Outline de contratos, tipos e politica de versionamento.

## Objetivo
- Definir como modulos se comunicam sem imports diretos
- Evitar dependencias ocultas e “shared hell”

## Tipos de contrato
- **Protocols**: capacidades e ports (ex.: routing, state providing)
- **DTOs**: dados minimos e estaveis entre modulos
- **Events**: fatos de dominio para integracao async

## Localizacao
- Contratos publicos vivem em `Domain/SharedContracts`
- Sem dependencias de Feature, Infra ou UI

## Versionamento e compatibilidade
- Versionamento leve (v1, v2) por contrato
- Backward compatibility por padrao
- Deprecacao com prazo e owner

## Regras de design
- Contratos minimos e com escopo claro
- DTOs sem logica, apenas dados
- Eventos nomeados por fato de negocio
- Evitar “god contracts” compartilhados

## Publicacao e governance
- Revisao obrigatoria para novos contratos
- Documentacao curta com exemplos de uso
- Metricas de crescimento de contratos

## Riscos e mitigacoes
- Contratos inchados -> split por dominio
- Acoplamento cruzado -> reforcar boundaries
- Quebra de compatibilidade -> politica de deprecacao

## Referencias internas
- `00-Architecture.md`
- `01-Dependency-Graph-Rules.md`
