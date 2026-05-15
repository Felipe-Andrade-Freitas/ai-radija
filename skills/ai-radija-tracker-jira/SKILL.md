---
description: Create and manage issues in Jira Cloud. Handles authentication, hierarchy (Epic/Story/Sub-task), Markdown formatting, and REST API v3. Use when user wants to create Jira issues, manage sprints, or interact with Jira.
user-invocable: true
disable-model-invocation: false
---

# Jira Tracker

Create and manage issues in Jira Cloud using REST API v3 or Atlassian MCP.

---

## Prerequisites

Read `## Tracker` section from `CLAUDE.md` to get connection details. If not configured, run `/ai-radija-tracker-setup` first.

Required: Instance URL, Project Key, Auth (API token + email or Atlassian MCP).

---

## Authentication

Try in order:

1. **Atlassian MCP** — if available, use the MCP tools directly (no manual auth needed)
2. **API Token** — email + API token. Build header: `Authorization: Basic base64(email:token)`
3. **Environment variable** — check `$JIRA_API_TOKEN` and `$JIRA_EMAIL`

Base URL: `https://{instance}.atlassian.net/rest/api/3`

---

## Creating Issues

```
POST /rest/api/3/issue
Content-Type: application/json
```

### Fields:

| Field | JSON path | Notes |
|-------|-----------|-------|
| Project | `fields.project.key` | e.g. `"PROJ"` |
| Issue Type | `fields.issuetype.name` | `"Epic"`, `"Story"`, `"Sub-task"`, `"Task"` |
| Summary | `fields.summary` | Plain text title |
| Description | `fields.description` | ADF (Atlassian Document Format) — see below |
| Priority | `fields.priority.name` | `"Highest"`, `"High"`, `"Medium"`, `"Low"`, `"Lowest"` |
| Labels | `fields.labels` | Array: `["backend", "sprint-23"]` |
| Sprint | `fields.customfield_10020` | Sprint ID (query sprints first) |
| Story Points | `fields.story_points` or `customfield_10028` | Numeric |
| Epic Link | `fields.parent.key` | e.g. `"PROJ-42"` (for stories under an epic) |
| Components | `fields.components` | Array: `[{"name": "API"}]` |

### Example: Create a Story

```json
{
  "fields": {
    "project": {"key": "PROJ"},
    "issuetype": {"name": "Story"},
    "summary": "As a user I want to view dashboard",
    "description": {
      "type": "doc", "version": 1,
      "content": [
        {"type": "heading", "attrs": {"level": 3}, "content": [{"type": "text", "text": "Objective"}]},
        {"type": "paragraph", "content": [{"type": "text", "text": "..."}]}
      ]
    },
    "parent": {"key": "PROJ-10"},
    "labels": ["backend"]
  }
}
```

### Linking parent-child:

- Epic → Story: set `fields.parent.key` to the Epic key
- Story → Sub-task: create with `issuetype: "Sub-task"` and set `fields.parent.key` to the Story key

---

## Atlassian Document Format (ADF)

Jira Cloud v3 uses ADF instead of plain markdown. Key node types:

| Section | ADF type |
|---------|----------|
| Heading | `{"type": "heading", "attrs": {"level": 3}, "content": [{"type": "text", "text": "..."}]}` |
| Paragraph | `{"type": "paragraph", "content": [{"type": "text", "text": "..."}]}` |
| Bullet list | `{"type": "bulletList", "content": [{"type": "listItem", "content": [...]}]}` |
| Code block | `{"type": "codeBlock", "attrs": {"language": "typescript"}, "content": [{"type": "text", "text": "..."}]}` |
| Bold | `{"type": "text", "text": "...", "marks": [{"type": "strong"}]}` |
| Inline code | `{"type": "text", "text": "...", "marks": [{"type": "code"}]}` |

---

## Querying

### List Projects
```
GET /rest/api/3/project
```

### List Issue Types for project
```
GET /rest/api/3/issuetype/project?projectId={id}
```

### List Sprints (via Agile API)
```
GET /rest/agile/1.0/board/{boardId}/sprint
```

### Get Issue
```
GET /rest/api/3/issue/{issueKey}
```

---

## Work Item Hierarchy

Default Jira hierarchy: **Epic → Story → Sub-task**

Some Jira instances add custom levels (Initiative, Theme). Query available issue types first.

---

## Error Handling

- **401 Unauthorized**: invalid token or email. Regenerate at `id.atlassian.com`.
- **400 Bad Request**: invalid ADF format or missing required field. Check `errorMessages` in response.
- **404 Not Found**: wrong project key or issue key.
