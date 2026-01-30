# Entrevista — Modularização em Escala (DecoupledApps-iOS)

## Perguntas difíceis + respostas curtas

1) **Como você evita “shared hell” ao criar contratos comuns?**
- Contratos mínimos e estáveis, com owner definido
- Proibição explícita de regra de negócio e UI em “shared”
- Budget de crescimento e revisão obrigatória

2) **Como você garante que um módulo não depende de outro por import transitivo?**
- Lint de dependências por camada/BU
- Auditoria de imports indiretos e budgets por módulo
- Dependências explícitas no manifest/podspec

3) **O que impede o surgimento de um novo monólito de módulos?**
- Boundaries por BU e regras anti‑ciclo
- Composition Root como único ponto que conhece múltiplas BUs
- Métricas de crescimento do grafo e alertas

4) **Por que usar contratos + DI em vez de chamadas diretas?**
- Acoplamento explícito, testável e substituível
- Permite targets independentes e extração gradual
- Reduz regressões cruzadas

5) **Como você resolve ciclos sem “gambiarra”?**
- Inversão de dependência via ports no Domain
- Eventos e contratos assíncronos
- Orquestração movida para o Composition Root

6) **Quando escolher CocoaPods vs SPM?**
- CocoaPods: controle granular, bundles isolados, legado forte
- SPM: integração nativa, menor infra, DX mais simples
- Decisão guiada por escala, tooling e padrão corporativo

7) **Como provar melhoria de build de forma confiável?**
- Cenários fixos e mediana de múltiplas execuções
- Ambiente controlado e logs brutos versionados
- Comparação antes/depois por cenário (clean, incremental, link, scripts)

8) **O que mais impactou o build time?**
- Redução de dependências transitivas
- Isolamento de módulos com alta frequência de mudança
- Remoção de scripts globais e targets excessivos

9) **Como garantir compatibilidade entre módulos evoluindo em paralelo?**
- Versionamento leve de contratos (v1/v2)
- Backward compatibility e política de depreciação
- CI com testes de contrato

10) **Como decide a ordem de extração?**
- Primeiro Infra e contratos, depois Domain e Feature
- Prioriza BUs mais estáveis e de maior impacto
- Reavalia com métricas de risco e dependência

11) **Como evitar “hidden dependencies” em navegação?**
- Routing via protocolos em `SharedContracts`
- Implementações injetadas no Composition Root
- Proibição de imports diretos entre Features

12) **Qual o maior trade‑off?**
- Agilidade e autonomia vs. custo de governança
- Disciplina maior com contratos e revisão
- Complexidade inicial, ganho contínuo depois
