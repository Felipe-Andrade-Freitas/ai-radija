---
description: Execute the implementation planning workflow to generate technical design artifacts from a feature specification. Creates research, data model, contracts, and project structure. Use when user wants to plan implementation, create a technical plan, design architecture, or mentions "plan".
user-invocable: true
disable-model-invocation: false
---

# Plan — Implementation Planning

Translate a feature specification into technical decisions, project structure, and design artifacts.

---

## Template Resolution

This skill uses a plan template for generating the implementation plan:
1. Check `specs/.templates/plan-template.md` in the project root (project custom)
2. If the user provided a template in the prompt, use that
3. Fall back to the **Default Plan Template** at the end of this file

---

## Workflow

### Step 1 — Locate Feature

1. Check `specs/feature.json` for the active feature directory
2. If not found, scan `specs/` for the most recent feature directory
3. If still not found, ask the user which feature to plan
4. Read the feature spec (`spec.md`) and any existing constitution (`specs/memory/constitution.md`)

### Step 2 — Create Plan File

Copy the resolved plan template to `<feature-dir>/plan.md`.

### Step 3 — Fill Technical Context

Complete the Technical Context table:

| Dimension | Value |
|-----------|-------|
| Language/Version | [e.g., Python 3.11, Rust 1.75 or NEEDS CLARIFICATION] |
| Dependencies | [e.g., FastAPI, UIKit or NEEDS CLARIFICATION] |
| Storage | [e.g., PostgreSQL, files or N/A] |
| Testing | [e.g., pytest, xUnit or NEEDS CLARIFICATION] |
| Platform | [e.g., Linux server, iOS 15+ or NEEDS CLARIFICATION] |
| Project Type | [library / cli / web-service / mobile-app / desktop-app] |
| Performance | [e.g., 1000 req/s, 60 fps or NEEDS CLARIFICATION] |
| Constraints | [e.g., <200ms p95, offline-capable or NEEDS CLARIFICATION] |
| Scale | [e.g., 10k users, 50 screens or NEEDS CLARIFICATION] |

If constitution exists, fill Constitution Check section.

### Phase 0 — Research

For each NEEDS CLARIFICATION in Technical Context:
1. Research the unknown in the codebase and docs
2. For each technology choice, find best practices
3. Consolidate findings in `<feature-dir>/research.md`:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: `research.md` with all NEEDS CLARIFICATION resolved

### Phase 1 — Design & Contracts

**Prerequisites**: `research.md` complete

1. **Data Model** → `<feature-dir>/data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Interface Contracts** (if project has external interfaces) → `<feature-dir>/contracts/`:
   - Identify interfaces the project exposes
   - Document contract format appropriate for project type
   - Examples: public APIs for libraries, endpoints for web services, CLI schemas

3. **Project Structure** → choose and document in plan.md:
   - Single project, web app (frontend + backend), mobile + API, etc.
   - Map source code structure

4. **Update agent context**: Update the plan reference in `CLAUDE.md` (or `AGENTS.md` for Codex/Antigravity)

**Output**: `data-model.md`, `contracts/*`, updated plan.md

### Step 4 — Report

Report to user:
- Branch and plan file path
- Generated artifacts list
- Suggest next step: `/ai-radija-tasks` to generate task list

---

## Key Rules

- Use absolute paths for filesystem operations
- Use project-relative paths for references in documentation
- ERROR on gate failures or unresolved clarifications
- Plan ends after Phase 1 — implementation is a separate step

---

## Default Plan Template

```markdown
# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

## Summary

[Primary requirement from spec + technical approach chosen after research]

## Technical Context

| Dimension | Value |
|-----------|-------|
| **Language/Version** | [e.g., Python 3.11] |
| **Dependencies** | [e.g., FastAPI, UIKit] |
| **Storage** | [e.g., PostgreSQL, files or N/A] |
| **Testing** | [e.g., pytest, xUnit] |
| **Platform** | [e.g., Linux server, iOS 15+] |
| **Project Type** | [library / cli / web-service / mobile-app / desktop-app] |
| **Performance** | [e.g., 1000 req/s, 60 fps] |
| **Constraints** | [e.g., <200ms p95, offline-capable] |
| **Scale** | [e.g., 10k users, 50 screens] |

## Constitution Check

*GATE: Must pass before Phase 0. Re-check after Phase 1.*

[Gates determined from constitution file]

## Project Structure

### Feature Documentation

specs/[###-feature]/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md

### Source Code

[Selected structure with rationale]

## Complexity Tracking

Fill ONLY if Constitution Check has violations that must be justified.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| | | |
```
