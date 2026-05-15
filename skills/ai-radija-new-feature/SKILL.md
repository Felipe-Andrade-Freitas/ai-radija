---
description: Guide the creation of a complete feature breakdown with user stories, tasks, and acceptance criteria. Outputs a structured feature plan ready for any issue tracker. Use when user wants to plan a new feature, create workitems, register a feature, or mentions "new feature".
user-invocable: true
disable-model-invocation: false
---

# New Feature — Feature Planning

Guide the creation of a fully documented feature breakdown with user stories, tasks, and acceptance criteria.

**Always ask before creating anything.** Collect all required information first, then present a summary for approval.

---

## Step 0 — Detect or Select Tracker

Check `CLAUDE.md` for a `## Tracker` section. If found, use that config automatically and skip the question.

If not configured, ask: "Where should I create the work items? (Azure DevOps, Jira, GitHub Issues, Linear, Notion, or markdown file?)"

Then run `/ai-radija-tracker-setup` to collect and save the connection details.

Each tracker has a dedicated skill with API details, auth, and formatting rules:
- Azure DevOps → `/ai-radija-tracker-ado`
- Jira → `/ai-radija-tracker-jira`
- GitHub Issues → `/ai-radija-tracker-github`
- Linear → `/ai-radija-tracker-linear`
- Notion → `/ai-radija-tracker-notion`

---

## Step 1 — Gather Information

Ask the developer for:

1. **Category / Epic** — which area of the product does this belong to?
2. **Feature name** — short title describing the business capability
3. **Description** — what business problem does this solve?
4. **Acceptance criteria** — conditions that must be true for "done"
   - If data is involved: is it global or scoped (per-tenant, per-user)?
5. **Affected modules** — which repos, packages, or services are involved
6. **User stories** — break the feature into stories: "As a [role], I want [action] so that [value]"
7. **For each story**: tasks needed, estimated effort, assigned owner
8. **Priority** — High / Medium / Low

---

## Step 2 — Present Summary for Approval

Show a structured preview using the **Feature/PBI format (6 sections)**:

```
CATEGORY: <category>
FEATURE: <name>
Priority: <priority>

### Objective
What this feature delivers from a business perspective (1-2 lines).

### Description
Technical and functional context. How it fits into the existing architecture.

### Personas Impacted
Which user roles are affected and how their workflow changes.

### Success Criteria
Measurable outcomes that indicate the feature is delivering value.

### Technical Analysis
Architectural decisions, components affected, API contracts, dependencies, risks.

### Definition of Done
Conditions at the Feature level that must ALL be true to close:
  - All stories completed and tested
  - <specific criteria>

---

Story 1: <title>
  ### Objective
  <business value in 1-2 lines>
  ### Description
  <technical/functional context>
  ### TDD
  - Given <precondition>, When <action>, Then <expected>
  - Given <precondition>, When <action>, Then <expected>
  - Given <error case>, When <action>, Then <expected>
  ### Example
  <UI mockup, navigation flow, or API payload example>
  ### Technical Analysis
  <components, patterns, endpoints, dependencies, risks>
  ### Business Analysis
  <business impact, implicit rules, alternative use cases, formal acceptance>

  Tasks:
    - [ ] <task 1> — <effort> — <owner>
    - [ ] <task 2> — <effort> — <owner>
```

Ask the user to confirm before proceeding.

---

## Step 3 — Output

Write the feature plan to the spec directory (e.g., `specs/<feature>/plan.md`) or create issues in the project's issue tracker if tooling is available (GitHub Issues, Linear, Jira, Azure DevOps, etc.).

### User Story Format (6 sections — mandatory)

Every User Story MUST include these 6 sections:

1. **Objective** — what this story delivers from a business perspective (1-2 lines)
2. **Description** — technical and functional context, how it fits in the architecture
3. **TDD** — test scenarios in natural language (Given/When/Then or bullet list). Minimum 3: happy path, edge case, error
4. **Example** — textual UI mockup, navigation flow, or API payload/response example. Something concrete the developer can look at and know exactly what to build
5. **Technical Analysis** — affected components, state patterns, API endpoints, dependencies on other stories, technical risks
6. **Business Analysis** — business impact, implicit business rules, alternative use cases, formal acceptance criteria

### Task Format (5 sections — Code Example mandatory)

Every implementation Task MUST include these 5 sections:

1. **Description** — what to do in one action sentence + minimal context
2. **Technical Analysis** — design decision: which function/hook/component to create, which pattern to use, which libs, alternatives considered and why the choice was made
3. **Business Analysis** — why this task exists — which business need or technical requirement it fulfills
4. **Code Example** — **MANDATORY.** Functional code showing the main structure. Must include: type/interface signatures, component or function structure, integration pattern with libs (React Query, Recharts, shadcn/ui, Zustand, etc.)
5. **Done When** — specific, verifiable acceptance criteria. Avoid "it's implemented". Prefer: "Function X with tests Y covering Z scenarios" or "Component renders A when B"

### Tracker-Specific Output

Use the tracker skill for formatting and API details. Follow the formatting rules defined in:
- `/ai-radija-tracker-ado` — HTML output, JSON Patch API
- `/ai-radija-tracker-jira` — ADF format, REST API v3
- `/ai-radija-tracker-github` — Markdown, `gh` CLI
- `/ai-radija-tracker-linear` — Markdown, GraphQL API
- `/ai-radija-tracker-notion` — Notion blocks, REST API or MCP
- **Markdown file** — write to `specs/<feature>/plan.md` with heading levels for hierarchy

### Two-Phase Strategy (for backlogs with >15 items)

When the backlog has more than 15 work items:

**Phase 1 — Create structure**: create all work items with title and hierarchy only (Epic → Features → Stories → Tasks). Goal: get the tree on the board quickly.

**Phase 2 — Enrich in batches**: go back to each level and add detailed specifications in batches of 4-6 items. This avoids timeouts and allows incremental review.

Always ask the user: "This backlog has N items. Want me to use the two-phase strategy (structure first, then enrich in batches)?"

After creation, remind the developer:

- Every PR should reference the relevant issue/ticket
- Update progress as work advances
- Run tests before opening any PR
- Branch naming should follow project conventions

---

## Step 4 — QA Test Cases (when implementation is ready)

When the user indicates the feature is ready for QA, generate test cases derived from the **TDD section** of each User Story:

| ID | Title | Preconditions | Steps | Expected Result | Status |
|----|-------|---------------|-------|-----------------|--------|
| TC-001 | [title] | [setup] | [steps] | [expected] | Pending |

Include happy path, edge cases, and error cases. Cross-reference with each story's TDD scenarios.

---

## Step 5 — QA Feedback and Bug Resolution

When the user provides QA results:

1. Identify all failed cases
2. Create a bug report for each: title, steps to reproduce, expected vs actual
3. Diagnose and fix each bug, reporting what changed
