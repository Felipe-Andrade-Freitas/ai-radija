---
description: Configure which project tracker to use (Azure DevOps, Jira, GitHub Issues, Linear, Notion) and collect connection details. Saves config to CLAUDE.md so other skills auto-detect it. Use when user mentions "tracker", "setup tracker", "configure ADO/Jira/Linear", or before creating work items for the first time.
user-invocable: true
disable-model-invocation: false
---

# Tracker Setup

Configure the project tracker connection so that `/ai-radija-new-feature` and `/ai-radija-prd-to-issues` can create work items automatically.

---

## Step 1 — Choose Tracker

Ask: "Which project tracker does this project use?"

| # | Tracker | Best for |
|---|---------|----------|
| 1 | **Azure DevOps** | Enterprise .NET, regulated industries, Azure ecosystem |
| 2 | **Jira** | Large teams, Atlassian ecosystem, Scrum/Kanban |
| 3 | **GitHub Issues** | Open source, small teams, GitHub-native workflow |
| 4 | **Linear** | Startups, fast-moving teams, keyboard-driven workflow |
| 5 | **Notion** | Non-technical stakeholders, docs-first teams |
| 6 | **None (markdown only)** | Local specs, no external tracker |

---

## Step 2 — Collect Connection Details

Based on the chosen tracker, ask for the required fields:

### Azure DevOps

| Field | Example | Required |
|-------|---------|----------|
| Organization | `https://dev.azure.com/myorg` | Yes |
| Project | `MyProject` | Yes |
| Team | `MyProject Team` | No (defaults to project name + " Team") |
| Area Path | `MyProject\Backend` | No (defaults to project root) |
| Iteration / Sprint | `MyProject\Sprint 1` or `MyProject\2025-Q2` | No |
| Default Work Item Types | Epic → Feature → User Story → Task | No (uses defaults) |
| PAT or Auth method | PAT token or `az login` | Yes (for API calls) |

### Jira

| Field | Example | Required |
|-------|---------|----------|
| Instance URL | `https://mycompany.atlassian.net` | Yes |
| Project Key | `PROJ` | Yes |
| Board / Sprint | `Sprint 23` | No |
| Default Issue Types | Epic → Story → Sub-task | No (uses defaults) |
| Labels / Components | `backend`, `frontend` | No |
| Auth method | API token + email, or Atlassian MCP | Yes |

### GitHub Issues

| Field | Example | Required |
|-------|---------|----------|
| Repository | `owner/repo` | Yes (auto-detected from git remote) |
| Project board | `My Project Board` | No |
| Milestone | `v2.0` | No |
| Label scheme | `epic`, `feature`, `story`, `task` | No (uses defaults) |
| Auth method | `gh` CLI (auto) or GitHub token | Yes |

### Linear

| Field | Example | Required |
|-------|---------|----------|
| Team | `Engineering` | Yes |
| Project | `Q2 Portal Rebuild` | No |
| Cycle | `Cycle 14` | No |
| Labels | `backend`, `frontend`, `infra` | No |
| Auth method | Linear MCP or API key | Yes |

### Notion

| Field | Example | Required |
|-------|---------|----------|
| Workspace | `My Workspace` | Yes |
| Database / Page | `Product Backlog` or page URL | Yes |
| Status property | `Status` (To Do, In Progress, Done) | No |
| Sprint / Iteration property | `Sprint` | No |
| Auth method | Notion MCP or integration token | Yes |

---

## Step 3 — Validate Connection

After collecting the details, validate the connection:

1. **Test connectivity** — make a simple API call (list projects, get current user, etc.)
2. **Verify permissions** — confirm the user can create work items
3. **List available options** — show available area paths, iterations, projects, etc. so the user can confirm or adjust

If validation fails, show the error and help troubleshoot.

---

## Step 4 — Save to CLAUDE.md

After successful validation, append the tracker config to the project's `CLAUDE.md` under a `## Tracker` section:

```markdown
## Tracker

- **Type**: Azure DevOps
- **Organization**: https://dev.azure.com/myorg
- **Project**: MyProject
- **Area Path**: MyProject\Backend
- **Iteration**: MyProject\Sprint 1
- **Auth**: az login
```

If `CLAUDE.md` already has a `## Tracker` section, update it instead of duplicating.

Tell the user: "Tracker configured. Now when you use `/ai-radija-new-feature` or `/ai-radija-prd-to-issues`, work items will be created directly in [tracker name] without asking again."

---

## Step 5 — Reconfiguration

If the user runs this skill again:

1. Show the current config
2. Ask: "Want to update this config or switch to a different tracker?"
3. Allow changing individual fields without re-entering everything
