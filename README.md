# AI Radija Tools

Multi-model skill pack for spec-driven development. Works with **Claude Code**, **OpenAI Codex CLI**, and **Antigravity**.

---

## Installation

### Claude Code — Plugin (recommended)

#### From a Git repository

Push this repo to GitHub (or any git host), then:

```bash
# Inside Claude Code, run:
/install-plugin https://github.com/<org>/ai-radija-tools
```

Or via CLI:

```bash
claude plugin add https://github.com/<org>/ai-radija-tools
```

#### From a local directory (development / testing)

```bash
# Launch Claude Code pointing to the plugin directory
claude --plugin-dir /path/to/ai-radija-tools

# Or, inside an existing Claude Code session:
/install-plugin /path/to/ai-radija-tools
```

#### Verify installation

Once installed, the 23 skills become available. Test with:

```
/ai-radija-tools:ai-radija-grill-me
```

Or just type `/ai-radija-` and see autocomplete suggestions.

#### Update the plugin

```bash
# Re-run the install command — it overwrites the previous version
claude plugin add https://github.com/<org>/ai-radija-tools
```

#### Uninstall

```bash
claude plugin remove ai-radija-tools
```

### Codex CLI / Antigravity

```bash
# Bash
./install.sh codex /path/to/your/project
./install.sh antigravity /path/to/your/project

# PowerShell
.\install.ps1 -Model codex -ProjectRoot C:\path\to\your\project
```

### All models at once

```bash
./install.sh all /path/to/your/project
```

---

## Skills (22)

### SDD Workflow (Golden Path)

```
grill-me → specify → clarify → plan → tasks → tdd → implement → pr-ready
```

| Skill | Description |
|-------|-------------|
| `/ai-radija-grill-me` | Stress-test a proposed change with critical questions (Go/No-Go) |
| `/ai-radija-specify` | Create a feature specification from natural language |
| `/ai-radija-clarify` | Identify and resolve spec ambiguities (max 5 questions) |
| `/ai-radija-plan` | Generate technical plan with research, data model, contracts |
| `/ai-radija-tasks` | Generate dependency-ordered task list by user story |
| `/ai-radija-tdd` | Test-driven development with red-green-refactor |
| `/ai-radija-implement` | Execute implementation with integrated TDD |
| `/ai-radija-pr-ready` | Validate branch and generate formatted PR |

### Requirements & Quality

| Skill | Description |
|-------|-------------|
| `/ai-radija-write-a-prd` | Create PRD through user interview and codebase exploration |
| `/ai-radija-new-feature` | Feature breakdown with user stories, tasks, acceptance criteria |
| `/ai-radija-prd-to-issues` | Break PRD into vertical slices (tracer bullets) |
| `/ai-radija-analyze` | Cross-artifact consistency analysis (spec/plan/tasks) |
| `/ai-radija-checklist` | Requirements quality checklists ("unit tests for English") |
| `/ai-radija-constitution` | Project governance principles and constraints |
| `/ai-radija-tasks-to-issues` | Convert tasks.md to GitHub Issues |

### Tracker Integrations

| Skill | Description |
|-------|-------------|
| `/ai-radija-tracker-setup` | Configure project tracker connection |
| `/ai-radija-tracker-ado` | Azure DevOps work items |
| `/ai-radija-tracker-jira` | Jira Cloud issues |
| `/ai-radija-tracker-github` | GitHub Issues and Projects |
| `/ai-radija-tracker-linear` | Linear issues and projects |
| `/ai-radija-tracker-notion` | Notion pages and databases |

### Meta

| Skill | Description |
|-------|-------------|
| `/ai-radija-write-a-skill` | Create new agent skills |
| `/ai-radija-setup-templates` | Set up custom project templates for artifact-generating skills |

---

## Plugin Structure

```
ai-radija-tools/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (name, version, description)
├── skills/                  # 23 skills — auto-discovered by Claude Code
│   ├── ai-radija-grill-me/SKILL.md
│   ├── ai-radija-specify/SKILL.md
│   ├── ai-radija-clarify/SKILL.md
│   ├── ai-radija-plan/SKILL.md
│   ├── ai-radija-tasks/SKILL.md
│   ├── ai-radija-tdd/SKILL.md
│   ├── ai-radija-implement/SKILL.md
│   ├── ai-radija-pr-ready/SKILL.md
│   ├── ai-radija-setup-templates/SKILL.md
│   ├── ... (14 more skills)
├── templates/               # Default template files (source of truth)
│   ├── spec-template.md
│   ├── plan-template.md
│   ├── tasks-template.md
│   ├── constitution-template.md
│   └── checklist-template.md
├── adapters/                # Multi-model configs (Codex, Antigravity)
├── install.sh               # Install script for non-Claude models
├── install.ps1              # PowerShell version
├── CLAUDE.md                # Workflow automation rules
├── LICENSE
└── README.md
```

---

## Creating Your Own Plugin (Fork & Customize)

1. **Fork or clone** this repo
2. **Edit skills** — modify any `skills/<name>/SKILL.md` to match your workflow
3. **Add skills** — create a new directory under `skills/` with a `SKILL.md`
4. **Update `.claude-plugin/plugin.json`**:
   ```json
   {
     "name": "your-plugin-name",
     "description": "Your description",
     "version": "1.0.0",
     "author": { "name": "Your Name" }
   }
   ```
5. **Push to a git repo** (GitHub, GitLab, etc.)
6. **Install**: `claude plugin add https://github.com/<org>/<repo>`

### Updating the plugin after changes

1. Increment `version` in `.claude-plugin/plugin.json`
2. Push changes to the repo
3. Users re-run `claude plugin add <url>` to get the latest version

---

## Custom Templates

Skills that generate artifacts (specify, plan, tasks, checklist, constitution) support custom templates.

**Quick setup** (recommended): Run `/ai-radija-setup-templates` to create all 5 template files at once with editable defaults.

**Manual setup**:
1. Create `specs/.templates/` in your project root
2. Copy the desired templates from the `templates/` directory in this repo
3. Edit to match your conventions

Template resolution order:
1. `specs/.templates/<name>-template.md` (project custom)
2. Template provided in the prompt
3. Default template embedded in the skill

---

## License

MIT
