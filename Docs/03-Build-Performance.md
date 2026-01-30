# 03 — Build Performance

> Outline de metricas, metodologia e apresentacao de resultados.

## Objetivo
- Provar melhoria de build e eficiencia de workflow
- Comparar baseline (antes) vs modularizado (depois)

## Metodologia
- Ambiente controlado (mesmo Xcode e macOS)
- 5–10 execucoes por cenario, usar mediana
- Cenarios: clean build, incremental, link time, scripts
- Logs brutos + planilha de resultados

## Metricas
- Clean build (s)
- Incremental por modulo (s)
- Incremental por contrato (s)
- Link time (s)
- Script phases total (s)
- Cache hit (CI) (%)
- Falhas intermitentes (CI)
- Tempo de feedback (s)

## Como coletar
- Padronizar schema e target de medicao
- Rodar sempre no mesmo horario/ambiente
- Salvar logs e screenshots do build log

## Apresentacao de resultados
- README: 2–3 metricas com % de melhoria
- Docs: tabelas completas + screenshots + logs
- Diferenciar cenarios (clean, incremental, link, scripts)

## Arm traps
- Mega-modulos shared
- Excesso de frameworks dinamicos
- Scripts globais em todos os targets
- Subdivisao excessiva sem ganho real

## Referencias internas
- `04-Migration-Plan.md`
