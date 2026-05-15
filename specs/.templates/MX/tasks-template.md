<!-- Template: tasks-template.md -->
<!-- Used by: /ai-radija-tasks -->
<!-- Resolution: specs/.templates/tasks-template.md (project) > prompt-provided > skill default -->
<!-- Customize: Adjust phases, task format, checkpoint criteria to match your workflow -->

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
