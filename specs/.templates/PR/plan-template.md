<!-- Template: plan-template.md -->
<!-- Used by: /ai-radija-plan -->
<!-- Resolution: specs/.templates/plan-template.md (project) > prompt-provided > skill default -->
<!-- Customize: Add sections for your architecture patterns, deployment strategy, etc. -->

# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

## Summary

[Primary requirement from spec + technical approach chosen after research]

## Technical Context

| Dimension | Value |
|-----------|-------|
| **Language/Version** | [e.g., Python 3.11] |
| **Dependencies** | [e.g., FastAPI, UIKit] |
| **Storage** | [e.g., PostgreSQL, files or N/A] |
| **Testing** | [e.g., pytest, xUnit] |
| **Platform** | [e.g., Linux server, iOS 15+] |
| **Project Type** | [library / cli / web-service / mobile-app / desktop-app] |
| **Performance** | [e.g., 1000 req/s, 60 fps] |
| **Constraints** | [e.g., <200ms p95, offline-capable] |
| **Scale** | [e.g., 10k users, 50 screens] |

## Constitution Check

*GATE: Must pass before Phase 0. Re-check after Phase 1.*

[Gates determined from constitution file]

## Project Structure

### Feature Documentation

specs/[###-feature]/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md

### Source Code

[Selected structure with rationale]

## Complexity Tracking

Fill ONLY if Constitution Check has violations that must be justified.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| | | |
