---
description: Create or update a feature specification from a natural language description. Generates a structured spec with user stories, requirements, and success criteria. Use when user wants to specify a feature, create a spec, describe what to build, or mentions "specify".
user-invocable: true
disable-model-invocation: false
---

# Specify — Feature Specification

Create a structured feature specification from a natural language description. Focus on **WHAT** users need and **WHY** — never HOW to implement.

---

## Template Resolution

This skill uses a spec template for generating the specification artifact:
1. Check `specs/.templates/spec-template.md` in the project root (project custom)
2. If the user provided a template in the prompt, use that
3. Fall back to the **Default Spec Template** at the end of this file

---

## Workflow

### Step 1 — Generate Feature Short Name

Analyze the feature description and create a 2-4 word short name:
- Use action-noun format (e.g., "user-auth", "analytics-dashboard")
- Preserve technical terms and acronyms
- Examples:
  - "I want to add user authentication" → `user-auth`
  - "Implement OAuth2 integration for the API" → `oauth2-api-integration`
  - "Fix payment processing timeout bug" → `fix-payment-timeout`

### Step 2 — Create Spec Feature Directory

Specs live under `specs/` unless the user explicitly provides a different directory.

**Resolution order:**
1. If user explicitly provides a directory, use it
2. Otherwise, auto-generate under `specs/`:
   - Scan existing directories in `specs/` and determine next sequential number
   - Construct: `specs/<NNN>-<short-name>` (e.g., `specs/003-user-auth`)

Create:
- `mkdir -p specs/<directory-name>`
- Copy the resolved template to `specs/<directory-name>/spec.md`
- Persist path to `specs/feature.json`:
  ```json
  { "feature_directory": "specs/<directory-name>" }
  ```

### Step 3 — Parse and Extract

1. Parse user description from arguments
   - If empty: ask the user what feature they want to specify
2. Extract key concepts: actors, actions, data, constraints
3. For unclear aspects:
   - Make informed guesses based on context and industry standards
   - Only mark with `[NEEDS CLARIFICATION: specific question]` if:
     - The choice significantly impacts scope or UX
     - Multiple reasonable interpretations exist
     - No reasonable default exists
   - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
   - Prioritize: scope > security/privacy > user experience > technical details

### Step 4 — Write the Specification

Fill the template structure with concrete details:
- User Scenarios & Testing section with prioritized user stories
- Functional Requirements (each must be testable)
- Success Criteria (measurable, technology-agnostic)
- Key Entities (if data is involved)
- Assumptions (document reasonable defaults)

### Step 5 — Specification Quality Validation

After writing, validate against quality criteria:

1. Create `specs/<directory>/checklists/requirements.md` with validation items:
   - No implementation details (languages, frameworks, APIs)
   - Focused on user value and business needs
   - Written for non-technical stakeholders
   - Requirements are testable and unambiguous
   - Success criteria are measurable and technology-agnostic
   - Edge cases identified
   - Scope clearly bounded

2. Run validation:
   - If all pass → proceed to step 6
   - If items fail → fix and re-validate (max 3 iterations)
   - If `[NEEDS CLARIFICATION]` markers remain (max 3):
     - Present each as a question with options table:

       ```markdown
       ## Question [N]: [Topic]

       **Context**: [Quote relevant spec section]
       **What we need to know**: [Specific question]

       | Option | Answer | Implications |
       |--------|--------|--------------|
       | A      | [First option] | [What this means] |
       | B      | [Second option] | [What this means] |
       | C      | [Third option] | [What this means] |

       **Your choice**: _[Wait for user response]_
       ```

     - After user answers, update spec replacing each marker

### Step 6 — Report Completion

Report to user:
- Feature directory path
- Spec file path
- Checklist results summary
- Suggest next step: `/ai-radija-clarify` to reduce ambiguities, or `/ai-radija-plan` to create technical plan

---

## Guidelines

- Focus on **WHAT** users need and **WHY**
- Avoid HOW to implement (no tech stack, APIs, code structure)
- Written for business stakeholders, not developers
- Maximum 3 `[NEEDS CLARIFICATION]` markers
- Every requirement must be testable
- Success criteria must be measurable and technology-agnostic

### Reasonable Defaults (don't ask about these)

- Data retention: Industry-standard practices
- Performance targets: Standard web/mobile expectations
- Error handling: User-friendly messages with fallbacks
- Authentication: Standard session-based or OAuth2 for web apps
- Integration patterns: Project-appropriate (REST/GraphQL for web, CLI args for tools)

### Success Criteria Guidelines

**Good**: "Users complete checkout in under 3 minutes", "System supports 10,000 concurrent users"
**Bad**: "API response time under 200ms", "Redis cache hit rate above 80%"

---

## Default Spec Template

```markdown
# Feature Specification: [FEATURE NAME]

**Branch**: `[###-feature-name]` | **Created**: [DATE] | **Status**: Draft

## User Scenarios & Testing

User stories are prioritized journeys. Each MUST be independently testable.

### User Story 1 — [Brief Title] (P1)

[User journey in plain language]

**Why P1**: [Value and priority rationale]

**Independent Test**: [How to test this story alone]

**Acceptance Scenarios**:

1. **Given** [state], **When** [action], **Then** [outcome]
2. **Given** [state], **When** [action], **Then** [outcome]

---

### User Story 2 — [Brief Title] (P2)

[User journey in plain language]

**Why P2**: [Value and priority rationale]

**Independent Test**: [How to test this story alone]

**Acceptance Scenarios**:

1. **Given** [state], **When** [action], **Then** [outcome]

---

### Edge Cases

- What happens when [boundary condition]?
- How does the system handle [error scenario]?

## Requirements

### Functional Requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: System MUST [specific capability]

### Key Entities

Include only if the feature involves data.

- **[Entity 1]**: [What it represents, key attributes]
- **[Entity 2]**: [What it represents, relationships]

## Success Criteria

Measurable, technology-agnostic outcomes only.

- **SC-001**: [User-facing metric]
- **SC-002**: [Scale metric]
- **SC-003**: [Quality metric]

## Assumptions

- [Target users assumption]
- [Scope boundary assumption]
- [Dependency on existing system/service]
```
