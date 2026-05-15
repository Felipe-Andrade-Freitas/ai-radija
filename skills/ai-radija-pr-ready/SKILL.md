---
description: Validate that a branch is ready for pull request and generate a properly formatted PR. Use when user wants to create a PR, open a pull request, validate branch readiness, or mentions "pr-ready".
user-invocable: true
disable-model-invocation: false
---

# PR Ready

Validate that a branch is ready for PR and generate a properly formatted pull request.

Before creating any PR, run through the preflight checklist and **stop if any item fails**. Ask the developer to fix blockers before proceeding.

---

## Step 1 — Pre-flight Checklist

Check the following and report status for each:

**Issue linkage**
- [ ] Issue/ticket exists for this work
- [ ] Issue ID is known — will be referenced in the PR

**Code quality**
- [ ] Tests pass (detect test command from project: `npm test`, `pytest`, `dotnet test`, `cargo test`, `go test`, etc.)
- [ ] No commented-out code or debug leftovers
- [ ] No hardcoded secrets, connection strings, or environment values

**Branch**
- [ ] Branch name follows project conventions
- [ ] Branch is up to date with the target branch (no conflicts)

**Documentation**
- [ ] Issue/ticket has acceptance criteria
- [ ] Relevant docs are updated if behavior changed

---

## Step 2 — Generate PR

Ask for:
1. **Issue/ticket ID** (if not already identified)
2. **Short summary** of what changed and why
3. **Testing done** — manual or automated tests performed
4. **Breaking changes** — API changes, schema migrations, config changes

Then generate the PR body:

```markdown
## Summary

[Issue reference]

[Short description of changes]

## Changes

- [change 1]
- [change 2]

## Testing

- [test 1]
- [test 2]

## Breaking Changes

[none | list any breaking changes]

## Checklist

- [ ] Tests pass
- [ ] No hardcoded secrets
- [ ] Issue/ticket updated
- [ ] Reviewed by at least one team member
```

---

## Step 3 — Reminders

- PR title should reference the issue/ticket
- Target branch: project default (usually `main` or `develop`)
- Assign at least one reviewer
- Link the PR to the issue for traceability
