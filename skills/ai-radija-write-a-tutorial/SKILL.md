---
description: Plan, capture and publish a complete tutorial series for a product feature in any help center / docs site. Covers discovery of the destination site's conventions, mapping the product flow, planning granularity, capturing real screenshots via Playwright/Puppeteer, scaffolding Rich tutorial pages and handling features that are still in development. Use when the user asks to "create tutorial", "write tutorial", "document a flow", "screenshot a wizard", "build a help article", "tutorial for [feature]", or wants to add documentation with screenshots to a help center / docs site.
user-invocable: true
disable-model-invocation: false
---

# Write a Tutorial — Help Center / Docs

End-to-end workflow for turning a product flow into a polished tutorial (or series) with real screenshots, callouts, FAQ and inter-tutorial navigation. Works in any docs site that exposes a Rich component pattern (TSX/MDX) or generic content blocks.

**Companion files**:
- `REFERENCE.md` — anatomy of a tutorial page, screenshot conventions, common pitfalls
- `EXAMPLES.md` — full case study (ManyConnect NF-e import series, 7 tutorials)

---

## Workflow — 8 steps

### Step 1 — Discover the destination site

Before writing anything, learn how the existing docs site is structured. **Never assume conventions** — read 1–2 existing tutorials end-to-end.

Checklist:
- [ ] Where do tutorial pages live? (e.g. `src/modules/tutoriais/<category>/<slug>/<Component>.tsx`)
- [ ] Where are tutorials registered? (typically two indexes: a `renderers.tsx` lookup + an `Article.services.ts` array)
- [ ] What renders the page? (Rich TSX with shared components vs. generic content blocks)
- [ ] What shared components exist? (Hero / Section / Step / Callout / FeatureCard / FaqAccordion / Figure / Path / TutorialFooter)
- [ ] Where do images live? (almost always flat in `public/`)
- [ ] What's the naming convention? (snake_case PT-BR with module prefix is common: `nfe_*.png`, `os_*.png`)
- [ ] What URL pattern serves a tutorial? (`/article/:reference` is common — confirm by reading routes)
- [ ] What categories already exist? Does the new tutorial fit one, or create a new category?

Commands that help (adapt to the project):
```bash
ls src/modules/tutoriais/                                 # categories
ls src/components/tutorial/                               # shared UI primitives
cat src/modules/tutoriais/renderers.tsx                   # rich renderer index
cat src/modules/blog/services/Article.services.ts | head  # article metadata
cat src/modules/tutoriais/<existing-category>/<slug>/<Component>.tsx  # full template
ls public/ | grep -E '\.(png|webp)$' | head -30           # image conventions
```

→ See `REFERENCE.md` § "Help center anatomy" for the common component contracts.

### Step 2 — Map the product flow

Open the actual product (the app being documented), navigate the feature end-to-end and write down what you see. Use a code-explorer agent if the codebase is large.

Capture for each screen / step:
- Route (URL)
- Page title and key UI elements
- Decisions the user must make (option A vs. B vs. skip)
- Validations and error messages
- Prerequisites (permissions, plan/apps, prior records)
- Side-effects (what happens to stock / status / records on confirm)

Output: a one-page flow map. This becomes the spine of the tutorial.

### Step 3 — Plan granularity

Ask the user (single-question with 3–4 options) how they want the series structured:

| Option | When to choose |
|---|---|
| **Single long tutorial** | Linear flow under ~8 minutes of reading, no big optional branches |
| **Series of N tutorials** (overview + one per step) | Wizard with multiple decisions, users will jump in at different points |
| **Quick start + Advanced** | Power users vs. first-timers need different depth |
| **Tutorial + Glossary** | Many configurable options users will look up by name |

Then confirm composition: slugs, titles, reading time, difficulty (`Iniciante` / `Intermediário` / `Avançado`), category.

Defaults that age well:
- Reading time **3–6 min** per tutorial
- One Rich TSX file per tutorial
- Use kebab-case slugs (`nfe-importacao-upload`)
- PT-BR content; English identifiers (per ManyConnect convention — adjust to the project)

### Step 4 — Decide screenshot strategy

Ask the user up front:

1. **Capture now via Playwright/Puppeteer** — most reliable. Requires the app running locally or in a stable PRD/staging.
2. **Placeholders + capture later** — faster scaffold, user captures manually with a provided checklist.
3. **No screenshots** — text-only. Not recommended for visual flows.

Also clarify:
- **Test data**: a valid file, sample record, or chave de acesso. If absent, ask whether to generate a mock or skip.
- **Credentials**: prefer a documented test user. Avoid the user's real production identity.
- **Environment**: local dev, staging, or PRD. PRD captures real-looking content but you must not mutate state — capture, then `Escape` / cancel.

→ See `REFERENCE.md` § "Screenshot conventions" for naming, viewport (1280×800), and Playwright tips.

### Step 5 — Capture screenshots

Use the Playwright MCP (or `mcp__plugin_playwright_playwright__*`). For each shot:

1. `browser_resize` once at the start: `1280×800`
2. `browser_navigate` to the page
3. Settle the UI (`browser_wait_for` 2–3s; close cookie banners / tour modals)
4. Move the cursor away from the sidebar via `browser_hover` on the main area to avoid open submenus covering the page
5. `browser_take_screenshot` with `filename` pointing into `public/<prefix>_<step>_<state>.png`
6. For zoomed-in shots, pass `target` referencing a snapshot ref (e.g. `e548`)

For modal flows that change state (forms, payments, status updates): screenshot then **press `Escape` to cancel** — never confirm unless you control the database.

→ See `REFERENCE.md` § "Playwright recipe" for full helpers.

### Step 6 — Scaffold the Rich TSX files

Copy the closest existing Rich tutorial as a template (e.g. `Clientes.tsx`). For each tutorial in the series:

```tsx
import {
  Callout, FaqAccordion, FaqItem, FeatureCard, FeatureGrid,
  Figure, Hero, HeroAccent, Path, Section, Step, StepList,
  TutorialFooter, TutorialPage,
} from "../../../../components/tutorial";
import { RelatedTutorials } from "../_shared/RelatedTutorials"; // if series

export const <Name> = () => (
  <TutorialPage>
    <Hero eyebrow="..." title={<>... <HeroAccent>...</HeroAccent></>} description={<>...</>} />

    <Section eyebrow="..." title="Por que ..." lede={<>...</>}>
      <FeatureGrid>
        <FeatureCard badge="..." title="...">...</FeatureCard>
        {/* 2–3 cards */}
      </FeatureGrid>
    </Section>

    <Section eyebrow="Passo a passo" title="Como ...">
      <StepList>
        <Step number={1} title="..."><p>...</p>
          <Figure src="/<prefix>_step1_*.png" alt="..." caption="..." />
          <Callout variant="info" label="Dica">...</Callout>
        </Step>
        {/* more steps */}
      </StepList>
    </Section>

    <Section eyebrow="Dúvidas comuns" title="FAQ">
      <FaqAccordion>
        <FaqItem question="..."><p>...</p></FaqItem>
      </FaqAccordion>
    </Section>

    <RelatedTutorials currentSlug="<this-slug>" /> {/* if series */}

    <TutorialFooter brand="<Brand · Module>" meta="Tutorial · v1 · <Difficulty>" />
  </TutorialPage>
);

export default <Name>;
```

For a series, also create a `_shared/RelatedTutorials.tsx` component parameterized by `currentSlug`. See `EXAMPLES.md`.

### Step 7 — Register in the indexes

Two edits per tutorial:

1. **`src/modules/tutoriais/renderers.tsx`** — add import + entry in the `tutorialRenderers` map (keyed by the slug).
2. **`src/modules/blog/services/Article.services.ts`** (or equivalent) — push an `ArticleModel` object with `reference`, `title`, `subtitle`, `author`, `date`, `description`, `category`, `difficulty`, `readingTime`, `tags`, `isNew`, `customRenderer` (matching the renderer key), `content: []`.

### Step 8 — Verify

```bash
# Type-check
cd <docs-site> && npx tsc -b               # exit 0 expected

# Spin up dev server
npm run dev                                # usually localhost:5173

# Confirm each slug renders and has zero broken images
# Use Playwright: open /article/<slug>, evaluate img.naturalHeight === 0
```

Also confirm:
- [ ] All `<Figure src="/...">` files exist in `public/`
- [ ] Mobile viewport stays readable (resize to 375×800)
- [ ] Categories sidebar shows the new category if you created one
- [ ] `RelatedTutorials` filters the current tutorial out

→ See `REFERENCE.md` § "Verification helpers" for the audit script.

---

## Handling features that don't exist yet

A tutorial may document a flow the product hasn't shipped. If a referenced screenshot can't be captured because the screen doesn't exist:

**Don't ship broken `<img>` tags.** Replace each missing `<Figure>` with:

```tsx
<Callout variant="info" label="🚧 Imagem em breve">
  <p>
    <Descrição da tela em desenvolvimento.> Screenshot será adicionado
    quando a feature for liberada no portal.
  </p>
</Callout>
```

Keep the surrounding text (it's a forward-looking spec). When the feature ships, swap the Callout back for a `<Figure>`.

---

## Common pitfalls

- **Hover-locked sidebars** cover the screenshot. Always `browser_hover` to the main area before screenshotting.
- **File chooser sandbox** — Playwright MCP only sees files inside the project / `.playwright-mcp/`. Copy test fixtures into that root first.
- **Cache the rendered viewport** — `naturalHeight === 0` is the fastest way to detect a broken image programmatically.
- **Don't mutate PRD data** — for any "Confirm" / "Save" button, screenshot the modal then press `Escape`.
- **Mask sensitive data** — real CNPJs, names, payment data should be blurred before commit. Either capture from a sanitized tenant or post-process.
- **Series filtering** — a "Related tutorials" component must filter out the current slug, otherwise users see a card linking to the page they're on.

---

## Review checklist

Before declaring done:

- [ ] Step 1 confirmed the site's conventions (you read at least 1 real tutorial)
- [ ] Step 2 produced a written flow map
- [ ] Step 3 produced an approved series composition
- [ ] Screenshots saved with consistent prefix, all referenced files exist
- [ ] Each TSX is under ~250 lines (split into more tutorials otherwise)
- [ ] `tsc -b` returns exit 0
- [ ] Dev server renders each `/article/<slug>` with zero broken images
- [ ] Sensitive data masked or sourced from a test tenant
- [ ] `RelatedTutorials` (if series) hides the current slug
- [ ] Forward-looking sections use the "🚧 Imagem em breve" Callout, not a broken `<Figure>`
