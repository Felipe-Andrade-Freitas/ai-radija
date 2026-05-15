---
description: Create and manage pages and databases in Notion for project tracking. Handles hierarchy via relations, rich block formatting, and status properties. Use when user wants to create Notion pages, manage a backlog database, or interact with Notion.
user-invocable: true
disable-model-invocation: false
---

# Notion Tracker

Create and manage pages in Notion using the Notion MCP or REST API.

---

## Prerequisites

Read `## Tracker` section from `CLAUDE.md` to get connection details. If not configured, run `/ai-radija-tracker-setup` first.

Required: Workspace, Database/Page URL, Auth (Notion MCP or integration token).

---

## Authentication

Try in order:

1. **Notion MCP** — if available, use MCP tools directly (preferred)
2. **API Token** — internal integration token. `Authorization: Bearer $NOTION_TOKEN`, `Notion-Version: 2022-06-28`
3. **Environment variable** — check `$NOTION_TOKEN`

Base URL: `https://api.notion.com/v1`

---

## Database Setup

If the user doesn't have a backlog database yet, help create one with these properties:

| Property | Type | Values / Notes |
|----------|------|---------------|
| Title | `title` | Work item name (built-in) |
| Type | `select` | Epic, Feature, Story, Task |
| Status | `status` | To Do, In Progress, Done |
| Priority | `select` | P1-Urgent, P2-High, P3-Medium, P4-Low |
| Sprint / Iteration | `select` or `date` | Sprint name or date range |
| Assignee | `people` | Team member |
| Effort | `number` | Story points or hours |
| Parent | `relation` | Self-relation to same database (for hierarchy) |
| Area | `select` | Backend, Frontend, Infra, etc. |

---

## Creating Pages (Work Items)

### Via Notion MCP (preferred):

Use the `notion-create-pages` tool with the database ID and properties.

### Via API:

```
POST /v1/pages
Content-Type: application/json
```

```json
{
  "parent": {"database_id": "DATABASE_ID"},
  "properties": {
    "Title": {"title": [{"text": {"content": "As a user I want to view dashboard"}}]},
    "Type": {"select": {"name": "Story"}},
    "Status": {"status": {"name": "To Do"}},
    "Priority": {"select": {"name": "P2-High"}},
    "Sprint": {"select": {"name": "Sprint 1"}},
    "Parent": {"relation": [{"id": "PARENT_PAGE_ID"}]}
  },
  "children": [
    {"object": "block", "type": "heading_3", "heading_3": {"rich_text": [{"type": "text", "text": {"content": "Objective"}}]}},
    {"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"type": "text", "text": {"content": "Dashboard overview for admin users."}}]}},
    {"object": "block", "type": "heading_3", "heading_3": {"rich_text": [{"type": "text", "text": {"content": "TDD"}}]}},
    {"object": "block", "type": "bulleted_list_item", "bulleted_list_item": {"rich_text": [{"type": "text", "text": {"content": "Given user is logged in, When navigating to /dashboard, Then charts load"}}]}},
    {"object": "block", "type": "heading_3", "heading_3": {"rich_text": [{"type": "text", "text": {"content": "Code Example"}}]}},
    {"object": "block", "type": "code", "code": {"rich_text": [{"type": "text", "text": {"content": "export function useDashboardData() {\n  return useQuery({ queryKey: ['dashboard'], queryFn: fetchDashboard })\n}"}}], "language": "typescript"}}
  ]
}
```

---

## Hierarchy via Relations

Notion uses a **self-relation** property for parent-child hierarchy:

| Level | Type property | Parent relation |
|-------|--------------|----------------|
| Epic | `Epic` | None (top level) |
| Feature | `Feature` | → Epic |
| Story | `Story` | → Feature |
| Task | `Task` | → Story |

When creating items, set the `Parent` relation to the parent page ID.

---

## Block Types for Descriptions

| Section | Notion block type |
|---------|------------------|
| Heading | `heading_3` |
| Paragraph | `paragraph` |
| Bullet list | `bulleted_list_item` (one block per item) |
| Numbered list | `numbered_list_item` |
| Code block | `code` with `language` attribute |
| To-do item | `to_do` with `checked` boolean |
| Divider | `divider` |
| Callout | `callout` with emoji icon |
| Toggle | `toggle` (collapsible section) |

---

## Querying

### Query database:
```
POST /v1/databases/{database_id}/query
```
```json
{
  "filter": {"property": "Type", "select": {"equals": "Story"}},
  "sorts": [{"property": "Priority", "direction": "ascending"}]
}
```

### Get page:
```
GET /v1/pages/{page_id}
```

### Get page content (blocks):
```
GET /v1/blocks/{page_id}/children
```

---

## Error Handling

- **401 Unauthorized**: integration not connected to workspace. Go to Notion Settings → Connections → add the integration.
- **404 Not Found**: database/page not shared with the integration. Click "..." on the page → "Connect to" → select your integration.
- **400 Validation Error**: property name mismatch. Query database schema first to get exact property names.
- **Rate limited**: Notion has a 3 req/sec limit. Add 350ms delays between requests for bulk operations.
