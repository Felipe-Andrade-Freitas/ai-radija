---
description: Generate custom checklists that validate requirements quality (completeness, clarity, consistency). Checklists are "unit tests for English" — they test the spec, not the implementation. Use when user wants to create a checklist, validate requirements quality, or mentions "checklist".
user-invocable: true
disable-model-invocation: false
---

# Checklist — Requirements Quality Validation

Generate custom checklists that validate the quality of requirements — completeness, clarity, consistency, and measurability.

**CORE CONCEPT**: Checklists are **UNIT TESTS FOR REQUIREMENTS WRITING** — they validate that requirements are well-written and ready for implementation, NOT that the implementation works.

---

## Template Resolution

This skill uses a checklist template:
1. Check `specs/.templates/checklist-template.md` in the project root (project custom)
2. If the user provided a template in the prompt, use that
3. Fall back to the **Default Checklist Template** at the end of this file

---

## Workflow

### Step 1 — Locate Feature

1. Check `specs/feature.json` for the active feature directory
2. Load from feature directory: `spec.md`, `plan.md` (if exists), `tasks.md` (if exists)

### Step 2 — Clarify Intent

Derive up to THREE contextual clarifying questions:
- Generated from user's phrasing + signals from spec/plan/tasks
- Only ask about info that materially changes checklist content
- Skip if already clear from arguments

Question archetypes:
- Scope refinement: "Include integration touchpoints or local module only?"
- Risk prioritization: "Which risk areas need mandatory gating?"
- Depth calibration: "Lightweight pre-commit or formal release gate?"
- Audience framing: "Author only or peer review?"

### Step 3 — Generate Checklist

Create `<feature-dir>/checklists/<domain>.md` (e.g., `ux.md`, `api.md`, `security.md`)

**If file exists**: append new items, continuing from last CHK ID
**If new file**: start from CHK001

**Categories** — group items by requirement quality dimensions:
- **Requirement Completeness**: Are all necessary requirements present?
- **Requirement Clarity**: Are requirements specific and unambiguous?
- **Requirement Consistency**: Do requirements align without conflicts?
- **Acceptance Criteria Quality**: Are success criteria measurable?
- **Scenario Coverage**: Are all flows/cases addressed?
- **Edge Case Coverage**: Are boundary conditions defined?
- **Non-Functional Requirements**: Performance, security, accessibility specified?
- **Dependencies & Assumptions**: Documented and validated?

**REQUIRED PATTERNS** (test requirements quality):
- "Are [requirement type] defined/specified/documented for [scenario]?"
- "Is [vague term] quantified/clarified with specific criteria?"
- "Are requirements consistent between [section A] and [section B]?"
- "Can [requirement] be objectively measured/verified?"
- "Does the spec define [missing aspect]?"

**PROHIBITED** (test implementation, NOT requirements):
- "Verify the button clicks correctly"
- "Test error handling works"
- "Confirm the API returns 200"

**Item format**: `- [ ] CHK### <requirement quality question> [Quality dimension, Spec §X.Y]`

**Traceability**: >=80% of items MUST include a reference: `[Spec §X.Y]`, `[Gap]`, `[Ambiguity]`, `[Conflict]`

Soft cap: 40 items. Merge near-duplicates. Aggregate low-impact edge cases.

### Step 4 — Report

- Full path to checklist file
- Item count
- Focus areas, depth level
- Whether file was created or appended

---

## Examples

**Good** (testing requirements):
- "Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]"
- "Are hover state requirements consistently defined for all interactive elements? [Consistency]"
- "Is fallback behavior defined when images fail to load? [Edge Case, Gap]"

**Bad** (testing implementation):
- "Verify landing page displays 3 episode cards"
- "Test hover states work correctly on desktop"
- "Confirm logo click navigates to home page"

---

## Default Checklist Template

```markdown
# [CHECKLIST TYPE] Checklist: [FEATURE NAME]

**Purpose**: [What this checklist validates] | **Created**: [DATE] | **Feature**: [link to spec.md]

## [Category 1]

- [ ] CHK001 [Requirement quality question] [Quality dimension, Spec §X.Y]
- [ ] CHK002 [Requirement quality question] [Quality dimension]
- [ ] CHK003 [Requirement quality question] [Gap]

## [Category 2]

- [ ] CHK004 [Requirement quality question] [Quality dimension, Spec §X.Y]
- [ ] CHK005 [Requirement quality question] [Quality dimension]

## Notes

- Check items off as completed: `[x]`
- Items numbered sequentially (CHK001, CHK002...) across categories
```
