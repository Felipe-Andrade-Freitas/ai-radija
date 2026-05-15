---
description: Create or update the project constitution — non-negotiable principles, constraints, and governance rules that gate all design and implementation. Use when user wants to define project principles, create governance rules, update constitution, or mentions "constitution".
user-invocable: true
disable-model-invocation: false
---

# Constitution — Project Governance

Create or update the project constitution at `specs/memory/constitution.md`. This file defines non-negotiable principles that gate all design and implementation decisions.

---

## Template Resolution

This skill uses a constitution template:
1. Check `specs/.templates/constitution-template.md` in the project root (project custom)
2. If the user provided a template in the prompt, use that
3. Fall back to the **Default Constitution Template** at the end of this file

---

## Workflow

### Step 1 — Load or Initialize

1. Check if `specs/memory/constitution.md` exists
2. If not, create it from the resolved template
3. Identify every placeholder token (`[ALL_CAPS_IDENTIFIER]`)

### Step 2 — Collect Values

For each placeholder:
- If user input supplies a value, use it
- Otherwise infer from repo context (README, docs, prior constitution)
- `RATIFICATION_DATE`: original adoption date (ask if unknown)
- `LAST_AMENDED_DATE`: today if changes are made
- `CONSTITUTION_VERSION`: increment per semantic versioning:
  - MAJOR: principle removal/redefinition
  - MINOR: new principle/section added
  - PATCH: clarifications, typo fixes

### Step 3 — Draft Updated Constitution

- Replace every placeholder with concrete text
- Each Principle: succinct name, non-negotiable rules, explicit rationale
- Use MUST/SHOULD language — no vague "should try to"
- Governance section: amendment procedure, versioning policy, compliance review

### Step 4 — Consistency Propagation

Check alignment with other artifacts:
- `specs/.templates/plan-template.md` → Constitution Check section aligns
- `specs/.templates/spec-template.md` → mandatory sections match principles
- `specs/.templates/tasks-template.md` → task types reflect principles

### Step 5 — Sync Impact Report

Add as comment at top of constitution:
- Version change: old → new
- Modified principles
- Added/removed sections
- Templates requiring updates

### Step 6 — Validate and Write

- No remaining unexplained bracket tokens
- Version line matches report
- Dates in ISO format (YYYY-MM-DD)
- Principles are declarative, testable, no vague language
- Write to `specs/memory/constitution.md`

### Step 7 — Report

- New version and bump rationale
- Files flagged for follow-up
- Suggested commit message

---

## Default Constitution Template

```markdown
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
