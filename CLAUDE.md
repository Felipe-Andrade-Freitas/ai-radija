# CLAUDE.md — AI Radija Tools

## Workflow Automatico com Skills

Quando o usuario iniciar uma conversa solicitando **analise de requerimento, feature, bug fix, melhoria ou qualquer tarefa de desenvolvimento**, o Claude DEVE seguir automaticamente o fluxo abaixo usando as skills do AI Radija Tools.

### Golden Path (Fluxo Completo)

```
# Project Bootstrap (once per project — prerequisite):
generate-pre-knowledge-docs → setup-templates

# Per-requirement workflow:
grill-me → specify → clarify → plan → tasks → tdd → implement → pr-ready
```

### Mapeamento de Intencoes → Skills

| Intencao do Usuario | Skill a Invocar | O que faz |
|---|---|---|
| Validar abordagem, stress-test de plano | `/ai-radija-grill-me` | 8-10 perguntas criticas, Go/No-Go |
| Especificar feature, descrever o que construir | `/ai-radija-specify` | Cria spec com user stories e requisitos |
| Reduzir ambiguidade, refinar spec | `/ai-radija-clarify` | Max 5 perguntas de clarificacao |
| Planejar implementacao, design tecnico | `/ai-radija-plan` | Research, data model, contracts |
| Gerar tasks, breakdown de implementacao | `/ai-radija-tasks` | Task list ordenada por dependencia |
| Criar/analisar requisitos, PRD | `/ai-radija-write-a-prd` | PRD via entrevista + exploracao do codigo |
| Planejar feature nova, stories e tasks | `/ai-radija-new-feature` | Feature → Stories → Tasks |
| Quebrar PRD em tasks de implementacao | `/ai-radija-prd-to-issues` | Vertical slices (tracer bullets) |
| Implementar com TDD | `/ai-radija-tdd` | Red-green-refactor com deteccao de stack |
| Executar implementacao completa | `/ai-radija-implement` | Phase-by-phase com TDD integrado |
| Criar PR, validar branch | `/ai-radija-pr-ready` | Checklist + geracao de PR formatado |
| Analisar consistencia dos artefatos | `/ai-radija-analyze` | Cross-check spec/plan/tasks |
| Validar qualidade de requisitos | `/ai-radija-checklist` | "Unit tests for English" |
| Definir governance do projeto | `/ai-radija-constitution` | Principios e constraints |
| Converter tasks em GitHub Issues | `/ai-radija-tasks-to-issues` | Tasks → Issues via gh CLI |
| Criar uma nova skill | `/ai-radija-write-a-skill` | Scaffolding de nova skill |
| Configurar templates do projeto | `/ai-radija-setup-templates` | Cria specs/.templates/ com defaults editaveis |
| Gerar documentacao de conhecimento do codebase (primeira vez no projeto) | `/ai-radija-generate-pre-knowledge-docs` | Analisa codebase e gera suite de 11 docs em `docs.AI/` |

### Project Bootstrap (execute ONCE per project — check on first session only)

Antes de qualquer outra acao, verifique o gate de pre-knowledge docs:

- Se `docs.AI/1_README.AI.md` NAO existir: notifique o usuario e sugira `/ai-radija-generate-pre-knowledge-docs`. Exemplo:
  > **Project knowledge docs not found.** Run `/ai-radija-generate-pre-knowledge-docs` to generate the `docs.AI/` documentation suite before starting development work. This runs once per project.

  Nao prossiga com nenhuma outra skill ate que o usuario decida.
- Se `docs.AI/1_README.AI.md` EXISTIR: continue normalmente. Nao repita essa verificacao na sessao.
- Nao reexecute automaticamente. Somente sob solicitacao explicita do usuario.

### Regras de Acionamento

0. **Inicio de sessao** (OBRIGATORIO — execute isso UMA VEZ por sessao, na primeira interacao):
   - Se `specs/.templates/` NAO existir: sugira `/ai-radija-setup-templates` e pare aqui.
   - Se `specs/.templates/` EXISTIR: liste os arquivos presentes e pergunte ao usuario quais templates devem ser considerados ativos nessa sessao. Exemplo de mensagem:
     > I found the following templates in `specs/.templates/`:
     > - `spec-template.md`
     > - `plan-template.md`
     > - `tasks-template.md`
     > - `constitution-template.md`
     > - `checklist-template.md`
     >
     > Which ones should I use for this session? (default: all)
   - Armazene a lista de templates ativos como contexto de sessao e aplique-a em todas as skills invocadas posteriormente.
   - NAO repita essa pergunta na mesma sessao.
1. **Sempre comece com `/ai-radija-grill-me`** para validar a abordagem antes de investir tempo
2. **Apos aprovacao**: siga com `/ai-radija-specify` → `/ai-radija-clarify` → `/ai-radija-plan`
3. **Antes de implementar**: gere tasks com `/ai-radija-tasks`, depois plano de testes com `/ai-radija-tdd`
4. **Implementacao**: use `/ai-radija-implement` que integra TDD automaticamente
5. **Branch pronta**: use `/ai-radija-pr-ready` para validar e gerar PR
6. **Se o contexto for ambiguo**: pergunte ao usuario qual fluxo seguir

### Templates Customizaveis

Skills que geram artefatos suportam templates custom em `specs/.templates/`:
- `spec-template.md` — usado por `/ai-radija-specify`
- `plan-template.md` — usado por `/ai-radija-plan`
- `tasks-template.md` — usado por `/ai-radija-tasks`
- `constitution-template.md` — usado por `/ai-radija-constitution`
- `checklist-template.md` — usado por `/ai-radija-checklist`

Use `/ai-radija-setup-templates` para criar todos os templates de uma vez com os defaults editaveis.

## Convencoes do Projeto

- Idioma de comunicacao: Portugues (BR), Ingles ou Espanhol, conforme o contexto
- Branch naming: seguir convencoes do projeto (detectar do repositorio)
- PRs devem referenciar o issue/ticket relevante
- Sempre verificar se dados sao globais ou scoped (per-tenant, per-user, per-org)
