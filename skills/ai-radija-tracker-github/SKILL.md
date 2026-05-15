---
description: Create and manage GitHub Issues and Projects. Handles hierarchy via labels and task lists, Markdown formatting, and gh CLI. Use when user wants to create GitHub issues, manage milestones, or interact with GitHub Projects.
user-invocable: true
disable-model-invocation: false
---

# GitHub Issues Tracker

Create and manage issues in GitHub using `gh` CLI or GitHub API.

---

## Prerequisites

Read `## Tracker` section from `CLAUDE.md` to get connection details. If not configured, run `/ai-radija-tracker-setup` first.

Required: Repository (`owner/repo`), Auth (`gh auth status` or GitHub token).

---

## Authentication

Try in order:

1. **`gh` CLI** — run `gh auth status` to verify. This is the preferred method.
2. **Environment variable** — check `$GITHUB_TOKEN` or `$GH_TOKEN`
3. **GitHub API** — `Authorization: Bearer $TOKEN`

---

## Creating Issues

### Via `gh` CLI (preferred):

```bash
gh issue create --repo owner/repo \
  --title "As a user I want to view dashboard" \
  --body "$(cat <<'EOF'
### Objective
...

### TDD
- Given... When... Then...

### Code Example
\`\`\`typescript
...
\`\`\`
EOF
)" \
  --label "story" \
  --milestone "v2.0" \
  --assignee "@me"
```

### Via API:

```
POST /repos/{owner}/{repo}/issues
Content-Type: application/json
Authorization: Bearer $TOKEN
```

```json
{
  "title": "As a user I want to view dashboard",
  "body": "### Objective\n...",
  "labels": ["story"],
  "milestone": 1,
  "assignees": ["username"]
}
```

---

## Hierarchy via Labels + Task Lists

GitHub Issues does not have native hierarchy. Use this convention:

| Level | Label | Linking |
|-------|-------|---------|
| Epic | `epic` | Task list in body: `- [ ] #123` |
| Feature | `feature` | Task list in body linking to stories |
| Story | `story` | "Part of #N" in body |
| Task | `task` | "Part of #N" in body |

### Epic issue body example:

```markdown
## Epic: Portal Dashboard

### Features
- [ ] #101 — Dashboard layout and navigation
- [ ] #102 — Chart components
- [ ] #103 — Data export

### Success Metrics
- ...
```

### Linking child to parent:

Add at the top of the child issue body:
```markdown
> Part of #100
```

---

## GitHub Projects (v2)

If the project uses GitHub Projects for board/sprint management:

### Add issue to project:
```bash
gh project item-add {projectNumber} --owner {owner} --url https://github.com/{owner}/{repo}/issues/{number}
```

### Set custom fields (status, sprint, etc.):
```bash
gh project item-edit --project-id {projectId} --id {itemId} --field-id {fieldId} --text "Sprint 1"
```

### List projects:
```bash
gh project list --owner {owner}
```

---

## Milestones

Use milestones for sprints/iterations:

```bash
# Create milestone
gh api repos/{owner}/{repo}/milestones -f title="Sprint 1" -f due_on="2025-06-01T00:00:00Z"

# List milestones
gh api repos/{owner}/{repo}/milestones
```

---

## Querying

```bash
# List issues with label
gh issue list --repo owner/repo --label "story" --state open

# Get issue details
gh issue view 123 --repo owner/repo

# List labels
gh label list --repo owner/repo
```

---

## Error Handling

- **401 Unauthorized**: run `gh auth login` to re-authenticate.
- **404 Not Found**: wrong repo name or issue number.
- **422 Validation Failed**: label doesn't exist. Create it first with `gh label create`.
