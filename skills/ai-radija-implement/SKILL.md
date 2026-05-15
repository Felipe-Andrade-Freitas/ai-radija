---
description: Execute the implementation plan by processing all tasks with integrated TDD (red-green-refactor). Reads tasks.md and implements phase-by-phase with test-first approach. Use when user wants to implement, start coding, execute tasks, or mentions "implement".
user-invocable: true
disable-model-invocation: false
---

# Implement — Execute Implementation with TDD

Execute the implementation plan by processing all tasks defined in tasks.md, following a test-driven approach.

---

## Workflow

### Step 1 — Locate Feature and Load Context

1. Check `specs/feature.json` for the active feature directory
2. Load implementation context:
   - **REQUIRED**: `tasks.md` — the complete task list
   - **REQUIRED**: `plan.md` — tech stack, architecture, file structure
   - **IF EXISTS**: `data-model.md` — entities and relationships
   - **IF EXISTS**: `contracts/` — API specifications
   - **IF EXISTS**: `research.md` — technical decisions
   - **IF EXISTS**: `specs/memory/constitution.md` — governance constraints

### Step 2 — Check Checklists Status

If `<feature-dir>/checklists/` exists:
1. Scan all checklist files
2. Count total, completed, and incomplete items
3. Display status table:

   | Checklist | Total | Completed | Incomplete | Status |
   |-----------|-------|-----------|------------|--------|
   | ux.md     | 12    | 12        | 0          | PASS   |
   | test.md   | 8     | 5         | 3          | FAIL   |

4. If any incomplete: **STOP** and ask user to proceed or fix first
5. If all complete: proceed automatically

### Step 3 — Project Setup Verification

Create/verify ignore files based on the project setup:
- Check if git repo → verify `.gitignore`
- Check if Docker → verify `.dockerignore`
- Check linting configs → verify ignore patterns
- Add missing critical patterns for the detected tech stack

### Step 4 — Parse Task Structure

Extract from `tasks.md`:
- Task phases (Setup, Foundational, User Stories, Polish)
- Task dependencies (sequential vs parallel)
- Task details (ID, description, file paths, [P] markers)

### Step 5 — Execute with TDD Integration

For each phase, follow the test-driven approach:

**Setup & Foundational phases**: Execute tasks directly (no TDD needed for infrastructure).

**User Story phases** — For each task:

1. **RED**: If a test plan exists (from `/ai-radija-tdd`), write the test first
   - Create test file at the appropriate path
   - Test should fail (the implementation doesn't exist yet)
   - Verify the test actually fails

2. **GREEN**: Implement the minimum code to make the test pass
   - Follow the task description and file path
   - Write only enough code to pass the test
   - Verify the test passes

3. **REFACTOR**: Clean up without changing behavior
   - Extract duplication
   - Apply SOLID principles where natural
   - Run tests to confirm nothing broke

**If no test plan exists**: Implement normally but suggest running `/ai-radija-tdd` for critical paths.

**Polish phase**: Execute cleanup, documentation, and hardening tasks.

### Step 6 — Phase Validation

After each phase:
1. Run the project's test suite (detect: `npm test`, `pytest`, `dotnet test`, `cargo test`, `go test`, etc.)
2. Verify tests pass
3. Mark completed tasks as `[X]` in `tasks.md`
4. Report phase completion status

### Step 7 — Progress Tracking

- Report progress after each completed task
- Halt on non-parallel task failure
- For parallel tasks [P]: continue with successful ones, report failures
- **IMPORTANT**: Mark completed tasks as `[X]` in tasks.md immediately

### Step 8 — Completion Validation

1. Verify all required tasks are completed
2. Check that implemented features match the specification
3. Validate tests pass and coverage meets requirements
4. Report final status with summary of completed work
5. Suggest next step: `/ai-radija-pr-ready` to validate branch and create PR

---

## Execution Rules

- **Phase-by-phase**: Complete each phase before moving to the next
- **Respect dependencies**: Sequential tasks in order, parallel tasks [P] together
- **TDD for user stories**: RED → GREEN → REFACTOR cycle
- **File-based coordination**: Tasks on same files run sequentially
- **Validation checkpoints**: Verify each phase before proceeding
- If tasks.md is incomplete, suggest running `/ai-radija-tasks` first
