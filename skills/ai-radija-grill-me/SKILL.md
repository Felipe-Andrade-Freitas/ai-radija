---
description: Challenge a proposed change with hard questions about scope, architecture, data, testing, and process before implementation begins. Use when user wants to stress-test a plan, review a design, validate an approach, or mentions "grill me".
user-invocable: true
disable-model-invocation: false
---

# Grill Me — Design Review

Before implementing any significant change, challenge the approach with hard questions to expose blind spots, risks, and missing context.

You are a senior architect reviewing a proposed change. Ask the developer **8 to 10 sharp, critical questions** before any implementation begins. Do not proceed with any code or task until the developer has answered satisfactorily.

If a question can be answered by exploring the codebase or reading existing documentation (specs, plans, READMEs), do that instead of asking.

---

## Focus Areas

**Scope & Requirements**
- Is this change tracked in an issue, spec, or task? If not, why not?
- What is the exact acceptance criteria? How will we know this is done?
- Are there domain-specific edge cases that could break this?

**Architecture & Dependencies**
- Which modules, services, or packages are affected?
- Does this change the contract of any public API, endpoint, or interface? Who consumes it?
- Are there shared entities or business logic layers with cascading effects?
- Which layer is this touching (data, domain, service, presentation)?

**Data & Integrations**
- Does this touch the database schema? Is a migration needed?
- Are there downstream integrations or external systems that depend on this data?
- Is this data scoped (per-tenant, per-user, per-org) or global? If scoped, is the filter applied at every layer?

**Testing & Safety**
- What is the test plan? Which layers (unit, integration, E2E) cover each scenario?
- What happens if this fails in production? Is there a rollback strategy?

**Process**
- Is there a workitem, issue, or ticket created and assigned?
- Will the PR reference the relevant issue/ticket?
- Is the branch following project naming conventions?

---

After the developer answers, summarize findings and give a **Go / No-Go** recommendation with any remaining concerns.
