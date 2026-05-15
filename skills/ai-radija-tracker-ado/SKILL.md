---
description: Create and manage work items in Azure DevOps. Handles authentication, hierarchy (Epic/Feature/Story/Task), HTML formatting, and JSON Patch API. Use when user wants to create ADO work items, update iterations, manage area paths, or interact with Azure DevOps.
user-invocable: true
disable-model-invocation: false
---

# Azure DevOps Tracker

Create and manage work items in Azure DevOps using the REST API.

---

## Prerequisites

Read `## Tracker` section from `CLAUDE.md` to get connection details. If not configured, run `/ai-radija-tracker-setup` first.

Required: Organization URL, Project name, Auth (PAT or `az login`).

---

## Authentication

Try in order:

1. **`az` CLI** — run `az account show` to check if logged in. If yes, get token via `az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798`
2. **PAT** — if `az` is not available, ask user for Personal Access Token. Store reference in `CLAUDE.md` (never store the token itself in code).
3. **Environment variable** — check `$ADO_PAT` or `$AZURE_DEVOPS_PAT`

Build auth header: `Authorization: Basic base64(:$PAT)` or `Authorization: Bearer $TOKEN`

---

## Creating Work Items

Use JSON Patch via REST API (not `az devops` CLI which has installation issues on Windows):

```
POST https://dev.azure.com/{org}/{project}/_apis/wit/workitems/${type}?api-version=7.1
Content-Type: application/json-patch+json
```

### Patch operations per field:

| Field | Path | Notes |
|-------|------|-------|
| Title | `/fields/System.Title` | Plain text |
| Description | `/fields/System.Description` | **HTML** — use `<h3>`, `<p>`, `<pre>`, `<ul>`, `<code>` |
| Acceptance Criteria | `/fields/Microsoft.VSTS.Common.AcceptanceCriteria` | HTML |
| Area Path | `/fields/System.AreaPath` | e.g. `Project\Team\Area` |
| Iteration | `/fields/System.IterationPath` | e.g. `Project\Sprint 1` |
| State | `/fields/System.State` | `New`, `Active`, `Closed` |
| Priority | `/fields/Microsoft.VSTS.Common.Priority` | 1-4 |
| Effort / Story Points | `/fields/Microsoft.VSTS.Scheduling.Effort` | Numeric |
| Parent link | `/relations/-` | See linking below |

### Example: Create a User Story

```json
[
  {"op": "add", "path": "/fields/System.Title", "value": "As a user I want to view dashboard"},
  {"op": "add", "path": "/fields/System.Description", "value": "<h3>Objective</h3><p>...</p><h3>TDD</h3><ul><li>Given... When... Then...</li></ul>"},
  {"op": "add", "path": "/fields/System.AreaPath", "value": "MyProject\\Backend"},
  {"op": "add", "path": "/fields/System.IterationPath", "value": "MyProject\\Sprint 1"}
]
```

### Linking parent-child:

```json
{
  "op": "add",
  "path": "/relations/-",
  "value": {
    "rel": "System.LinkTypes.Hierarchy-Reverse",
    "url": "https://dev.azure.com/{org}/{project}/_apis/wit/workitems/{parentId}"
  }
}
```

### Linking Test Case → User Story (TestedBy):

```json
{
  "op": "add",
  "path": "/relations/-",
  "value": {
    "rel": "Microsoft.VSTS.Common.TestedBy-Reverse",
    "url": "https://dev.azure.com/{org}/{project}/_apis/wit/workitems/{userStoryId}",
    "attributes": { "comment": "TDD cycle" }
  }
}
```

> `TestedBy-Reverse` is added to the **Test Case** and creates the "Tested By" link visible on the User Story's Tests tab.

---

## Creating Test Cases

Test Cases use a **dedicated steps field** (`Microsoft.VSTS.TCM.Steps`) with XML — **not** HTML like Description. Never put steps in the Description field.

### TCM Steps XML format

```xml
<steps id="0" last="N">
  <step id="1" type="ActionStep">
    <parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;Action text&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>
    <parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;Expected result&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>
    <description/>
  </step>
  <step id="2" type="ValidateStep">
    <parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;Validation action&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>
    <parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;Expected result&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>
    <description/>
  </step>
</steps>
```

**Rules:**
- `last="N"` must equal the total step count
- Step IDs are sequential starting at 1
- `ActionStep` — setup/execution step (both parameterizedStrings present but second can be empty)
- `ValidateStep` — assertion step; ADO renders a checkbox next to it
- Content inside `<parameterizedString>` is HTML that must be XML-escaped: `<` → `&lt;`, `>` → `&gt;`, `&` → `&amp;`
- The entire XML string becomes the JSON field value — so XML `"` must be JSON-escaped as `\"`

### Field reference for Test Cases

| Field | Path | Notes |
|-------|------|-------|
| Title | `/fields/System.Title` | Plain text |
| Steps | `/fields/Microsoft.VSTS.TCM.Steps` | XML — see format above |
| Description | `/fields/System.Description` | HTML — use for objective/context |
| Area Path | `/fields/System.AreaPath` | Same as other types |
| Iteration | `/fields/System.IterationPath` | Same as other types |
| State | `/fields/System.State` | `Design`, `Ready`, `Closed` |
| TestedBy link | `/relations/-` | `Microsoft.VSTS.Common.TestedBy-Reverse` |

### PowerShell helpers (Windows / encoding-safe)

> **Important**: Use `HttpWebRequest` with explicit UTF-8 encoding instead of `Invoke-RestMethod`. `Invoke-RestMethod` in PowerShell 5.1 silently corrupts the JSON body when step text contains accented characters, causing `400 Bad Request`.

```powershell
function Make-Step($id, $type, $action, $expected) {
    $a = $action  -replace '&', '&amp;'
    $e = $expected -replace '&', '&amp;'
    $s  = '<step id="' + $id + '" type="' + $type + '">'
    $s += '<parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;' + $a + '&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>'
    $s += '<parameterizedString isformatted="true">&lt;DIV&gt;&lt;P&gt;' + $e + '&lt;/P&gt;&lt;/DIV&gt;</parameterizedString>'
    $s += '<description/></step>'
    return $s
}

function Make-StepsXml($stepsArr) {
    $count = $stepsArr.Count
    return '<steps id="0" last="' + $count + '">' + ($stepsArr -join '') + '</steps>'
}

function Send-Patch($url, $body, $token) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $req = [System.Net.HttpWebRequest]::Create($url)
    $req.Method = "PATCH"
    $req.ContentType = "application/json-patch+json; charset=utf-8"
    $req.Headers.Add("Authorization", "Bearer $token")
    $req.ContentLength = $bytes.Length
    $s = $req.GetRequestStream(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
    $r = $req.GetResponse()
    return (New-Object System.IO.StreamReader($r.GetResponseStream())).ReadToEnd() | ConvertFrom-Json
}

function Update-TCSteps($wiId, $stepsXml, $token) {
    $jsonSteps = $stepsXml -replace '"', '\"'
    $body = '[{"op":"add","path":"/fields/Microsoft.VSTS.TCM.Steps","value":"' + $jsonSteps + '"}]'
    $url  = "https://dev.azure.com/{org}/{project}/_apis/wit/workitems/$wiId`?api-version=7.1"
    $json = Send-Patch $url $body $token
    Write-Host "Updated TC #$($json.id) — $($json.fields.'System.Title')"
}
```

### Full example: create Test Case + link + steps

```powershell
$token = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv
$org   = "my-org"
$proj  = "MyProject"
$wiBase = "https://dev.azure.com/$org/$($proj.Replace(' ','%20'))/_apis/wit/workItems"

# 1. Create the Test Case (title + link to User Story 42)
$body = '[' +
  '{"op":"add","path":"/fields/System.Title","value":"[Ciclo 1] widget renders default state"},' +
  '{"op":"add","path":"/fields/System.AreaPath","value":"' + $proj + '"},' +
  '{"op":"add","path":"/fields/System.IterationPath","value":"' + $proj + '"},' +
  '{"op":"add","path":"/relations/-","value":{"rel":"Microsoft.VSTS.Common.TestedBy-Reverse","url":"' + $wiBase + '/42","attributes":{"comment":"TDD"}}}' +
']'
$bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
$req = [System.Net.HttpWebRequest]::Create("https://dev.azure.com/$org/$proj/_apis/wit/workitems/`$Test Case?api-version=7.1")
$req.Method = "POST"; $req.ContentType = "application/json-patch+json; charset=utf-8"
$req.Headers.Add("Authorization", "Bearer $token"); $req.ContentLength = $bytes.Length
$s = $req.GetRequestStream(); $s.Write($bytes, 0, $bytes.Length); $s.Close()
$tc = (New-Object System.IO.StreamReader($req.GetResponse().GetResponseStream())).ReadToEnd() | ConvertFrom-Json
$tcId = $tc.id

# 2. Add steps
$xml = Make-StepsXml @(
    (Make-Step 1 "ActionStep"   "Render the widget with default props" "Component mounts without errors")
    (Make-Step 2 "ValidateStep" "Check that the title element is present in the DOM" "screen.getByText('Widget Title') is found")
    (Make-Step 3 "ValidateStep" "Check that isLoading is false by default" "result.current.isLoading === false")
)
Update-TCSteps $tcId $xml $token
```

---

## HTML Formatting for Descriptions

ADO renders HTML in description fields. Convert each section:

| Section | HTML |
|---------|------|
| Heading | `<h3>Objective</h3>` |
| Paragraph | `<p>text</p>` |
| Bullet list | `<ul><li>item</li></ul>` |
| Code block | `<pre><code class="language-typescript">code</code></pre>` |
| Inline code | `<code>variable</code>` |
| Bold | `<b>text</b>` |
| Given/When/Then | `<ul><li><b>Given</b> X, <b>When</b> Y, <b>Then</b> Z</li></ul>` |

---

## Querying

### List Area Paths
```
GET https://dev.azure.com/{org}/{project}/_apis/wit/classificationnodes/Areas?$depth=3&api-version=7.1
```

### List Iterations
```
GET https://dev.azure.com/{org}/{project}/_apis/wit/classificationnodes/Iterations?$depth=3&api-version=7.1
```

### List Work Item Types
```
GET https://dev.azure.com/{org}/{project}/_apis/wit/workitemtypes?api-version=7.1
```

### Get Work Item by ID
```
GET https://dev.azure.com/{org}/{project}/_apis/wit/workitems/{id}?$expand=relations&api-version=7.1
```

---

## Work Item Hierarchy

Default ADO hierarchy: **Epic → Feature → User Story → Task**

Create in dependency order (parent first) so child items can reference the parent ID in the link relation.

---

## Error Handling

- **401 Unauthorized**: PAT expired or wrong scope. Ask user to regenerate with "Work Items: Read & Write" scope.
- **404 Not Found**: wrong org/project name or work item ID. Verify URL.
- **400 Bad Request**: malformed JSON Patch. Ensure body is an array `[...]` and Content-Type is `application/json-patch+json`.
