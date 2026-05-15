---
description: Create a PRD through user interview, codebase exploration, and module design. Outputs a structured requirements document. Use when user wants to write a PRD, create a product requirements document, specify a new feature, or plan a new capability.
user-invocable: true
disable-model-invocation: false
---

# Write a PRD

Create a PRD through user interview, codebase exploration, and module design.

You may skip steps if the context makes them unnecessary.

## Step 0 — Scope Check

If the repository has a `CLAUDE.md` with a `## Module Scope` section:

1. Evaluate whether the request falls within the declared scope
2. If out of scope: stop and tell the user which module/repo owns this functionality
3. If in scope or no scope section exists: continue

---

## Steps

1. **Gather context** — ask for a detailed description of the problem to solve and potential solutions.

2. **Explore the repo** — read relevant source files, docs, specs, and READMEs to understand the current state.

3. **Interview the user** — ask hard questions about every aspect of the plan until reaching shared understanding. Walk each branch of the design tree, resolving dependencies one by one.

4. **Design modules** — sketch the major modules to build or modify. Look for opportunities to extract deep modules (small interface, large implementation, easy to test in isolation). Confirm with the user which modules need tests.

5. **Scope check** — for each new entity or data point: confirm whether the data is global or scoped (per-tenant, per-user, per-org). If scoped, confirm filtering at every layer.

6. **Write the PRD** using the template below.

---

## PRD Template

```markdown
## Problem Statement

The problem from the user's perspective.

## Solution

The proposed solution from the user's perspective.

## User Stories

Use the **6-section format** for each story that will be implemented directly:

### Story 1 — [Title]

**Objective**: What this story delivers from a business perspective.

**Description**: Technical and functional context.

**TDD**:
- Given [precondition], When [action], Then [expected]
- Given [precondition], When [action], Then [expected]
- Given [error case], When [action], Then [expected]

**Example**: Textual UI mockup, navigation flow, or API payload/response.

**Technical Analysis**: Components affected, patterns, endpoints, dependencies, risks.

**Business Analysis**: Business impact, implicit rules, alternative use cases, formal acceptance.

---

(Repeat for each story. Cover all actors and edge cases. Aim for completeness.)

## Implementation Decisions

- Modules to build/modify
- Interface contracts between modules
- Architectural decisions
- Schema changes (and whether they are global or scoped)
- API contracts

Do NOT include specific file paths or code snippets.

## Testing Decisions

- What makes a good test in this context (behavior, not implementation)
- Which modules will be tested
- Prior art in the codebase (similar tests to reference)

## Out of Scope

What is explicitly excluded from this PRD.

## Further Notes

Any additional context, constraints, or open questions.
```

---

## Output

Write the PRD to the feature's spec directory (e.g., `specs/<feature>/prd.md`) or present it for the user to place where appropriate.

After approval, suggest: "To create work items from this PRD with full specifications (Epic, Features, Stories with TDD scenarios, Tasks with code examples), use `/ai-radija-prd-to-issues`. It supports Azure DevOps, Jira, GitHub Issues, Linear, Notion, or plain markdown."
