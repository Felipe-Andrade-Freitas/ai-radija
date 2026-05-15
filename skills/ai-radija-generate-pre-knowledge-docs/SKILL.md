---
model: claude-opus-4-7

description: Transform an AI agent into a 10/10 expert on any codebase, then extract that knowledge into a reusable documentation suite that permanently replaces source code access for evaluation and spec-writing purposes.

user-invocable: true

---
## 🧠 CODEBASE DEEP ANALYSIS & DOCUMENTATION SUITE

**Purpose:** This procedure transform an AI agent into a 10/10 expert on any codebase, then extract that knowledge into a reusable documentation suite that permanently replaces source code access for evaluation and spec-writing purposes.

---
```
You are onboarding as a senior engineer on this codebase. Your mission is a 
multi-pass deep analysis — iterating until you reach genuine expert-level 
understanding — then producing a complete documentation suite from that knowledge.

The documentation suite you produce will be the ONLY reference available to a 
requirements portal and its users. Source code will NOT be accessible after this 
task completes. Every field name, type, length constraint, error code, enum value, 
and procedure parameter must be extracted and recorded now — nothing can be 
recovered later. Write as if closing the door on the codebase forever.

DO NOT proceed to Phase 2 until you have explicitly confirmed a readiness score 
of 9 or 10 across ALL dimensions. This is a hard gate, not a suggestion.

═══════════════════════════════════════════════
PHASE 1 — ITERATIVE DEEP ANALYSIS
(mandatory loop — exit only when ALL dimensions score 9–10)
═══════════════════════════════════════════════

Perform a full codebase scan. After each pass, self-score from 0–10 across these 
dimensions, identify your weakest areas, and re-analyze those areas specifically.

SCORED DIMENSIONS:
  • Architecture & design patterns
  • Data models & persistence layer
  • Business logic & domain rules
  • API contracts & integration points
  • Authentication, authorization & security model
  • Configuration, environment & deployment pipeline
  • Error handling, logging & observability
  • Testing strategy & coverage
  • Performance considerations & bottlenecks
  • Tech debt, known issues & improvement opportunities

LOOP RULES:
  ① After each pass, output a score table in this exact format:

      [PASS N — ANALYSIS REPORT]
      ┌─────────────────────────────────────────────┬───────┬──────────────────────────────┐
      │ Dimension                                   │ Score │ Gap / What Still Needs Work  │
      ├─────────────────────────────────────────────┼───────┼──────────────────────────────┤
      │ Architecture & design patterns              │  X/10 │ ...                          │
      │ Data models & persistence layer             │  X/10 │ ...                          │
      │ Business logic & domain rules               │  X/10 │ ...                          │
      │ API contracts & integration points          │  X/10 │ ...                          │
      │ Auth, authorization & security model        │  X/10 │ ...                          │
      │ Configuration, environment & deployment     │  X/10 │ ...                          │
      │ Error handling, logging & observability     │  X/10 │ ...                          │
      │ Testing strategy & coverage                 │  X/10 │ ...                          │
      │ Performance considerations & bottlenecks    │  X/10 │ ...                          │
      │ Tech debt, known issues & improvements      │  X/10 │ ...                          │
      ├─────────────────────────────────────────────┼───────┼──────────────────────────────┤
      │ OVERALL READINESS                           │  X/10 │                              │
      └─────────────────────────────────────────────┴───────┴──────────────────────────────┘

  ② After the table, output one of two verdicts — no exceptions:

      ▸ If ANY dimension is below 9:
        "LOOP CONTINUES — Dimensions below threshold: [list them].
         Focusing next pass on: [specific files, modules, or areas to re-examine]."
        → Immediately begin the next pass. Do not wait for user input.

      ▸ If ALL dimensions are 9 or 10:
        "KNOWLEDGE LOOP COMPLETE. I understood the entire project in a scale of X/10."
        → Output nothing else. No summaries, no demonstrations, no elaborations.
        → Immediately and silently proceed to Phase 2.

  ③ Be ruthlessly honest. Do not inflate scores to exit the loop early.
     A score of 9 means: you could answer an expert's adversarial question on 
     that dimension without hesitation. A score of 10 means zero blind spots.

  ④ There is no maximum number of passes. Keep looping until the gate is met.

═══════════════════════════════════════════════
PHASE 2 — DOCUMENTATION SUITE
(only reachable after KNOWLEDGE LOOP COMPLETE verdict)
Produce 6 MANDATORY artifacts + up to 5 CONDITIONAL artifacts inside /docs.AI/
═══════════════════════════════════════════════

Once the loop exits, create a folder called docs.AI/ at the root of the project 
and generate the following files inside it. Do so silently — no commentary, 
no preamble, no explanation of what you are about to do. Just produce the files.

═══════════════════════════════════════════════
FILE NUMBERING CONVENTION  —  MANDATORY
═══════════════════════════════════════════════

Every file in docs.AI/ MUST be prefixed with a digit `1_` through `11_` matching
its position in the cold-start reading order an AI agent should follow. The
prefix has TWO purposes:
  (a) directory listings present the files in the order an agent should read
      them (1_README.AI.md sorts first, 9_OPERATIONAL_NOTES.md sorts last);
  (b) the prefix doubles as a stable, language-independent reference an agent
      can cite ("see file 4") even when the rest of the filename has been
      translated or renamed.

The numbering scheme is FIXED. Use these slots even if a Tier-B file is
skipped — DO NOT renumber to close the gap. Numbers track reading position,
not produced/skipped status.

  1_README.AI.md                   (Tier A — MANDATORY)  index + AI context
  2_GETTING_STARTED_BUSINESS.md    (Tier A — MANDATORY)  plain-language guide
  3_GETTING_STARTED.md             (Tier A — MANDATORY)  technical onboarding
  4_DECISION_LOG.md                (Tier B — CONDITIONAL) historical rationale
  5_SDK_SURFACE.md                 (Tier B — CONDITIONAL) private package surface
  6_REFERENCE_DATA.md              (Tier A — MANDATORY)  code-value catalog
  7_CONTRACTS_CATALOG.md           (Tier A — MANDATORY)  field-level contract ref
  8_EXAMPLES.md                    (Tier A — MANDATORY)  concrete JSON samples
  9_OPERATIONAL_NOTES.md           (Tier B — CONDITIONAL) ops / sizing / runbook
 10_SCREENS_INVENTORY.md           (Tier B — CONDITIONAL) UI screens → flow/perm/manager map
 11_DOMAIN_TO_TECHNICAL_MAP.md     (Tier B — CONDITIONAL) business concept → code artifact reverse lookup

TIER A (6 files) — produce regardless of project shape: 1, 2, 3, 6, 7, 8.
TIER B (5 files) — produce ONLY when the file's own applies-when criterion
                  is met by THIS project: 4, 5, 9, 10, 11.

For each Tier-B file you DO produce, add a normal DOCS_INDEX entry.
For each Tier-B file you DO NOT produce, add a one-line entry to
1_README.AI.md DOCS_INDEX in the form:

    docs.AI/<N>_<filename>.md   NOT PRODUCED — does not apply to this project.
                                Criterion: <copy the applies-when criterion>.

so future agents know the file was considered and consciously skipped, not
forgotten. NEVER renumber the remaining files to close a Tier-B gap — the
slot must stay reserved.

1_README.AI.md MUST open with a READING_ORDER section that prints the same
numbered list above (adapted to the project) and explicitly states the WHY
behind position 4 (DECISION_LOG before contracts/data). This guidance is
how future agents know what order to actually load the files in.

Files 10 and 11 sit LAST on purpose: they are reverse-lookup indexes that
depend on the technical foundation (1-3, 6-7) and the business glossary
(2) already being loaded. A spec-drafting bot reads 1-9 once at cold start,
then consults 10/11 on every charter to translate user-visible screen
names and business concepts into code artifacts.

──────────────────────────────────────────────
📄 docs.AI/3_GETTING_STARTED.md  (Developer Onboarding Guide + Architecture)
──────────────────────────────────────────────
A complete, advanced technical guide covering:

  SECTION 1 — PROJECT OVERVIEW
    - Project purpose and problem it solves
    - High-level summary of the tech stack with rationale

  SECTION 2 — ARCHITECTURE
    - Architecture diagrams (C4 model: Context → Container → Component)
    - High-level architecture diagram (ASCII or Mermaid)
    - Data flow diagrams for critical paths
    - Integration map (external systems, APIs, queues)
    - Sequence diagrams for the top 3 most complex workflows
    - Scalability and failure mode analysis
    - Security architecture overview

  SECTION 3 — TECH STACK & PROJECT STRUCTURE
    - Full tech stack with version details
    - Project directory structure walkthrough (key folders and their roles)
    - Core concepts and domain model explained

  SECTION 4 — LOCAL SETUP & RUNNING
    - Prerequisites
    - Step-by-step local environment setup
    - How to run, test, build and deploy
    - Configuration guide (env vars, feature flags, secrets)

  SECTION 5 — KEY WORKFLOWS & INTERNALS
    - Request lifecycle end-to-end
    - Core business logic walkthrough
    - Authentication & authorization flow

  SECTION 6 — OPERATIONS & CONTRIBUTION
    - Debugging tips and common pitfalls
    - Logging & observability guide
    - Contribution guidelines and code conventions
    - ⚠️ SECURITY NOTES (hardcoded secrets, weak auth, vulnerabilities found)

──────────────────────────────────────────────
📄 docs.AI/1_README.AI.md  (AI Agent Context File — token-optimized)
──────────────────────────────────────────────
A structured, AI-optimized context file to be loaded at the start of future 
sessions so any AI agent can skip re-analysis. Use a compact, machine-friendly 
format (not human prose). Include:

  PROJECT_IDENTITY: name, purpose, domain, scale
  TECH_STACK: language, frameworks, DBs, infra, versions
  ARCHITECTURE: pattern, layers, key modules and their responsibilities
  DATA_MODEL: core entities, key relationships, storage strategy
  API_SURFACE: endpoints/events/interfaces + auth model
  BUSINESS_RULES: critical domain logic and constraints
  ENTRY_POINTS: main files, bootstrapping order
  CONFIG: key env vars and what they control
  TEST_STRATEGY: test types, locations, how to run
  KNOWN_ISSUES: tech debt, fragile areas, gotchas
  ONBOARDING_TIPS: what tripped you up; what to study first
  DOCS_INDEX: brief description of each of the 6 files in docs.AI/ and when to use it
  READINESS_SCORE: final score table from Phase 1

──────────────────────────────────────────────
📄 docs.AI/2_GETTING_STARTED_BUSINESS.md  (Non-Technical Business Guide)
──────────────────────────────────────────────
A zero-jargon business guide for stakeholders, PMs, and domain experts:
  - What problem this system solves and for whom
  - Who the users are and what they can do
  - Core business processes and workflows (with real examples)
  - Key business rules and why they exist
  - How the system creates value
  - Glossary of domain terms
  - What success looks like (metrics, outcomes)
  - Limitations and known constraints from a business perspective
  - Roadmap hints or areas flagged for improvement

──────────────────────────────────────────────
📄 docs.AI/7_CONTRACTS_CATALOG.md  (Field-Level Contract Reference — source code replacement)
──────────────────────────────────────────────
The most critical artifact. This file permanently replaces source code access for 
anyone who needs to evaluate feasibility, write developer specs, or understand 
the exact shape of data flowing through the system.

A non-technical user or a requirements chatbot must be able to read this file 
and produce a complete, unambiguous developer specification — one that a developer 
can implement without ever opening the codebase.

Extract and document ALL of the following. Adapt section names to the tech stack 
(REST APIs use different terms than WCF/gRPC, but the intent is identical):

  PART 1 — FIELD SIZE / CONSTRAINT CONSTANTS
    - Every named constant that defines a field length, size limit, or boundary value
    - Name, numeric value, and which fields use it
    - Source: typically a Constants.cs, constants.py, config.go, or equivalent

  PART 2 — ENUMERATIONS & CODE TABLES
    - Every enum, union type, lookup table, or fixed code set used in contracts
    - For each: all values with their integer/string codes and business meaning
    - Include Oracle/DB/wire-format mappings where they differ from the code name

  PART 3 — PERMISSION / SCOPE / ROLE CATALOG
    - Every permission code, OAuth scope, or role constant
    - Which operations each one gates
    - Source: permission constants file, auth policy definitions, middleware config

  PART 4 — ERROR / FAULT / EXCEPTION CATALOG
    - Every named error type, fault contract, exception class, or HTTP error code
    - For each: the error code string, the default user-facing message, and the exact 
      business condition that triggers it (not just the name — the WHEN)
    - If some errors share a base type, document the base + all derived types
    - This is critical: a spec writer must know which error to use, not just that 
      errors exist

  PART 5 — OPERATION REQUEST CONTRACTS
    - For every public operation (endpoint, command, RPC method, event handler):
      • Operation name and which service/controller/handler owns it
      • Required permission/scope/role
      • Every request field: name, type, max length/size, mandatory (yes/no), 
        validation rules, and any notes on valid values or constraints
      • The downstream target it routes to (DB proc, external API, queue topic, etc.)
    - Group by service/domain boundary for navigability

  PART 6 — OPERATION RESPONSE CONTRACTS
    - For every public operation, every response field: name, type, order (if relevant),
      nullable, and what populates it
    - Include both success and error response shapes

  PART 7 — SHARED / REUSABLE ENTITY CONTRACTS
    - Every shared data type used across multiple operations: DTOs, value objects,
      embedded objects, base classes
    - For each: every field with type, max length, nullable, and validation rules
    - These are the building blocks that specs reference repeatedly

  PART 8 — PERSISTENCE / INTEGRATION SIGNATURES
    - For every database stored procedure, external API call, queue publish, or 
      integration point:
      • The exact name (proc name, endpoint URL pattern, topic name, etc.)
      • Every input parameter: name, type, size/length, direction, and which 
        contract field it maps from
      • Every output parameter: name, type, and what it represents
      • The error output convention (what signals success vs failure)
    - This is the "translation layer" spec writers need to determine whether an 
      existing integration already handles a new requirement or a new one is needed

  PART 9 — SPEC TEMPLATE
    - A fill-in-the-blank developer spec template tailored to THIS system's layers
    - Sections must map to the actual architecture (e.g., if 5-layer WCF: Contract → 
      Host → Manager → Repository → DB; if REST: Controller → Service → Repository → DB)
    - The template must be specific enough that filling it in produces a complete spec 
      requiring no further research

CONTRACTS_CATALOG QUALITY RULES:
  ✔ Every field must have its type and size constraint documented — "string" alone is 
    not enough; "string, max 50 chars" is the minimum acceptable entry
  ✔ Every error type must have a WHEN description — naming the error class is not enough
  ✔ Every persistence/integration call must have input AND output parameters documented
  ✔ Do not summarize or abbreviate — extract exact names, exact lengths, exact codes
  ✔ If a field maps to a constant (e.g., length = CompanyCodeLength = 5), resolve it 
    to its numeric value AND note the constant name for traceability
  ✔ Adapt part names and structure to the actual tech stack — the 9 parts above are 
    universal concepts, not rigid headings. A REST+Postgres system will look different 
    from a WCF+Oracle system, but must cover the same semantic ground

──────────────────────────────────────────────
📄 docs.AI/6_REFERENCE_DATA.md  (Code Values & Lookup Catalog)
──────────────────────────────────────────────
The catalog of every CODE VALUE the system uses but does not declare in its own 
source — everything a spec writer needs in order to populate a contract field 
without inventing values. Without this file, a requirements chatbot will 
hallucinate plausible-looking codes (action codes, issue codes, status codes, 
role codes) that do not actually exist in the live system.

Extract and document:

  SECTION 1 — IN-SOURCE ENUMS (EXHAUSTIVE)
    - Every enum / union type declared anywhere in the repo, with all values
    - For each value: the C# / TS / language-native name, the wire value
      (StringEnumConverter / serializer setting), and the DB/LOV value when
      the enum is persistence-mapped (e.g., [LovMapping("A")] in .NET).

  SECTION 2 — POLYMORPHIC DISCRIMINATOR CODES
    - Every discriminator value used by a polymorphic deserializer / type
      registry, mapped to its concrete type.
    - Flag any discriminator value that exists in the type hierarchy but is
      NOT registered in the deserializer.

  SECTION 3 — HARDCODED LITERAL CODES (EXHAUSTIVE)
    - Every literal string that drives a business decision: issue codes,
      action codes, service codes, owner codes, source codes, key-mapping
      types, event types, status codes, requester ids, role codes, etc.
    - For each: the code, every source file/line where it appears, the
      meaning. If only ONE value of a family is referenced (e.g., only
      "IQ_DEDUCT" of the issue-code universe), say so explicitly — this is
      a 🟡 partial enumeration that needs DBA enrichment.

  SECTION 4 — EXTERNAL/INFRASTRUCTURE CODES
    - APIM named values (with secret/non-secret flag), backend ids, fragment
      ids, URL templates, environment variables — anything the system relies
      on but defines outside source code (Bicep / Terraform / CloudFormation
      / k8s manifests / pipeline config).

  SECTION 5 — REGION / ENVIRONMENT / TENANT CODES
    - Every region code, region-path code, tenant code, and environment
      enumeration the deployment supports, with the regions/envs where each
      operation is enabled or disabled.

  SECTION 6 — RATE LIMITS, SIZES, TIMEOUTS, CRON SCHEDULES
    - Every numeric operational constant: rate limits, max body sizes,
      page sizes, default page sizes, downstream timeouts, retry counts,
      cron expressions, web-test frequencies.

  SECTION 7 — ERROR-CODE RANGES (RESERVED + USED)
    - For each named error / fault code emitted by this system: which range
      it occupies, which codes are used today, and which are still free for
      future expansion (so spec writers can reserve safely).

  SECTION 8 — HOW TO REFRESH 🟡 ROWS
    - For each "DBA-enrichment required" / "external-system enrichment
      required" placeholder, name the authoritative source (DB query, sibling
      repo, runtime registry, vendor docs) and how to obtain the missing data.

REFERENCE_DATA QUALITY RULES:
  ✔ Be HONEST about partial enumeration. Mark every incomplete row with a
    visible flag (e.g. 🟡 DBA-enrichment required) — do NOT invent codes.
  ✔ Distinguish PRODUCTION codes from TEST FIXTURE codes (unit tests,
    Postman collections). Test fixtures are NOT authoritative.
  ✔ For each placeholder, name the source of truth (specific DB table,
    sibling repo, runtime registry).
  ✔ Re-resolve any "secret" code values to "🔐 redacted" — never include
    real secrets even if you find them committed to the repo.

──────────────────────────────────────────────
📄 docs.AI/8_EXAMPLES.md  (Concrete Request/Response Samples)
──────────────────────────────────────────────
A complete catalog of REALISTIC (but anonymized) request/response samples
for every operation exposed by the system, plus the most important end-to-end
narrative. Without this file, non-technical stakeholders cannot match their
"I want it to look like this" mental model to the field-level contracts.

Produce:

  - For every public operation: at least one success request + one success
    response + at least one error response. Use the most common error path.
  - For every operation that has variants (different content types, different
    region behaviors, different sub-modes): one example per variant.
  - For polymorphic responses: one example per discriminator value.
  - For gateway-only / proxy-only operations (no in-system implementation):
    BOTH the inbound public request AND the transformed body the gateway
    forwards downstream, so a spec writer can see the translation.
  - For background operations (timers, queue handlers, schedulers): the input
    message shape and the outcome shape (even when there is no HTTP response).
  - For health/operational endpoints: the canonical request + response.
  - At least one END-TO-END NARRATIVE example: a multi-call user journey
    that strings together the operations a real customer would trigger,
    annotated with timing and the side effects each step produces.

EXAMPLES QUALITY RULES:
  ✔ Anonymize EVERYTHING: no real PII, no real IMEI/serial numbers, no real
    Okta tokens, no real claim/policy numbers from production, no real
    customer names or emails. Use obviously-fabricated values that still
    look syntactically valid.
  ✔ Field names and casing must match 7_CONTRACTS_CATALOG.md exactly. The
    JSON must round-trip through the system's serializer.
  ✔ Cross-reference: every code value used in an example must exist in
    6_REFERENCE_DATA.md (or be flagged as illustrative).
  ✔ Include the actual HTTP request line + headers (Authorization,
    Content-Type, gateway sub key, correlation id) so the example is
    copy-pasteable into Postman/curl.
  ✔ For errors, show the actual response body the system emits — including
    middleware-wrapped error envelopes — not a generic "error message goes
    here" stub.
  ✔ NO real secrets in headers. Use placeholder tokens like "<jwt>" /
    "<sub key>" — even if a real value appears in a Postman collection in
    the repo, redact it.

──────────────────────────────────────────────
📄 docs.AI/5_SDK_SURFACE.md  (Private SDK Reference)         — CONDITIONAL
──────────────────────────────────────────────
APPLIES WHEN — ALL of the following are true:
  ① The project depends on one or more private/proprietary/internal NuGet,
    npm, Maven, pip, or equivalent packages whose source is NOT in the repo.
  ② The behavior of the project meaningfully depends on those packages —
    not just transitive use. "Meaningful" means: extension methods called,
    types instantiated, interfaces implemented, or APIs called from
    application code (not just transitive runtime dependencies).
  ③ A spec writer cannot fulfill a typical feature charter without knowing
    those packages' public surface.

SKIP WHEN — any of:
  ✘ The project only depends on widely-documented public packages (e.g.,
    Newtonsoft.Json, Express, React, FastAPI, Spring Boot, Django) whose
    docs are first-hit on the open web.
  ✘ The project IS the SDK / library / framework (its own surface is
    already covered by 7_CONTRACTS_CATALOG.md).
  ✘ The project's dependencies are all open-source and a typical engineer
    can `gh open` them in one click.

CONTENT — when producing:

  SECTION 0 — Pinned package versions
    - Every private/proprietary package with its exact pinned version,
      and where the pin lives (csproj / package.json / pom.xml / etc.).

  SECTION 1..N — One section per package
    For each: list every member ACTUALLY USED from this project:
      - extension methods (signature + behavior observed at call sites)
      - public methods / static factories (signature + return type)
      - constructed types (constructor signatures)
      - DTOs (every field referenced in source — name + observed type)
      - enums (every value referenced — name + observed wire/DB mapping)
      - exceptions (constructors observed, where thrown, how mapped to HTTP)
      - attributes / annotations (where applied)
    Then a "NOT OBSERVED" subsection listing the surface that LIKELY exists
    in the package but is not used here — flagged 🟡 with the path to the
    cached package for reflection (e.g.
    `%USERPROFILE%/.nuget/packages/<id>/<version>/lib/...`).

  FINAL SECTION — How the project wires the SDK
    A trace of the bootstrap (Program.cs / index.ts / main.go / etc.)
    showing the order in which SDK members are constructed and registered.

  FINAL SECTION — Refresh procedure
    Concrete steps to re-derive this document when a package version is
    bumped (which reflection tool, which directory, which diff to apply).

SDK_SURFACE QUALITY RULES:
  ✔ ONLY document what you can confirm is used (grep the source).
    Speculation is fine ONLY when explicitly flagged 🟡 with the source
    that would resolve it.
  ✔ For each used member, point to at least one call site (file:line) so a
    reviewer can verify.
  ✔ Distinguish "confirmed by use" from "inferred from usage pattern" —
    e.g., a `Task<T>` return type is confirmed only if the code does
    `await x.Method()` or `T result = await x.Method()`; a discarded
    `await x.Method()` only confirms it returns a `Task`.

──────────────────────────────────────────────
📄 docs.AI/4_DECISION_LOG.md  (Historical Rationale)         — CONDITIONAL
──────────────────────────────────────────────
APPLIES WHEN — ANY of the following are true (low bar — most non-trivial
codebases meet at least one):
  ① The codebase contains kill-switches or feature flags hardcoded to a
    specific value (with no env-driven toggle).
  ② There are #pragma disable / // eslint-disable / # noqa / similar
    suppression directives deliberately left in place.
  ③ Hardcoded "magic" values (string constants, role codes, company codes,
    URLs) that a fresh reader would reasonably want to parameterize.
  ④ Workarounds for known downstream bugs (e.g., "this is a string
    instead of an int because the proc fails with ints").
  ⑤ Dead-looking code paths that are intentionally kept (unused params,
    declared-but-unused config keys, vestigial pipeline parameters).
  ⑥ Half-implemented features behind "TODO" / "future enhancement"
    comments that aren't actually scheduled.

SKIP WHEN:
  ✘ Pristine greenfield codebase with no legacy decisions, no
    suppressions, no workarounds, no half-implementations. (Rare — when
    in doubt, produce the file with whatever entries do exist; an empty
    or one-entry log is still useful.)

CONTENT — when producing:

  ENTRY FORMAT (use the same five fields for every entry):
    - What         — observation in code/config, in one sentence.
    - Where        — file:line (approximate is fine).
    - Why (observed) — what code, comments, or commit evidence tell us.
    - Status       — `confirmed` | `inferred` | `🟡 needs-human-input`.
    - Implication for new specs — how a charter writer should treat this.

  GROUP entries by:
    1. Code-level decisions (per-file rationale)
    2. Configuration / policy-level decisions (gateway / IaC / pipeline)
    3. Repo / deployment-level decisions
    4. Conventions deliberately NOT followed (missing README, no
       integration tests, no .editorconfig, etc.)

  FINAL SECTION — How to extend this log
    A short list of triggers for adding a new entry (introducing a new
    suppression, hardcoding a value, skipping a deprecation, adding a
    workaround, leaving a TODO).

DECISION_LOG QUALITY RULES:
  ✔ Mark *every* entry with a status. Do not let confidence ambiguity hide.
  ✔ The "Implication for new specs" line is the most valuable field — it
    is what stops a spec writer from "fixing" a deliberate choice. Never
    skip it.
  ✔ Cross-reference: when the same fact appears in KNOWN_ISSUES (README.AI)
    or SECURITY NOTES (GETTING_STARTED), put the canonical entry HERE and
    link the other docs back to it.

──────────────────────────────────────────────
📄 docs.AI/9_OPERATIONAL_NOTES.md  (Ops & Sizing Reference)  — CONDITIONAL
──────────────────────────────────────────────
APPLIES WHEN — ALL of the following are true:
  ① The project is a deployed service / scheduled job / runtime workload
    (NOT a library / SDK / CLI tool).
  ② The project has observable runtime concerns: latency, throughput,
    rate limits, retries, cron schedules, dependency timeouts, scale
    settings, health probes.
  ③ A spec writer's charter could plausibly hit a feasibility/sizing
    question (capacity, SLO, cost, regional reach).

SKIP WHEN:
  ✘ The project is a pure library / SDK consumed only by other code (no
    deployment of its own).
  ✘ The project is a dev tool or one-off script with no production
    presence.
  ✘ The project is a static asset / docs site with no business logic.

CONTENT — when producing:

  SECTION 1 — Topology & footprint (compute / hosting / regions / DR slots)
  SECTION 2 — Health, warmup, probing (timers, web tests, liveness/readiness)
  SECTION 3 — Limits, sizes, timeouts (every numeric operational constant
              recovered from code/IaC/policy)
  SECTION 4 — Telemetry & observability (sinks, sampling, correlation,
              dashboards/queries known)
  SECTION 5 — Throughput, latency, error baselines (mostly 🟡 — flag with
              the App Insights / Grafana / Dynatrace query that would
              produce the real number)
  SECTION 6 — Capacity & scale ceiling (with the formula showing how the
              ceiling is derived from observable parameters)
  SECTION 7 — Dependencies & failure modes (per dependency: timeout,
              failure handling, blast radius)
  SECTION 8 — Known operational gotchas (cross-ref to DECISION_LOG)
  SECTION 9 — Runbook anchors (symptom → first-look query / dashboard /
              dependency to check). Flag 🟡 if the project's full runbook
              lives outside this repo.
  SECTION 10 — Refresh procedure (what triggers an update to §1-§4)

OPERATIONAL_NOTES QUALITY RULES:
  ✔ Be VICIOUSLY honest about the recoverable/non-recoverable split.
    Anything you cannot read from the repo is 🟡, full stop. Never
    quote a "typical" SLO from training data as if it were this
    project's SLO.
  ✔ Every 🟡 row must name the authoritative source (App Insights /
    Grafana / Datadog / Confluence / ops wiki / SRE team) so a future
    reviewer knows where to look.
  ✔ For each dependency in §7, you MUST list the blast radius
    ("hard dependency — all endpoints fail" vs "soft dependency —
    feature X degrades to empty response"). Spec writers use this to
    decide whether new features can rely on the dependency.

──────────────────────────────────────────────
📄 docs.AI/10_SCREENS_INVENTORY.md  (UI-to-architecture map)  — CONDITIONAL
──────────────────────────────────────────────
APPLIES WHEN — ALL of the following are true:
  ① The project has a user-facing UI surface — web pages (.aspx /
    .razor / .cshtml / React/Vue/Angular routes / HTML templates),
    mobile screens (.xaml / SwiftUI / Compose / Flutter widgets), or
    desktop forms (.xaml / WinForms / WPF) — NOT just a CLI or pure
    API service.
  ② There are MORE THAN ~15 distinct screens/pages/routes a user can
    reach. A 2-page admin panel doesn't justify this file; a back-
    office app with dozens of forms does.
  ③ A charter from a functional user can plausibly name a screen by
    its user-visible label ("modify the X form", "add a column to the
    Y grid"). If charters always come in API terms, skip this file.

SKIP WHEN — any of:
  ✘ The project is a pure API / library / SDK / CLI / batch job with
    no UI surface.
  ✘ The UI is generated entirely from a schema (e.g., GraphiQL,
    Swagger UI) and has no first-class screens.
  ✘ Total screen count is small enough (≤ ~15) that 3_GETTING_STARTED
    can describe them inline without a dedicated catalog.

CONTENT — when producing:

  SECTION 1 — How to use this file
    A worked example: a charter → search by user-visible name → find
    the page row → follow the columns to flow/permission/manager/BO.

  SECTION 2 — Navigation flows / routing (if the framework defines
    named flows or routes)
    - List every named flow / route group with: entry page, purpose,
      key transitions
    - For state-machine-driven UIs (WebForms with NavController,
      Angular Router, React Router, mobile NavHost), the flow
      definition file is the source of truth — extract its URL/route
      bindings once, then reference them from §3
    - For UIs without named flows (e.g., simple multi-page admin),
      skip §2 and let §3 stand alone

  SECTION 3 — Tier 1 detail (high-traffic / in-flow screens)
    One row per page with columns:
      • Page (relative path)
      • Flow (state) — if framework has named flows
      • Purpose — what the user does here
      • Permission — best-effort grep of authorization attribute /
        guard / middleware; mark 🟡 if not confirmed
      • Manager / BO / controller / view-model — the most-likely
        backing class
      • Notes — wizard step, modal-only behavior, master form with
        many tabs, shared widget, etc.
    Group by domain bucket (Certificates, Claims, Admin, etc.).
    Cover the screens that any plausible business charter would
    name. The cap is judgment — 50-100 is typical; over 100 is fine
    when the codebase is genuinely UI-heavy.

  SECTION 4..N — Tier 2 categorized listings
    Pages that follow rigid CRUD/list patterns and aren't worth a row
    each. List by family (e.g., "Equipment admin: Make/Model/
    Manufacturer + List variants for each"). The bot's lookup
    strategy: find the family, open the matching form.

  SECTION (last but one) — Quick lookup tables
    "Which page should I modify for X?" — a charter-keyword → page
    cheat sheet. THIS IS THE MOST USED PART by the bot.

  SECTION (last) — Known gaps & limitations
    Be honest: permission columns that are 🟡, UserControl/component
    libraries not covered, reports listed by name only, etc.

SCREENS_INVENTORY QUALITY RULES:
  ✔ Cover ≥ 80% of pages a functional user would name in a charter.
    Don't aim for 100% of all pages — internal admin tooling and
    test pages aren't worth row-detail.
  ✔ Permission column may be 🟡 if the framework uses runtime/
    DB-driven authorization (not class-level attributes). Document
    the resolution mechanism instead of inventing values.
  ✔ Group by domain bucket — alphabetical-by-filename is useless
    when a bot is searching by business word.
  ✔ Include a "Quick lookup" section. Charters arrive in business
    language; the bot needs a keyword → page index.
  ✔ Never invent a permission code, Manager name, or flow name. If
    a column can't be confirmed, write `🟡` or `(none observed)`.
  ✔ Cross-reference 6_REFERENCE_DATA (codes) and 11_DOMAIN_TO_
    TECHNICAL_MAP (the inverse lookup) by their numeric filename.

──────────────────────────────────────────────
📄 docs.AI/11_DOMAIN_TO_TECHNICAL_MAP.md  (Business concept → code artifact)  — CONDITIONAL
──────────────────────────────────────────────
APPLIES WHEN — ALL of the following are true:
  ① The project has a non-trivial business domain — i.e.,
    2_GETTING_STARTED_BUSINESS.md's glossary carries MORE THAN ~10
    distinct domain terms (Certificate, Claim, Dealer, ServiceCenter,
    etc.), not just CRUD-of-one-entity.
  ② There is meaningful INDIRECTION between business names and
    technical artifact names — i.e., the business says "premium auto-
    payment" but the code is split across CertificateManager,
    ClaimManager, External Token Manager, and ELP_TOKEN_REF table.
    If business terms map 1:1 to identically-named classes, the map
    is redundant (the codebase IS the map).
  ③ A spec-writing bot benefits from a reverse lookup — i.e., the
    portal will receive charters like "where does X live in code?"
    and the natural answer requires touching 3-5 layers.

SKIP WHEN — any of:
  ✘ The project is CRUD-on-one-entity (e.g., a Users service)
    where the business term = the class name.
  ✘ The codebase already names its classes by business concept with
    no indirection (e.g., DDD-strict project: `Customer.cs` IS the
    Customer concept's home, end of story).
  ✘ The glossary is < 10 terms AND each term is documented inline in
    2_GETTING_STARTED_BUSINESS.md with file pointers.

CONTENT — when producing:

  SECTION 1 — How to use this file
    A worked example: charter mentions a business concept → look up
    in §3 → follow the row to BO/Manager/DAL/database/screens.

  SECTION 2 — Alphabetical index of mapped concepts
    Flat list of every concept in this map, so the bot can verify
    coverage at a glance.

  SECTION 3 — Concepts by domain bucket
    For each concept, a compact block:
      • BO / domain class file (or equivalent — model file, entity)
      • Manager / service / use-case class
      • DAL / repository / data-access class
      • Persistence target — database package/schema, table name(s),
        external service identifier
      • Primary screens (cross-link to 10_SCREENS_INVENTORY by path)
      • Key code-value family (cross-link to 6_REFERENCE_DATA by §)
      • Public API surface — WCF op / REST endpoint / event topic
        (cross-link to 7_CONTRACTS_CATALOG by §)
      • Notes — subtleties, parent-child relations, Strategy pattern
        use, where logic is split
    Group buckets by lifecycle:
      • Core aggregate roots (the "things" the system manages)
      • Each root's lifecycle satellites (cancellation, endorsement,
        replacement, etc.)
      • Cross-cutting concerns (User, Permission, Address, Comment)
      • External integrations (one row per partner / system)

  SECTION 4 — Cross-cutting patterns (where they live)
    A table of architectural patterns + their canonical implementation
    file: validation framework, audit-field framework, state machine,
    caching, DI resolution, ID conversion, encryption, etc. The bot
    uses this to answer "how does X pattern work here?" without
    re-deriving it from scratch.

  SECTION 5 — Concepts NOT confidently mapped (🟡)
    Be brutally honest. List glossary terms where the BO/Manager/DAL
    couldn't be pinned to a single file. Charters touching these
    rows SHOULD be flagged for human review.

DOMAIN_TO_TECHNICAL_MAP QUALITY RULES:
  ✔ Cover ≥ 90% of the glossary terms in 2_GETTING_STARTED_BUSINESS.md.
    Anything skipped goes in §5 with the reason.
  ✔ Never invent a class name or file path. If a concept's
    canonical home doesn't exist as a single class (the logic is
    spread), say so in Notes.
  ✔ Cross-reference 10_SCREENS_INVENTORY (screens column),
    6_REFERENCE_DATA (codes), 7_CONTRACTS_CATALOG (WCF/REST DTOs),
    and 2_GETTING_STARTED_BUSINESS (glossary) by numeric filename
    in every row.
  ✔ Distinguish "the concept's BO" from "the concept's parent BO".
    For sub-concepts (e.g., ClaimAuthorization is part of Claim's
    aggregate), name BOTH and note the parent-child relationship.
  ✔ For each external integration concept, name the project/folder
    + the auth model + the protocol — a charter on a new partner
    integration MUST be able to copy an existing template.

═══════════════════════════════════════════════
RULES FOR THIS ENTIRE TASK
═══════════════════════════════════════════════

  ✔ Phase 2 is strictly gated — it cannot begin until KNOWLEDGE LOOP COMPLETE 
    is declared with ALL dimensions at 9 or 10.
  ✔ The loop must run autonomously — do not pause and ask the user to continue.
  ✔ Never skip the iterative phase — always show the full score table each pass.
  ✔ Be ruthlessly honest about gaps; flag anything unconfirmable from the code.
  ✔ All docs must reflect the actual codebase, not generic boilerplate.
  ✔ All output files must be saved inside the docs.AI/ folder at project root.
  ✔ README.AI.md must be self-contained — a future AI session loading only that file 
    should be able to answer advanced questions without re-scanning the repo.
  ✔ Every file inside docs.AI/ MUST carry its `N_` numeric prefix (1 through
    11) matching the cold-start reading order defined in the FILE NUMBERING
    CONVENTION block above. No file may be written without its prefix. No
    prefix may be reused or skipped to close a Tier-B gap.
  ✔ 1_README.AI.md must include a DOCS_INDEX covering every Tier-A file plus an
    entry for every Tier-B file — slots 4, 5, 9, 10, and 11 — each pointing at
    the produced file OR explicitly recording "NOT PRODUCED — does not apply"
    with the criterion.
  ✔ 1_README.AI.md must carry the final READINESS_SCORE as proof of depth
    reached.
  ✔ 1_README.AI.md must open with a READING_ORDER section that re-prints the
    1-through-9 sequence and names the WHY-before-WHAT principle (file 4 sits
    before files 6/7/8 on purpose).
  ✔ Flag any security-sensitive findings (hardcoded secrets, weak auth, etc.)
    in the ⚠️ SECURITY NOTES section of 3_GETTING_STARTED.md.
  ✔ 7_CONTRACTS_CATALOG.md is mandatory — it is not optional and cannot be
    skipped, regardless of the system's tech stack or size.
  ✔ 7_CONTRACTS_CATALOG.md must be complete enough that a developer can write
    an implementation without opening the source code. If it is not, Phase 2
    is not done.
  ✔ 6_REFERENCE_DATA.md is mandatory — without it, a downstream requirements
    chatbot will hallucinate plausible-looking codes that do not exist. Partial
    enumerations must be explicitly flagged (🟡), not silently omitted.
  ✔ 8_EXAMPLES.md is mandatory — non-technical stakeholders communicate by
    example, not by field table. Every public operation needs at least one
    success + one error sample.
  ✔ For each Tier-B file (4_DECISION_LOG.md, 5_SDK_SURFACE.md,
    9_OPERATIONAL_NOTES.md, 10_SCREENS_INVENTORY.md,
    11_DOMAIN_TO_TECHNICAL_MAP.md): evaluate the applies-when criterion
    against the project's actual shape. Decide PRODUCE or SKIP before writing
    any docs. When in doubt, PRODUCE — a thin Tier-B doc is more useful than
    no doc. Skipping 10 or 11 is especially common: a pure API/library has
    no screens (skip 10); a CRUD-of-one-entity service has no business
    indirection (skip 11). Skipping is normal; silent omission is not.
  ✔ Decisions to SKIP a Tier-B file MUST be recorded in 1_README.AI.md
    DOCS_INDEX with the criterion (so future agents can re-evaluate when the
    project evolves). Never silently omit a Tier-B file. The numeric slot
    stays reserved even when skipped.
  ✔ All produced artifacts must reference each other consistently and ALWAYS
    by their numbered filename: codes in 8_EXAMPLES.md must exist in
    6_REFERENCE_DATA.md; fields in 8_EXAMPLES.md must match
    7_CONTRACTS_CATALOG.md; entries in 4_DECISION_LOG.md must be the
    canonical home of any rationale duplicated in KNOWN_ISSUES (1_README.AI)
    or SECURITY NOTES (3_GETTING_STARTED); SDK members referenced in
    7_CONTRACTS_CATALOG.md must appear in 5_SDK_SURFACE.md if that file was
    produced; screen paths cited in 11_DOMAIN_TO_TECHNICAL_MAP.md must
    appear in 10_SCREENS_INVENTORY.md if that file was produced; business
    concepts in 11_DOMAIN_TO_TECHNICAL_MAP.md must exist in
    2_GETTING_STARTED_BUSINESS.md's glossary.
  ✔ When the task is fully complete, output only this single line — nothing
    more:
    "docs.AI/ is ready."
```
