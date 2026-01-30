# DecoupledApps-iOS — README Outline (completo)

> Estrutura sugerida do README. Substitua os bullets por conteúdo final conforme o repo evoluir.

## Índice
1. Contexto e problema
2. Objetivo
3. Arquitetura-alvo e princípios
4. Dependency graph
5. Contratos inter-módulo
6. Navegação
7. Estratégia de dependências
8. Build performance
9. Estratégia incremental de migração
10. Testes e governança
11. Roadmap
12. FAQ de trade-offs
13. Como rodar

## 1. Contexto e problema (milhares de módulos / agilidade)
- Cenário do super‑app: crescimento de escopo, times e dependências
- Dor principal: complexidade acoplada desacelera releases e onboarding
- Sinais de escala: milhares de módulos, builds longos, regressões cruzadas
- Impacto: custo de mudança alto, ownership difuso, retrabalho

## 2. Objetivo (extração de apps por unidade de negócio)
- Transformar um super‑app em apps independentes por unidade de negócio
- Manter governança e consistência sem bloquear autonomia dos times
- Provar que a extração é incremental, segura e mensurável
- Demonstrar limites de domínio e contratos estáveis entre módulos

## 3. Arquitetura-alvo e princípios (Clean Architecture + boundaries)
- Camadas e responsabilidades (entidades, casos de uso, interface)
- Fronteiras explícitas entre domínios e infraestrutura
- Regra de dependência e direção do fluxo
- Isolamento de mudanças e estabilidade de contratos
- Princípios de modularização e desacoplamento

### Unidades de negócio (BUs)
- Catalog, Checkout e Profile como domínios principais
- Cada BU com módulos Feature, Domain e contratos públicos
- UI/DesignSystem transversal; Infra como implementações técnicas
- Composition Root monta apps por BU e SuperApp

### Lista de módulos por categoria
**Feature**
- Feature/CatalogFeature
- Feature/CheckoutFeature
- Feature/ProfileFeature

**Domain**
- Domain/CatalogDomain
- Domain/CheckoutDomain
- Domain/ProfileDomain
- Domain/SharedContracts

**Infra**
- Infra/Network
- Infra/Persistence
- Infra/Analytics
- Infra/Payments
- Infra/Auth

**UI/DesignSystem**
- UI/DesignSystem
- UI/SharedComponents

**Composition Root**
- App/SuperApp
- App/CatalogApp
- App/CheckoutApp
- App/ProfileApp
- App/CompositionKits

## 4. Dependency graph (visão geral)
- Visão de alto nível do grafo de dependências
- Módulos core vs. módulos de domínio vs. infraestrutura
- Fluxo permitido e dependências proibidas
- Como o grafo é gerado/validado

### Matriz de dependências permitidas + regras anti‑ciclo
- Feature → Domain, UI/DesignSystem, Infra (via abstrações), SharedContracts
- Domain → SharedContracts (opcional)
- Infra → Domain (somente para implementar ports)
- UI/DesignSystem → (não depende de Feature/Domain/Infra)
- Composition Root → Feature, Domain, Infra, UI/DesignSystem

**Anti‑ciclo**
- Nenhum módulo depende de Feature de outro BU
- Domain não depende de Domain de outra BU (apenas SharedContracts)
- Infra nunca depende de Feature
- Composition Root é o único ponto que conhece múltiplas BUs
- Ciclos bloqueados por lint (A→B→C→A)

### Diagrama textual do grafo (camadas + dependências principais)
- Composition Root → Features (Catalog/Checkout/Profile) + UI + Infra
- Feature/* → Domain/* + UI + SharedContracts
- Infra/* → Domain/* (ports)
- Domain/* → SharedContracts
- UI/DesignSystem → (sem dependências acima)

### Targets por BU (extração de apps)
**SuperApp**
- Inclui: CatalogFeature, CheckoutFeature, ProfileFeature + Domains + Infra + UI
- Objetivo: compatibilidade total durante a migração

**CatalogApp**
- Inclui: CatalogFeature + CatalogDomain + SharedContracts + UI + Infra base
- Objetivo: validar extração isolada do catálogo

**CheckoutApp**
- Inclui: CheckoutFeature + CheckoutDomain + SharedContracts + UI + Infra de pagamentos
- Objetivo: isolar fluxo crítico de compra

**ProfileApp**
- Inclui: ProfileFeature + ProfileDomain + SharedContracts + UI + Infra de auth
- Objetivo: separar autenticação e gestão de conta

## 5. Contratos inter-módulo (API pública)
- Tipos de contrato: **protocols**, **DTOs**, **events**
- Local dos contratos: `Domain/SharedContracts`
- Regras de compatibilidade e versionamento
- Evitar “Shared Hell”: contratos mínimos, estáveis e com owner
- Tratar dependências transitivas como públicas (auditar imports indiretos)

**Assinaturas conceituais (texto):**
- `protocol CheckoutRouting` — “iniciar fluxo de checkout com contexto de compra”
- `struct CheckoutContextDTO` — “dados mínimos: itens, preço, promoções, origem”
- `protocol AuthStateProviding` — “publicar estado autenticado e expiração”
- `event AuthStateChanged` — “login, logout, refresh, expiry”
- `struct AuthSnapshotDTO` — “estado mínimo para uso cross‑module”

## 6. Navegação (Coordinator/Router via protocol)
- Navegação desacoplada por contrato público (ex.: `CheckoutRouting`)
- `CatalogFeature` depende do contrato, não de `CheckoutFeature`
- `Composition Root` injeta a implementação concreta do router
- Benefícios: isolamento de UI, testes por contrato, troca de implementação

**Fluxo Catalog → Checkout (sem import direto):**
- Catalog emite intenção de navegação por contrato
- Composition Root resolve o target e instancia o fluxo
- Checkout recebe contexto via DTO estável

## 7. Estratégia de dependências (CocoaPods + SPM)

### A) CocoaPods (podspecs e subspecs)
**Organização de módulos e targets**
- Pods por camada: Domain, Feature, Infra, UI
- Subspecs por BU: Catalog, Checkout, Profile
- Composition Roots como targets que consomem pods explícitos
- Pod `SharedContracts` dedicado a contratos públicos

**Resources (strings/imagens)**
- Bundle por pod com naming padronizado
- Strings/localization por módulo
- Importação explícita de bundles necessários

**Evitar dependências transitivas**
- `podspec` explícito e subspecs mínimos
- Lint por camada/BU e auditoria de headers

**Trade‑offs (build, manutenção, DX, CI)**
- Controle granular alto; manutenção de podspecs maior
- Resolução de pods pode impactar build
- CI com cache por pod, mas pipeline mais complexo

**Quando escolher (empresa grande)**
- Legado forte em CocoaPods
- Necessidade de controle fino de APIs públicas
- Muitos recursos e bundles isolados

**Documentar no README**
- Seção “Dependências (CocoaPods)”
- Seção “Bundles de Recursos”
- Seção “Políticas de API Pública”
- Seção “Regras de Dependência”

### B) Swift Package Manager (SPM)
**Organização de módulos e targets**
- Packages por camada; targets por BU
- `SharedContracts` como target isolado
- Composition Roots como targets de app

**Resources (strings/imagens)**
- Resources por target e bundle do módulo
- Convenção de acesso e paths consistentes

**Evitar dependências transitivas**
- Targets pequenos e específicos
- Lint de imports proibidos por camada/BU
- Review obrigatório de mudanças no manifest

**Trade‑offs (build, manutenção, DX, CI)**
- Integração simples e nativa
- Menos infra auxiliar
- Granularidade de build pode ser menor

**Quando escolher (empresa grande)**
- Padronização no ecossistema Swift
- Onboarding rápido e DX consistente
- Migração progressiva para SPM

**Documentar no README**
- Seção “Dependências (SPM)”
- Seção “Resources por Módulo”
- Seção “Boundary Rules”
- Seção “Governança de Pacotes”

## 8. Build performance

### Plano de medição (métricas e metodologia)
- Comparar **baseline (antes)** vs **estado modularizado (depois)**
- Medir impacto em **tempo de build**, **tempo de feedback** e **estabilidade de CI**
- Ambiente controlado, 5–10 execuções por cenário, usar mediana
- Cenários: clean build, incremental, link time, scripts
- Logs brutos + planilha de resultados + observações

### Tabela de métricas (para preencher)

| Métrica | Baseline (antes) | Modularizado (depois) | Variação | Observações |
|---|---:|---:|---:|---|
| Clean build (s) |  |  |  |  |
| Incremental (mesmo módulo) (s) |  |  |  |  |
| Incremental (contrato) (s) |  |  |  |  |
| Link time (s) |  |  |  |  |
| Script phases total (s) |  |  |  |  |
| Cache hit (CI) (%) |  |  |  |  |
| Falhas intermitentes (CI) |  |  |  |  |
| Tempo de feedback (s) |  |  |  |  |

### Roteiro de otimizações (alto impacto primeiro)
- Isolar módulos “quentes” com maior frequência de mudança
- Reduzir dependências transitivas e imports desnecessários
- Remover script phases globais; mover para módulos específicos
- Fazer split de targets grandes em menores por BU
- Separar recursos e bundles por módulo para evitar recompilações
- Revisar linking e caching de CI por módulo

### Como apresentar resultados (README + Docs)
- README: resumo com 2–3 métricas e % de melhoria
- Docs: metodologia, logs, screenshots e tabelas completas

### Arm traps (parecem boas, mas pioram)
- Mega‑módulos shared que viram novo monólito
- Excesso de frameworks dinâmicos
- Scripts globais rodando em todos os targets
- “Utilities” que puxam metade do grafo
- Subdivisão excessiva que cria overhead

## 9. Estratégia incremental de migração (strangler)

### Ordem de extração (com justificativa)
1) Infra transversal (Network, Persistence, Analytics)
2) SharedContracts (protocols/DTOs/events)
3) Domain por BU (Catalog → Checkout → Profile)
4) Feature por BU (Catalog → Checkout → Profile)
5) UI/DesignSystem e SharedComponents
6) Composition Roots (SuperApp + Apps por BU)

### Quebra de dependências transitivas
- Mapear grafo atual e hubs de acoplamento
- Substituir imports indiretos por contratos explícitos
- Quebrar “utility modules” em serviços focados
- Impor budgets de dependência por módulo
- Lint de camada/BU para bloquear dependências cruzadas

### Lidar com ciclos (sem gambiarra)
- Extrair interfaces para o Domain e mover implementações para Infra
- Inverter dependência usando contratos (callbacks por protocolo)
- Mover orquestração para Composition Root
- Criar módulo de eventos (SharedContracts)
- Revisar boundaries quando ciclos persistirem

### Checkpoints por etapa (testes e safety)
- Infra + Contracts: unit, smoke, lint
- Domain por BU: unit + smoke por BU + compatibilidade
- Feature por BU: integração local + fluxos críticos
- Composition Roots: build por app + smoke + release checklist

### Compatibilidade de APIs internas
- Versionamento leve de contratos (v1/v2)
- Backward compatibility sempre que possível
- Depreciação com prazo e owner
- Contratos mínimos, sem payloads inflados

### Critérios de “done” por módulo
- Compila isoladamente com dependências explícitas
- Lint de camada/BU passa sem exceções
- Testes essenciais do módulo rodando
- API pública documentada
- Métricas de build dentro do budget
- Ownership definido

## 10. Testes e governança (ownership, regras, anti-ciclo)
- Ownership por domínio e responsabilidades claras
- Regras de dependência e enforcement automatizado
- Política anti‑ciclo e detecção de violações
- Estratégia de testes: unitários, integração, contrato

## 11. Roadmap (próximos passos)
- Próximas extrações de apps/unidades
- Evolução do tooling de arquitetura
- Metas de performance e qualidade
- Adoção por times e onboarding

## 12. FAQ de trade-offs (frameworks, linking, scripts)
- Dynamic vs static frameworks
- SPM vs CocoaPods: custos e benefícios
- Script phases e impacto no build
- Tamanho do app e impactos de linking

## 13. Como rodar (somente passos em texto)
- Pré‑requisitos de ambiente
- Passos para instalar dependências
- Como abrir e compilar o projeto
- Como executar testes básicos
