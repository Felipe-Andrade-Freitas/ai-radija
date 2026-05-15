---
description: Convert existing tasks from tasks.md into GitHub Issues in the project's repository. Validates the git remote is a GitHub URL before creating any issues. Use when user wants to convert tasks to issues, create GitHub issues from tasks, or mentions "tasks to issues".
user-invocable: true
disable-model-invocation: false
---

# Tasks to Issues — GitHub Issues Creation

Convert tasks from tasks.md into actionable GitHub Issues in the project's repository.

---

## Workflow

### Step 1 — Locate Tasks

1. Check `specs/feature.json` for the active feature directory
2. Read `tasks.md` from the feature directory
3. If not found, ask the user which tasks file to use

### Step 2 — Validate Git Remote

Run:
```bash
git config --get remote.origin.url
```

**ONLY PROCEED if the remote is a GitHub URL** (contains `github.com`).

If not a GitHub URL:
- Stop and inform the user
- Suggest using `/ai-radija-tracker-github` for GitHub Issues, or the appropriate tracker skill for their platform

### Step 3 — Verify Authentication

Check GitHub CLI authentication:
```bash
gh auth status
```

If not authenticated, instruct user to run `gh auth login`.

### Step 4 — Create Issues

For each task in tasks.md:
1. Extract task ID, description, story label, and phase
2. Create a GitHub Issue using `gh`:

```bash
gh issue create --repo <owner/repo> \
  --title "<Task description>" \
  --body "$(cat <<'EOF'
**Task ID**: <ID>
**Phase**: <phase>
**Story**: <story label>

<Full task description with file paths>

---
Generated from tasks.md by AI Radija Tools
EOF
)" \
  --label "<phase-label>"
```

3. Use labels for hierarchy:
   - `setup` for Phase 1 tasks
   - `foundational` for Phase 2 tasks
   - `us1`, `us2`, etc. for User Story tasks
   - `polish` for final phase tasks

### Step 5 — Report

- Number of issues created
- Links to created issues
- Any tasks that failed to create (with error details)

---

## Safety Rules

- **NEVER create issues in repositories that don't match the remote URL**
- Verify remote URL before every creation batch
- If user has a different tracker (Jira, ADO, Linear, Notion), suggest the appropriate `/ai-radija-tracker-*` skill instead
