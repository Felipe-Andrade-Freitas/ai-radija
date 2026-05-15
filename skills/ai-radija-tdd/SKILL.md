---
description: Test-driven development with red-green-refactor loop for any tech stack. Detects the project's language and testing tools automatically. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants test-first development, or asks for integration tests.
user-invocable: true
disable-model-invocation: false
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** exercise real code paths through public APIs. They describe _what_ the system does, not _how_. A good test reads like a specification — "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors.

**Bad tests** are coupled to implementation: mocking internal collaborators, testing private methods, verifying call counts. Warning sign: test breaks when you refactor, but behavior hasn't changed.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.**

```
WRONG (horizontal):
  RED:   Test1, Test2, Test3, Test4, Test5
  GREEN: Impl1, Impl2, Impl3, Impl4, Impl5

RIGHT (vertical):
  RED→GREEN: Test1→Impl1
  RED→GREEN: Test2→Impl2
  RED→GREEN: Test3→Impl3
```

One test → one implementation → repeat. Each test responds to what you learned from the previous cycle.

## Workflow

### 1. Planning

- [ ] Detect project stack (language, test framework, assertion library) from codebase
- [ ] Confirm with user what interface changes are needed
- [ ] Confirm which behaviors to test (prioritize — you can't test everything)
- [ ] Identify opportunities for deep modules (small interface, deep implementation)
- [ ] Design interfaces for testability (accept dependencies, return results, small surface area)
- [ ] Get user approval on the plan

### 2. ADO Test Plan Sync _(if Azure DevOps is configured)_

After the plan is approved, check `CLAUDE.md` for a `## Tracker` section with `Type: Azure DevOps`.
If present, create one **Test Case** work item per planned cycle **before** writing any test code.

**For each cycle in the plan:**

1. Find (or confirm with user) the PBI (User Story) this cycle belongs to.
2. Create a Test Case with:
   - **Title**: `[Ciclo N] <behavior description>` — mirrors the cycle label in the plan.
   - **Steps** (`Microsoft.VSTS.TCM.Steps`): XML with `ActionStep` (setup/execution) and `ValidateStep` (assertion) entries derived from the Given/When/Then of that cycle.
   - **Link**: `Microsoft.VSTS.Common.TestedBy-Reverse` pointing to the User Story.
3. Record the Test Case ID alongside the cycle in the plan for traceability.

> Use the helpers from `ai-radija-tracker-ado` (`Make-Step`, `Make-StepsXml`, `Update-TCSteps`) and `HttpWebRequest` for UTF-8-safe encoding on Windows.

**Step mapping from Given/When/Then:**

| GWT part | ADO step type | Field |
|---|---|---|
| **Given** (precondition / setup) | `ActionStep` | Action = setup code; Expected = mock/state confirmation |
| **When** (execution) | `ActionStep` | Action = call under test |
| **Then** (assertion) | `ValidateStep` | Action = assertion expression; Expected = expected value |

**Example** — cycle "useAuth returns unauthenticated state":

```
Given: MSAL mock with no active account
  → ActionStep: "Configure makeMsalInstance({ authenticated: false })"
    Expected:   "getAllAccounts() returns empty array"

When: hook is rendered
  → ActionStep: "Render hook with renderHookWithMsal(() => useAuth(), msal)"
    Expected:   "Hook mounts without error"

Then: isAuthenticated=false, user=null, accessToken=null
  → ValidateStep: "Check result.current.isAuthenticated"  Expected: "false"
  → ValidateStep: "Check result.current.user"             Expected: "null"
  → ValidateStep: "Check result.current.accessToken"      Expected: "null"
```

Skip this step if: ADO is not configured, the project has no PBIs yet, or the user explicitly opts out.

### 3. Tracer Bullet

Write ONE test that confirms ONE thing:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

> If ADO is configured: update the corresponding Test Case state to **Ready** after GREEN.

### 4. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules: one test at a time, only enough code to pass, don't anticipate future tests.

> If ADO is configured: update each Test Case state to **Ready** as it goes GREEN.

### 5. Refactor

After all tests pass, look for refactor candidates:

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

## Stack Detection

On first run, detect the project's stack and adapt tooling:

| Signal | Stack | Test Command | Frameworks |
|--------|-------|-------------|------------|
| `*.csproj`, `*.sln` | .NET/C# | `dotnet test` | xUnit, NUnit, FluentAssertions |
| `package.json` | Node/TS | `npm test` / `vitest` | Jest, Vitest, Mocha |
| `pyproject.toml`, `setup.py` | Python | `pytest` | pytest, unittest |
| `Cargo.toml` | Rust | `cargo test` | built-in |
| `go.mod` | Go | `go test ./...` | built-in, testify |
| `build.gradle`, `pom.xml` | Java/Kotlin | `./gradlew test` / `mvn test` | JUnit, Mockito |
| `Gemfile` | Ruby | `bundle exec rspec` | RSpec, Minitest |

Use project conventions for file placement, naming, and assertion style.

---

## Reference: Good and Bad Tests

### Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```
// GOOD: Tests observable behavior
test "user can checkout with valid cart" {
    cart = new Cart()
    cart.add(Products.Widget)
    payment = new CreditCard("4111111111111111")

    result = checkoutService.checkout(cart, payment)

    assert result.status == OrderStatus.Confirmed
}
```

Characteristics: tests behavior users care about, uses public API only, survives refactors, describes WHAT not HOW, one assertion per test, name reads like a spec.

### Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```
// BAD: Tests implementation details
test "checkout calls payment service process" {
    mockPayment = mock(PaymentService)
    service = new CheckoutService(mockPayment)

    service.checkout(cart, payment)

    verify mockPayment.process(cart.total) called once  // testing HOW, not WHAT
}
```

Red flags: mocking internal collaborators, testing private methods, asserting on call counts, test breaks on refactor without behavior change, verifying through external means instead of interface.

```
// BAD: Bypasses interface to verify
test "createUser saves to database" {
    userService.createUser("Alice")
    row = database.query("SELECT * FROM Users WHERE Name = 'Alice'")
    assert row != null
}

// GOOD: Verifies through interface
test "createUser makes user retrievable" {
    user = userService.createUser("Alice")
    retrieved = userService.getUser(user.id)
    assert retrieved.name == "Alice"
}
```

---

## Reference: Mocking

Mock at **system boundaries** only: external APIs, databases (prefer test DB), time/clocks, file system, HTTP calls to third parties.

**Don't mock**: your own classes, internal collaborators, anything you control.

**Design for mockability**:

1. **Accept dependencies, don't create them** — use constructor/function injection
2. **Prefer specific interfaces over generic ones** — focused per-operation, not one catch-all
3. **Inject time** for time-dependent code
4. **Small surface area** — fewer methods = fewer tests needed

---

## Reference: Interface Design for Testability

1. **Accept dependencies, don't create them** — use injection, let tests substitute fakes
2. **Return results, don't produce side effects** — return values you can assert on
3. **Program to interfaces, not concrete implementations** — easy to substitute in tests
4. **Small surface area** — fewer methods, fewer parameters, focused interfaces

---

## Reference: Deep Modules

From "A Philosophy of Software Design":

**Deep module** = small interface + lots of implementation (good)
**Shallow module** = large interface + little implementation (avoid)

When designing interfaces, ask: Can I reduce the number of methods? Can I simplify the parameters? Can I hide more complexity inside?

---

## Reference: Refactor Candidates

After TDD cycle, look for:

- **Duplication** → Extract method, function, or class
- **Long methods** → Break into private helpers (keep tests on public interface)
- **Shallow modules** → Combine or deepen
- **Feature envy** → Move logic to where data lives
- **Primitive obsession** → Introduce value objects or domain types
- **Fat interfaces** → Split into focused interfaces (ISP)
- **God classes** → Extract focused services with single responsibility
