---
description: Perform a non-destructive cross-artifact consistency and quality analysis across spec.md, plan.md, and tasks.md. Identifies inconsistencies, duplications, and coverage gaps. Use when user wants to analyze consistency, check for gaps, validate artifacts, or mentions "analyze".
user-invocable: true
disable-model-invocation: false
---

# Analyze — Consistency Analysis

Identify inconsistencies, duplications, ambiguities, and underspecified items across spec.md, plan.md, and tasks.md before implementation.

**STRICTLY READ-ONLY**: Do NOT modify any files. Output a structured analysis report.

---

## Workflow

### Step 1 — Load Artifacts

1. Check `specs/feature.json` for the active feature directory
2. Load required files (abort if missing):
   - `spec.md` — requirements, user stories, success criteria
   - `plan.md` — architecture, data model, phases
   - `tasks.md` — task IDs, descriptions, phases, parallel markers
3. Load optional: `specs/memory/constitution.md` for principle validation

### Step 2 — Build Semantic Models

Create internal representations (don't output raw artifacts):
- **Requirements inventory**: FR-### and SC-### identifiers
- **User story/action inventory**: discrete actions with acceptance criteria
- **Task coverage mapping**: map each task to requirements/stories
- **Constitution rule set**: extract MUST/SHOULD statements

### Step 3 — Detection Passes

Limit to 50 findings total.

**A. Duplication Detection**
- Near-duplicate requirements → mark lower-quality for consolidation

**B. Ambiguity Detection**
- Vague adjectives (fast, scalable, secure) lacking measurable criteria
- Unresolved placeholders (TODO, ???, `<placeholder>`)

**C. Underspecification**
- Requirements with verbs but missing measurable outcome
- User stories missing acceptance criteria
- Tasks referencing undefined components

**D. Constitution Alignment**
- Any conflict with MUST principles → automatically CRITICAL
- Missing mandated sections or quality gates

**E. Coverage Gaps**
- Requirements with zero associated tasks
- Tasks with no mapped requirement/story
- Success Criteria requiring buildable work not reflected in tasks

**F. Inconsistency**
- Terminology drift across files
- Data entities in plan but absent in spec (or vice versa)
- Task ordering contradictions
- Conflicting requirements

### Step 4 — Severity Assignment

- **CRITICAL**: Violates constitution MUST, missing core artifact, zero-coverage requirement blocking baseline
- **HIGH**: Duplicate/conflicting requirement, ambiguous security/performance, untestable criterion
- **MEDIUM**: Terminology drift, missing non-functional coverage, underspecified edge case
- **LOW**: Style/wording improvements, minor redundancy

### Step 5 — Produce Report

Output Markdown report:

```markdown
## Specification Analysis Report

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md:L120 | ... | Merge phrasing |

**Coverage Summary:**

| Requirement Key | Has Task? | Task IDs | Notes |
|-----------------|-----------|----------|-------|

**Metrics:**
- Total Requirements / Total Tasks / Coverage %
- Ambiguity Count / Duplication Count / Critical Issues
```

### Step 6 — Next Actions

- If CRITICAL issues: recommend resolving before `/ai-radija-implement`
- If only LOW/MEDIUM: user may proceed with improvement suggestions
- Suggest specific commands: `/ai-radija-specify` for spec refinement, `/ai-radija-plan` for architecture adjustment
- Ask: "Would you like me to suggest concrete remediation edits for the top N issues?" (do NOT apply automatically)
