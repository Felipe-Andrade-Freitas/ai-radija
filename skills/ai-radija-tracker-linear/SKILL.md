---
description: Create and manage Linear issues and projects. Handles hierarchy (Project/Issue/Sub-issue), Markdown formatting, cycles, and labels. Use when user wants to create Linear issues, manage cycles, or interact with Linear.
user-invocable: true
disable-model-invocation: false
---

# Linear Tracker

Create and manage issues in Linear using Linear MCP or GraphQL API.

---

## Prerequisites

Read `## Tracker` section from `CLAUDE.md` to get connection details. If not configured, run `/ai-radija-tracker-setup` first.

Required: Team name, Auth (Linear MCP or API key).

---

## Authentication

Try in order:

1. **Linear MCP** — if available, use MCP tools directly
2. **API Key** — `Authorization: $LINEAR_API_KEY`
3. **Environment variable** — check `$LINEAR_API_KEY`

Endpoint: `https://api.linear.app/graphql`

---

## Creating Issues

### Via GraphQL:

```graphql
mutation {
  issueCreate(input: {
    teamId: "TEAM_ID"
    title: "As a user I want to view dashboard"
    description: "### Objective\n..."
    priority: 2
    labelIds: ["LABEL_ID"]
    projectId: "PROJECT_ID"
    cycleId: "CYCLE_ID"
    parentId: "PARENT_ISSUE_ID"
  }) {
    success
    issue { id identifier url }
  }
}
```

### Key fields:

| Field | Type | Notes |
|-------|------|-------|
| teamId | ID | Required. Query teams first. |
| title | String | Plain text |
| description | String | **Markdown** — Linear renders it natively |
| priority | Int | 0=No priority, 1=Urgent, 2=High, 3=Medium, 4=Low |
| labelIds | [ID] | Array of label IDs |
| projectId | ID | Optional — associates to a project |
| cycleId | ID | Optional — assigns to a cycle (sprint) |
| parentId | ID | For sub-issues — creates hierarchy |
| estimate | Int | Story points |
| assigneeId | ID | User ID |

---

## Hierarchy

Linear hierarchy: **Project → Issue → Sub-issue**

- **Project** = groups related issues (like an Epic)
- **Issue** = main work item (like a Story/Feature)
- **Sub-issue** = child of an issue (like a Task)

Set `parentId` to create sub-issues.

---

## Querying

### List Teams:
```graphql
{ teams { nodes { id name } } }
```

### List Projects:
```graphql
{ projects(filter: { state: { eq: "started" } }) { nodes { id name } } }
```

### List Cycles (Sprints):
```graphql
{ cycles(filter: { isPast: { eq: false } }) { nodes { id name number startsAt endsAt } } }
```

### List Labels:
```graphql
{ issueLabels { nodes { id name color } } }
```

### Get Issue:
```graphql
{ issue(id: "ISSUE_ID") { id identifier title description state { name } children { nodes { id title } } } }
```

---

## Markdown in Descriptions

Linear renders Markdown natively. Use standard markdown:

```markdown
### Objective
Dashboard overview for admin users.

### TDD
- **Given** user is logged in, **When** navigating to /dashboard, **Then** charts load within 2s
- **Given** no data exists, **When** visiting dashboard, **Then** show empty state

### Code Example
\`\`\`typescript
export function useDashboardData() {
  return useQuery({ queryKey: ['dashboard'], queryFn: fetchDashboard })
}
\`\`\`

### Done When
- [ ] Component renders chart with real data
- [ ] Empty state shows when no data
- [ ] Tests cover 3 scenarios
```

---

## Error Handling

- **401 Unauthorized**: invalid API key. Generate new one at `linear.app/settings/api`.
- **400 Bad Request**: invalid team/project/cycle ID. Query available options first.
- **Rate limited**: Linear has a 1500 req/hour limit. Use batching for large backlogs.
