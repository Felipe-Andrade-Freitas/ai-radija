---
description: Identify underspecified areas in the current feature spec by asking up to 5 targeted clarification questions and encoding answers back into the spec. Use when user wants to clarify requirements, reduce ambiguity, refine a spec, or mentions "clarify".
user-invocable: true
disable-model-invocation: false
---

# Clarify — Spec Clarification

Detect and reduce ambiguity or missing decision points in the active feature specification. Record clarifications directly in the spec file.

**Run this BEFORE `/ai-radija-plan`**. Skipping increases downstream rework risk.

---

## Workflow

### Step 1 — Locate Feature Spec

1. Check `specs/feature.json` for the active feature directory
2. Read the spec file (`spec.md`)
3. If spec is missing, instruct user to run `/ai-radija-specify` first

### Step 2 — Ambiguity & Coverage Scan

Perform a structured scan using this taxonomy. For each category, mark: Clear / Partial / Missing.

**Categories:**
- **Functional Scope & Behavior**: core user goals, out-of-scope declarations, role differentiation
- **Domain & Data Model**: entities, attributes, relationships, identity rules, state transitions, scale
- **Interaction & UX Flow**: critical journeys, error/empty/loading states, accessibility
- **Non-Functional Quality**: performance, scalability, reliability, observability, security, compliance
- **Integration & External Dependencies**: external APIs, data formats, protocol/versioning
- **Edge Cases & Failure Handling**: negative scenarios, rate limiting, conflict resolution
- **Constraints & Tradeoffs**: technical constraints, rejected alternatives
- **Terminology & Consistency**: canonical terms, avoided synonyms
- **Completion Signals**: acceptance criteria testability, Definition of Done indicators
- **Misc / Placeholders**: TODO markers, vague adjectives lacking quantification

### Step 3 — Generate Clarification Questions (max 5)

From the scan, generate a prioritized queue:
- Maximum 5 total questions across the session
- Each question must be answerable with:
  - Multiple-choice (2-5 options), OR
  - Short answer (<=5 words)
- Only include questions that materially impact architecture, data modeling, task decomposition, test design, UX, or compliance
- Favor clarifications that reduce downstream rework risk

### Step 4 — Sequential Questioning Loop

Present **ONE question at a time**:

**For multiple-choice:**
- Analyze all options and determine the most suitable
- Present recommendation prominently: `**Recommended:** Option [X] - <reasoning>`
- Render options as a table:

  | Option | Description |
  |--------|-------------|
  | A | [Option A] |
  | B | [Option B] |
  | C | [Option C] |

- "Reply with the option letter, accept recommendation by saying 'yes', or provide your own answer."

**For short-answer:**
- Provide suggested answer: `**Suggested:** <answer> - <reasoning>`
- "Accept by saying 'yes' or provide your own answer (<=5 words)."

**Stop when:**
- All critical ambiguities resolved
- User signals completion ("done", "good", "no more")
- You reach 5 questions

### Step 5 — Integrate Answers (after EACH answer)

1. Ensure a `## Clarifications` section exists in the spec (create after overview section if missing)
2. Add `### Session YYYY-MM-DD` subheading for today
3. Append: `- Q: <question> → A: <answer>`
4. Apply clarification to the appropriate section:
   - Functional → update Functional Requirements
   - Data → update Data Model/Key Entities
   - Non-functional → add measurable criteria to Success Criteria
   - Edge case → add to Edge Cases section
   - Terminology → normalize across spec
5. If clarification invalidates earlier text, **replace** (don't duplicate)
6. **Save spec after each integration** (atomic overwrite)

### Step 6 — Report

- Number of questions asked & answered
- Path to updated spec
- Sections touched
- Coverage summary table:

  | Category | Status |
  |----------|--------|
  | Functional Scope | Resolved |
  | Data Model | Clear |
  | Security | Deferred |

- If Outstanding or Deferred remain, recommend next step:
  - `/ai-radija-plan` to proceed
  - `/ai-radija-clarify` again later

---

## Rules

- Never exceed 5 total questions
- Never reveal future queued questions in advance
- If no meaningful ambiguities found: "No critical ambiguities detected." and suggest proceeding
- Respect user early termination signals
- Avoid speculative tech stack questions unless blocking functional clarity
