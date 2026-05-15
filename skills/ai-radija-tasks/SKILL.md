---
description: Generate an actionable, dependency-ordered task list organized by user stories from the feature spec and plan. Use when user wants to create tasks, generate a task list, break down implementation, or mentions "tasks".
user-invocable: true
disable-model-invocation: false
---

# Tasks — Task Generation

Generate an actionable, dependency-ordered task list for a feature based on available design artifacts.

---

## Template Resolution

This skill uses a tasks template for generating the task list:
1. Check `specs/.templates/tasks-template.md` in the project root (project custom)
2. If the user provided a template in the prompt, use that
3. Fall back to the **Default Tasks Template** at the end of this file

---

## Workflow

### Step 1 — Locate Feature

1. Check `specs/feature.json` for the active feature directory
2. If not found, scan `specs/` for the most recent feature directory
3. Load design documents from the feature directory:
   - **Required**: `plan.md` (tech stack, libraries, structure), `spec.md` (user stories with priorities)
   - **Optional**: `data-model.md`, `contracts/`, `research.md`, `quickstart.md`

### Step 2 — Execute Task Generation

1. Extract tech stack, libraries, project structure from `plan.md`
2. Extract user stories with priorities (P1, P2, P3...) from `spec.md`
3. If `data-model.md` exists: map entities to user stories
4. If `contracts/` exists: map interface contracts to user stories
5. If `research.md` exists: extract decisions for setup tasks
6. Generate tasks organized by user story
7. Generate dependency graph

### Step 3 — Write tasks.md

Write to `<feature-dir>/tasks.md` using the resolved template:
- Phase 1: Setup tasks (project initialization)
- Phase 2: Foundational tasks (blocking prerequisites for all user stories)
- Phase 3+: One phase per user story (in priority order)
- Final Phase: Polish & cross-cutting concerns
- Dependencies section
- Parallel execution opportunities

### Step 4 — Report

Output:
- Path to generated `tasks.md`
- Total task count and count per user story
- Parallel opportunities identified
- Suggested MVP scope (typically User Story 1)
- Suggest next step: `/ai-radija-tdd` to create test plan, or `/ai-radija-analyze` for consistency check

---

## Task Format (REQUIRED)

Every task MUST follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Components**:
1. **Checkbox**: `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential — T001, T002, T003...
3. **[P] marker**: Include ONLY if parallelizable (different files, no dependencies)
4. **[Story] label**: `[US1]`, `[US2]`... REQUIRED in user story phases, omit in Setup/Foundational/Polish
5. **Description**: Clear action with exact file path

**Examples**:
- `- [ ] T001 Create project structure per implementation plan`
- `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- `- [ ] T012 [P] [US1] Create User model in src/models/user.py`

**Tests are OPTIONAL** — include only if explicitly requested.

---

## Task Organization Rules

1. **From User Stories (spec.md)** — PRIMARY:
   - Each user story gets its own phase
   - Map all related components to their story
   - Mark story dependencies

2. **From Contracts**: Map each interface contract to the user story it serves

3. **From Data Model**: Map entities to user stories; shared entities go in Setup phase

4. **From Setup/Infrastructure**: Shared infra → Setup; foundational → Phase 2; story-specific → within story

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites — MUST complete before user stories)
- **Phase 3+**: User Stories in priority order (each independently testable)
- **Final Phase**: Polish & Cross-Cutting Concerns

---

## Default Tasks Template

```markdown
# Tasks: [FEATURE NAME]

**Input**: Design documents from `specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

## Task Format

- [ ] [ID] [P?] [Story?] Description with exact file path

---

## Phase 1: Setup

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize project with dependencies
- [ ] T003 [P] Configure linting and formatting

---

## Phase 2: Foundational

**BLOCKS all user stories — must complete first.**

- [ ] T004 Setup database schema and migrations
- [ ] T005 [P] Implement auth framework
- [ ] T006 [P] Setup API routing and middleware

**Checkpoint**: Foundation ready — user stories can begin.

---

## Phase 3: User Story 1 — [Title] (P1) MVP

**Goal**: [What this story delivers]
**Independent Test**: [How to verify in isolation]

- [ ] T010 [P] [US1] Create [Entity] model in src/models/[entity]
- [ ] T011 [US1] Implement [Service] in src/services/[service]
- [ ] T012 [US1] Implement [endpoint] in src/[location]/[file]

**Checkpoint**: US1 functional and independently testable.

---

## Phase N: Polish & Cross-Cutting

- [ ] TXXX [P] Documentation updates
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Security hardening

---

## Dependencies

1. **Setup** → no dependencies
2. **Foundational** → depends on Setup — blocks all stories
3. **User Stories** → depend on Foundational — can run in parallel
4. **Polish** → depends on all stories complete

## Execution Strategy

**MVP First**: Setup → Foundational → US1 → STOP & VALIDATE → Deploy
**Incremental**: Each story adds value without breaking previous stories.
```
