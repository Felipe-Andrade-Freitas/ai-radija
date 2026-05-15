---
description: Run QA automation with Playwright against ADO work items. Fetches PBIs or Bugs from ADO, generates Playwright specs from acceptance criteria (or description when AC is absent), executes tests against the model/staging environment, and attaches results + summary comment to the work item. Use when the user wants to run QA tests, validate behavior in model environment, generate test specs from AC, or mentions "qa-test", "playwright", or "test in model env".
user-invocable: true
disable-model-invocation: false
---

# QA Test — Playwright + ADO

Run automated QA for one or more ADO work items, generate specs from acceptance criteria, execute Playwright tests, and attach results back to ADO.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Parameters

- (no args) — process all PBIs/Bugs tagged `QA` in the configured area
- `bug <id>` or `pbi <id>` or `--pbi <id>` — only that work item (any type)
- `--dry-run` — fetch and display AC without executing tests or writing to ADO
- `--generate-only` — generate Playwright specs from AC and stop (no test execution)

---

## Step 0 — Resolve Config

### Playwright project root

Search for `playwright.config.ts` starting from the current working directory:

```bash
find . -name "playwright.config.ts" -o -name "playwright.config.js" 2>/dev/null | head -5
```

The directory containing that file is `E2E_DIR`. If not found, check `$E2E_DIR` env var or ask the user.

Then detect the test output directory and available Playwright projects by reading `playwright.config.ts`:
- Prefer project named `pbi-functional` → `sandbox` → `chromium` (in that order)
- Detect `testDir` for sandbox/functional tests (`tests/sandbox/`, `e2e/`, etc.)
- Detect spec naming convention from existing specs (`tc-<ID>.spec.ts` vs `pbi-<ID>.spec.ts`)

### ADO authentication

**Primary — Azure CLI (preferred, no env var needed):**

```bash
ADO_TOKEN=$(az account get-access-token \
  --resource 499b84ac-1321-427f-aa17-267ca6975798 \
  --query accessToken -o tsv)
```

If Azure CLI is not logged in, run `az login` first.

**Fallback — PAT via env var:**

```bash
ADO_TOKEN=$(python3 -c "import base64,os; print(base64.b64encode(f':{os.environ[\"ADO_PAT\"]}'.encode()).decode())")
# Then use: -H "Authorization: Basic ${ADO_TOKEN}"
```

### ADO coordinates

Read from env vars (fall back to Alborada NG defaults):

| Variable | Default |
|---|---|
| `ADO_ORG_URL` | `https://dev.azure.com/AIZ-Global` |
| `ADO_PROJECT` | `GL.IT-Argentina Applications` |
| `ADO_AREA_PATH` | `GL.IT-Argentina Applications` |
| `BASE_URL` | read from `<E2E_DIR>/.env` → `playwright.config.ts` default |

If `BASE_URL` is not resolved and mode is not `--dry-run` or `--generate-only`, ask the user.

---

## Step 1 — Fetch Work Items from ADO

**If a specific ID was given** (e.g. `bug 4000102`, `pbi 3999814`, `--pbi 4000102`):

```bash
ADO_PROJECT_ENC=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${ADO_PROJECT}',safe=''))")

curl -s \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/workitems/<ID>?fields=System.Id,System.Title,System.WorkItemType,System.Tags,System.Description,Microsoft.VSTS.Common.AcceptanceCriteria&api-version=7.1"
```

**If no ID given** — query all PBIs/Bugs tagged `QA`:

```bash
curl -s -X POST \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  -H "Content-Type: application/json" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/wiql?api-version=7.1" \
  -d "{\"query\": \"SELECT [System.Id] FROM WorkItems WHERE [System.Tags] CONTAINS 'QA' AND [System.State] NOT IN ('Closed','Removed') AND [System.AreaPath] UNDER '${ADO_AREA_PATH}' ORDER BY [System.ChangedDate] DESC\"}"
```

Then fetch details for all returned IDs in batch.

**Extract for each item:** `System.Id`, `System.Title`, `System.WorkItemType`, `System.Tags`, `Microsoft.VSTS.Common.AcceptanceCriteria`, `System.Description`.

Strip HTML from AC and Description:

```bash
python3 - <<'PYEOF'
from html.parser import HTMLParser
class S(HTMLParser):
    def __init__(self): super().__init__(); self.t=[]
    def handle_data(self,d): self.t.append(d)
def strip(html): p=S(); p.feed(html or ''); return ' '.join(p.t).strip()
print(strip("""<HTML_HERE>"""))
PYEOF
```

**`--dry-run` stop:** print ID, title, type, and AC/description for each item. Stop here.

---

## Step 2 — Resolve or Generate Spec

For each work item, determine which spec to run:

1. **Existing spec:** look for `tc-<ID>.spec.ts` or `pbi-<ID>.spec.ts` in the sandbox/functional test dir. If found, use it.
2. **Tag mapping:** if the item has a `playwright:<name>` tag, map to the corresponding named spec file if it exists.
3. **Generate from AC:** if no existing spec, generate one (see below).

### Spec generation rules

Follow the naming and import conventions of existing specs in the project. For Alborada NG projects use:

```typescript
import { test, expect } from '@playwright/test';
import { BasePage } from '../../pages/BasePage';

/**
 * TC #<ID> — <TITLE>
 */
test.describe('TC #<ID> — <TITLE_TRUNCATED_60>', () => {
  test.setTimeout(60_000);

  const BASE = '<BASE_URL>';

  test('<criterion description>', async ({ page }) => {
    const base = new BasePage(page);
    await base.navigateTo(`${BASE}/<path>`);
    await base.waitForPageReady();
    base.assertNoServerErrors();
    // assertions based on AC
  });

  // one test() per acceptance criterion
});
```

**When AC is empty:** generate a smoke test from `System.Description` (navigate to the relevant module, assert no 5xx errors, assert key UI elements are visible based on the description).

**Selector preference:** `getByRole` > `getByText` > `getByLabel` > CSS selectors.

Write spec to: `<E2E_DIR>/tests/sandbox/tc-<ID>.spec.ts` (or the project's equivalent sandbox dir).

---

**`--generate-only` stop:** print a summary of specs written and stop.

```
✅ Spec generation complete.

Specs written:
  • tests/sandbox/tc-<ID>.spec.ts — <N> tests from <M> acceptance criteria
  ...

Next steps:
  1. Review and adjust the generated specs
  2. Run /speckit.implement to build the implementation
  3. After PR merge, run /speckit.qa-test to execute against model environment
```

---

## Step 3 — Verify Auth State

If the Playwright project depends on `storageState.json` (i.e. uses saved session cookies), check its age:

```bash
python3 - <<'PYEOF'
import os, time
path = '<E2E_DIR>/storageState.json'
if not os.path.exists(path):
    print('MISSING')
else:
    age_h = (time.time() - os.path.getmtime(path)) / 3600
    print('STALE' if age_h > 8 else f'FRESH ({age_h:.1f}h)')
PYEOF
```

If `MISSING` or `STALE`, run the setup project first (interactive — browser opens for Okta/SSO login):

```bash
cd "<E2E_DIR>"
npx playwright test --project=setup
```

Wait for the user to complete MFA if prompted.

---

## Step 4 — Execute Playwright

```bash
cd "<E2E_DIR>"
PLAYWRIGHT_JUNIT_OUTPUT_NAME=test-results/junit.xml \
npx playwright test "tests/sandbox/tc-<ID>.spec.ts" \
  --project=pbi-functional \
  --reporter=junit,list
```

- Exit 0: all passed
- Exit 1: some tests failed (continue — report and attach)
- Exit ≥ 2: config error — show stderr and stop without attaching

---

## Step 5 — Parse Results

Read `<E2E_DIR>/test-results/junit.xml`:

```bash
python3 - <<'PYEOF'
import xml.etree.ElementTree as ET, os

path = os.path.join('<E2E_DIR>', 'test-results', 'junit.xml')
tree = ET.parse(path)
root = tree.getroot()
ts = root if root.tag == 'testsuite' else root.find('testsuite')

print('tests:', ts.get('tests'))
print('failures:', ts.get('failures'))
print('errors:', ts.get('errors'))
print('time:', ts.get('time'))

for tc in root.iter('testcase'):
    name = tc.get('name')
    t = tc.get('time')
    fail = tc.find('failure')
    skip = tc.find('skipped')
    status = 'FAIL' if fail is not None else ('SKIP' if skip is not None else 'PASS')
    print(f'  [{status}] {name} ({t}s)')
    if fail is not None:
        print(f'    ERR: {(fail.get("message") or "")[:200]}')
PYEOF
```

Collect: `TOTAL`, `PASSED`, `FAILED`, `SKIPPED`, `DURATION_S`, and per-test details.

Find failure screenshots: `<E2E_DIR>/test-results/**/test-failed-*.png`

---

## Step 6 — Attach Files to ADO Work Item

For each file (spec + junit.xml + failure screenshots), upload and link:

**Upload:**

```bash
ATTACHMENT_URL=$(curl -s -X POST \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  -H "Content-Type: application/octet-stream" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/attachments?fileName=<FILENAME>&api-version=7.1" \
  --data-binary @"<FILEPATH>" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['url'])")
```

**Link to work item:**

```bash
curl -s -X PATCH \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  -H "Content-Type: application/json-patch+json" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/workitems/<ID>?api-version=7.1" \
  -d "[{\"op\":\"add\",\"path\":\"/relations/-\",\"value\":{\"rel\":\"AttachedFile\",\"url\":\"${ATTACHMENT_URL}\",\"attributes\":{\"comment\":\"<COMMENT>\"}}}]"
```

**Files to attach:**
1. `tc-<ID>.spec.ts` — comment: `"Test cases: TC #<ID> — <TITLE>"`
2. `test-results/junit.xml` — comment: `"Test results (JUnit XML): TC #<ID>"`
3. Failure screenshots (max 3, one per distinct failure) — comment: `"Failure screenshot: <test name>"`

---

## Step 7 — Post Summary Comment

```bash
curl -s -X POST \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  -H "Content-Type: application/json" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/workitems/<ID>/comments?api-version=7.1-preview.3" \
  -d "<JSON_BODY>"
```

Comment format:

```markdown
## 🤖 QA Automation Report — #<ID>

**Title:** <TITLE>
**URL tested:** <BASE_URL>
**Date:** <ISO_DATETIME>

### Result: ✅ PASSED / ❌ FAILED

| Metric | Value |
|--------|-------|
| Total | N |
| ✅ Passed | N |
| ❌ Failed | N |
| ⏭️ Skipped | N |
| ⚠️ Flaky (passed on retry) | N |
| Duration | X.Xs |

### Test Details

| Test | Status | Duration | Error |
|------|--------|----------|-------|
| <name> | ✅ | 1.2s | — |
| <name> | ❌ | 3.4s | `<truncated error>` |

### Attachments
- 📄 `tc-<ID>.spec.ts` — test cases executed
- 📊 `junit.xml` — results in JUnit format
- 📸 `<screenshot>` — failure capture (if any)

*Auto-generated by `/qa-test` — Claude Code (ai-radija-qa-test)*
```

---

## Step 8 — Create Bug if Tests Failed

**Only if FAILED > 0:**

```bash
PATCH_BODY=$(python3 - <<PYEOF
import json, urllib.parse

title = "QA FAIL: <TITLE>"[:80]
area = "<ADO_AREA_PATH>"
pbi_id = <ID>
org = "<ADO_ORG_URL>"
date = "<ISO_DATETIME>"
failed_tests = """<NEWLINE_SEPARATED_FAILURES>"""
repro = "<ul>" + "".join(f"<li>{t}</li>" for t in failed_tests.splitlines() if t) + "</ul>"

patch = [
    {"op":"add","path":"/fields/System.Title","value":title},
    {"op":"add","path":"/fields/System.AreaPath","value":area},
    {"op":"add","path":"/fields/Microsoft.VSTS.TCM.ReproSteps",
     "value":f"<p>Tests failed in QA run {date}:</p>{repro}"},
    {"op":"add","path":"/relations/-","value":{
        "rel":"Microsoft.VSTS.Common.TestedBy-Forward",
        "url":f"{org}/_apis/wit/workItems/{pbi_id}",
        "attributes":{"comment":"Bug detected by /qa-test"}
    }}
]
print(json.dumps(patch))
PYEOF
)

curl -s -X POST \
  -H "Authorization: Bearer ${ADO_TOKEN}" \
  -H "Content-Type: application/json-patch+json" \
  "${ADO_ORG_URL}/${ADO_PROJECT_ENC}/_apis/wit/workitems/\$Bug?api-version=7.1" \
  -d "${PATCH_BODY}" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print('Bug created: #'+str(d['id']))"
```

---

## Step 9 — Final Summary

```
✅ QA Agent complete.

Work items processed: N
  ✅ All tests passed: N items
  ❌ Failures found: N items
  ⚠️  No AC (smoke only): N items

ADO updates:
  • N specs attached
  • N junit.xml attached
  • N failure screenshots attached
  • N summary comments posted
  • N bugs created (linked to failing items)
```

---

## Notes

- **`requests` not required:** all ADO API calls use `curl` + `python3` stdlib only — no pip install needed.
- **Windows paths:** never use `/tmp/` or `C:\tmp\`. Use `$LOCALAPPDATA/Temp/claude-agents/` for scratch files.
- **Flaky tests:** Playwright retries are set in `playwright.config.ts`. A test that fails on attempt 1 but passes on retry is reported as flaky (not failed) — do not create a Bug for flaky-only results.
- **No AC:** if `AcceptanceCriteria` is empty, fall back to `System.Description` to infer what to test. Generate a smoke test at minimum (navigate to the relevant module, assert no 5xx errors).
- **storageState expiry:** Okta/SSO sessions typically expire in 8–24h. Always check before running tests.
- **Auth:** Azure CLI Bearer token is preferred over Basic PAT because it works without managing a PAT expiry date.
