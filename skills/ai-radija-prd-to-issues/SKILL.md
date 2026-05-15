---
description: Break a PRD or spec into independently-implementable tasks using tracer-bullet vertical slices. Use when user wants to convert a PRD to tasks, create implementation tickets, break down a spec into stories and tasks, or mentions "prd to issues".
user-invocable: true
disable-model-invocation: false
---

# PRD to Tasks

Break a PRD or specification into independently-implementable tasks using vertical slices (tracer bullets).

## Process

### 0. Detect or Select Tracker

Check `CLAUDE.md` for a `## Tracker` section. If found, use that config automatically and skip the question.

If not configured, ask: "Where should I create the work items? (Azure DevOps, Jira, GitHub Issues, Linear, Notion, or markdown file?)"

Then run `/ai-radija-tracker-setup` to collect and save the connection details.

Each tracker has a dedicated skill with API details, auth, and formatting rules:
- Azure DevOps → `/ai-radija-tracker-ado`
- Jira → `/ai-radija-tracker-jira`
- GitHub Issues → `/ai-radija-tracker-github`
- Linear → `/ai-radija-tracker-linear`
- Notion → `/ai-radija-tracker-notion`

### 1. Locate the PRD

Ask the user where the PRD lives:
- A file in the repo (e.g., `specs/<feature>/prd.md`, `docs/prd.md`)
- An issue in the project tracker (GitHub, Linear, Jira, Azure DevOps)
- Pasted directly in the conversation

Read the PRD into context.

### 2. Explore the codebase (optional)

If not already familiar with the codebase, explore to understand the current architecture, tech stack, and conventions.

### 3. Define the hierarchy

Ask the user which work item levels to create:

- **Epic** — top-level initiative grouping multiple features
- **Feature/PBI** — a business capability that delivers user value
- **User Story** — a specific user journey within a feature
- **Task** — an implementation unit within a story

Apply the correct format per level (see section 7).

### 4. Draft vertical slices

Break the PRD into **tracer bullet** slices. Each slice is a thin vertical cut through ALL layers end-to-end — NOT a horizontal slice of one layer.

Slices are either:
- **AFK**: can be implemented and merged without human interaction (prefer these)
- **HITL**: requires human decision (architectural choice, design review, external approval)

**Vertical slice rules:**
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones

### 5. Quiz the user

Present the proposed breakdown. For each slice:

- **Title**: user story format — "As a [role], I want [action] so that [value]"
- **Type**: AFK / HITL
- **Blocked by**: which other slices must complete first
- **User stories covered**: which stories from the PRD this addresses
- **Scope check**: does this touch scoped data (per-tenant, per-user)? If so, confirm filtering at every layer

Ask:
- Does the granularity feel right?
- Are the dependency relationships correct?
- Should any slices be merged or split further?

Iterate until the user approves.

### 6. Two-Phase Strategy (for backlogs with >15 items)

When the backlog has more than 15 work items total:

**Phase 1 — Create structure**: create all work items with title and hierarchy only (Epic → Features → Stories → Tasks). Goal: get the tree on the board quickly.

**Phase 2 — Enrich in batches**: go back to each level and add detailed specifications in batches of 4-6 items. This avoids timeouts and allows incremental review.

Always ask: "This backlog has N items. Want me to use the two-phase strategy (structure first, then enrich in batches)?"

### 7. Work Item Formats by Level

#### Epic Format (5 sections)

1. **Objective** — strategic goal this epic achieves (1-2 lines)
2. **Description** — scope, context, and how it fits the product roadmap
3. **Success Metrics** — how to measure if this epic is delivering value (KPIs, targets)
4. **Features Overview** — index of features/PBIs under this epic with one-line descriptions
5. **Technical Analysis** — cross-cutting architectural decisions, shared infrastructure needs, risks

#### Feature/PBI Format (6 sections)

1. **Objective** — what this feature delivers from a business perspective (1-2 lines)
2. **Description** — technical and functional context, how it fits into the architecture
3. **Personas Impacted** — which user roles are affected and how their workflow changes
4. **Success Criteria** — measurable outcomes indicating the feature delivers value
5. **Technical Analysis** — architectural decisions, components, API contracts, dependencies, risks
6. **Definition of Done** — conditions at the Feature level that must ALL be true to close

#### User Story Format (6 sections — mandatory)

1. **Objective** — what this story delivers from a business perspective (1-2 lines)
2. **Description** — technical and functional context, how it fits in the architecture
3. **TDD** — test scenarios in natural language (Given/When/Then). Minimum 3: happy path, edge case, error
4. **Example** — textual UI mockup, navigation flow, or API payload/response. Something concrete the developer can look at and know exactly what to build
5. **Technical Analysis** — affected components, state patterns, API endpoints, dependencies on other stories, technical risks
6. **Business Analysis** — business impact, implicit business rules, alternative use cases, formal acceptance criteria

#### Task Format (5 sections — Code Example mandatory)

1. **Description** — what to do in one action sentence + minimal context
2. **Technical Analysis** — design decision: which function/hook/component to create, which pattern, which libs, alternatives and why
3. **Business Analysis** — why this task exists — which business need or technical requirement it fulfills
4. **Code Example** — **MANDATORY.** Functional code showing the main structure: type/interface signatures, component or function structure, integration patterns with libs
5. **Done When** — specific, verifiable acceptance criteria. Avoid "it's implemented". Prefer: "Function X with tests Y covering Z scenarios"

### 8. Output

Write the task breakdown to the spec directory (e.g., `specs/<feature>/tasks.md`) or create issues in the project tracker if tooling is available.

#### Tracker-Specific Output

Use the tracker skill for formatting and API details. Follow the formatting rules defined in:
- `/ai-radija-tracker-ado` — HTML output, JSON Patch API
- `/ai-radija-tracker-jira` — ADF format, REST API v3
- `/ai-radija-tracker-github` — Markdown, `gh` CLI
- `/ai-radija-tracker-linear` — Markdown, GraphQL API
- `/ai-radija-tracker-notion` — Notion blocks, REST API or MCP
- **Markdown file** — write to `specs/<feature>/tasks.md` with heading levels for hierarchy

Do NOT modify or close the parent PRD/feature.
