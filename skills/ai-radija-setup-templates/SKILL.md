---
description: Set up custom project templates for spec-driven development skills. Creates specs/.templates/ with default .md files for specify, plan, tasks, constitution, and checklist. Use when user wants to configure templates, customize artifacts, or when no specs/.templates/ directory exists at session start.
user-invocable: true
disable-model-invocation: true
---

# Setup Templates — Project Template Configuration

Initialize and customize the artifact templates used by spec-driven development skills. Creates `specs/.templates/` with editable defaults so teams can enforce their own conventions.

---

## Proactive Trigger

**At the start of every session**, check if `specs/.templates/` exists in the project root.
If it does NOT exist, suggest to the user:

> I noticed this project doesn't have custom templates configured yet. Want me to set them up? Run `/ai-radija-setup-templates` to create editable templates for spec, plan, tasks, constitution, and checklist artifacts.

---

## Workflow

### Step 1 — Detect Existing Templates

1. Check if `specs/.templates/` directory exists in the project root
2. If it exists, list which template files are present:
   - `spec-template.md`
   - `plan-template.md`
   - `tasks-template.md`
   - `constitution-template.md`
   - `checklist-template.md`
3. Report status to user:
   - **No directory**: "No custom templates found. I'll create all 5 defaults."
   - **Partial**: "Found X of 5 templates. Want me to create the missing ones?"
   - **Complete**: "All 5 templates already exist. Want to reset any to defaults?"

### Step 2 — Ask User Preferences

Present a quick configuration menu:

```
Which templates do you want to set up?

1. All (recommended for new projects)
2. Select specific:
   - [S] spec-template.md     — used by /ai-radija-specify
   - [P] plan-template.md     — used by /ai-radija-plan
   - [T] tasks-template.md    — used by /ai-radija-tasks
   - [C] constitution-template.md — used by /ai-radija-constitution
   - [K] checklist-template.md — used by /ai-radija-checklist

3. Skip (use embedded defaults from skills)
```

If user chooses "All" or doesn't specify, create all 5.

### Step 3 — Create Template Files

1. Create `specs/.templates/` directory if it doesn't exist
2. For each selected template, copy from the plugin's `templates/` directory (source of truth) into `specs/.templates/`
3. If the plugin `templates/` directory is not accessible, use the **Default Templates** section at the end of this file as fallback
4. Each file includes a header comment explaining how it's used and how to customize

### Step 4 — Guide Customization

After creating files, present customization suggestions based on the project:

1. **Scan the project** for conventions:
   - Check existing docs for naming patterns
   - Look at existing specs/ content for style
   - Detect language/framework from package.json, pom.xml, build.gradle, etc.
2. **Suggest edits** such as:
   - Adding project-specific sections (e.g., "Security Considerations" for fintech)
   - Adjusting priority labels (P0-P3 vs P1-P3)
   - Adding team-specific fields (e.g., "Squad Owner", "Design Link")
   - Adjusting acceptance criteria format to match team's testing style
3. Ask: "Want me to apply any of these suggestions, or will you customize manually?"

### Step 5 — Report Completion

Report:
- List of created/updated template files with paths
- Remind user: "These templates will be used automatically by specify, plan, tasks, constitution, and checklist skills"
- Suggest next step: "Try `/ai-radija-specify` to create your first spec using the new templates"

---

## Guidelines

- Never overwrite existing templates without explicit user confirmation
- Always show a diff preview before overwriting
- Templates should be self-documenting with inline comments
- Keep templates framework-agnostic unless the user requests otherwise
- The header comment in each template MUST explain the template resolution order

---

## Default Templates

### spec-template.md

```markdown
<!-- Template: spec-template.md -->
<!-- Used by: /ai-radija-specify -->
<!-- Resolution: This file > prompt-provided > skill default -->
<!-- Customize: Edit sections, add fields, change format to match your team's conventions -->

# Feature Specification: [FEATURE NAME]

**Branch**: `[###-feature-name]` | **Created**: [DATE] | **Status**: Draft

## User Scenarios & Testing

User stories are prioritized journeys. Each MUST be independently testable.

### User Story 1 — [Brief Title] (P1)

[User journey in plain language]

**Why P1**: [Value and priority rationale]

**Independent Test**: [How to test this story alone]

**Acceptance Scenarios**:

1. **Given** [state], **When** [action], **Then** [outcome]
2. **Given** [state], **When** [action], **Then** [outcome]

---

### User Story 2 — [Brief Title] (P2)

[User journey in plain language]

**Why P2**: [Value and priority rationale]

**Independent Test**: [How to test this story alone]

**Acceptance Scenarios**:

1. **Given** [state], **When** [action], **Then** [outcome]

---

### Edge Cases

- What happens when [boundary condition]?
- How does the system handle [error scenario]?

## Requirements

### Functional Requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: System MUST [specific capability]

### Key Entities

Include only if the feature involves data.

- **[Entity 1]**: [What it represents, key attributes]
- **[Entity 2]**: [What it represents, relationships]

## Success Criteria

Measurable, technology-agnostic outcomes only.

- **SC-001**: [User-facing metric]
- **SC-002**: [Scale metric]
- **SC-003**: [Quality metric]

## Assumptions

- [Target users assumption]
- [Scope boundary assumption]
- [Dependency on existing system/service]
```

### plan-template.md

```markdown
<!-- Template: plan-template.md -->
<!-- Used by: /ai-radija-plan -->
<!-- Resolution: This file > prompt-provided > skill default -->
<!-- Customize: Add sections for your architecture patterns, deployment strategy, etc. -->

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

### tasks-template.md

```markdown
<!-- Template: tasks-template.md -->
<!-- Used by: /ai-radija-tasks -->
<!-- Resolution: This file > prompt-provided > skill default -->
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
```

### constitution-template.md

```markdown
<!-- Template: constitution-template.md -->
<!-- Used by: /ai-radija-constitution -->
<!-- Resolution: This file > prompt-provided > skill default -->
<!-- Customize: Define your project's non-negotiable principles and governance rules -->

# [PROJECT_NAME] Constitution

## Core Principles

### [PRINCIPLE_1_NAME]

[PRINCIPLE_1_DESCRIPTION]

### [PRINCIPLE_2_NAME]

[PRINCIPLE_2_DESCRIPTION]

### [PRINCIPLE_3_NAME]

[PRINCIPLE_3_DESCRIPTION]

### [PRINCIPLE_4_NAME]

[PRINCIPLE_4_DESCRIPTION]

### [PRINCIPLE_5_NAME]

[PRINCIPLE_5_DESCRIPTION]

Add or remove principles as needed. Each principle MUST be declarative, testable, and use MUST/SHOULD language.

## [SECTION_2_NAME]

[SECTION_2_CONTENT]

## [SECTION_3_NAME]

[SECTION_3_CONTENT]

## Governance

[GOVERNANCE_RULES]

- Constitution supersedes all other practices
- Amendments require documentation, approval, and migration plan
- All PRs/reviews MUST verify compliance
- Complexity MUST be justified against simpler alternatives

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]

Versioning: MAJOR = principle removal/redefinition, MINOR = new principle/section, PATCH = clarifications/typos.
```

### checklist-template.md

```markdown
<!-- Template: checklist-template.md -->
<!-- Used by: /ai-radija-checklist -->
<!-- Resolution: This file > prompt-provided > skill default -->
<!-- Customize: Add domain-specific quality dimensions relevant to your project -->

# [CHECKLIST TYPE] Checklist: [FEATURE NAME]

**Purpose**: [What this checklist validates] | **Created**: [DATE] | **Feature**: [link to spec.md]

## [Category 1]

- [ ] CHK001 [Requirement quality question] [Quality dimension, Spec section]
- [ ] CHK002 [Requirement quality question] [Quality dimension]
- [ ] CHK003 [Requirement quality question] [Gap]

## [Category 2]

- [ ] CHK004 [Requirement quality question] [Quality dimension, Spec section]
- [ ] CHK005 [Requirement quality question] [Quality dimension]

## Notes

- Check items off as completed: `[x]`
- Items numbered sequentially (CHK001, CHK002...) across categories
```
