# REFERENCE — Anatomy, Conventions, Playwright Recipes

Companion to `SKILL.md`. Open when you need a deep dive on a specific area.

---

## Help center anatomy

Most React/TS help center sites converge on this shape:

```
docs-site/
├── public/                                            # flat image folder
│   ├── module1_step1_overview.png
│   └── module2_modal_payment.png
└── src/
    ├── components/tutorial/                           # shared UI primitives
    │   ├── Hero.tsx           — eyebrow + big title + description
    │   ├── HeroAccent.tsx     — gold/brand highlight inside title
    │   ├── Section.tsx        — eyebrow + title + lede + body
    │   ├── FeatureCard.tsx    — 3-col grid card (badge + title + body)
    │   ├── FeatureGrid.tsx    — responsive grid wrapper
    │   ├── Step.tsx           — numbered step inside StepList
    │   ├── StepList.tsx       — ordered list of Steps
    │   ├── Callout.tsx        — info/success/warning callout (variants)
    │   ├── Figure.tsx         — img + alt + caption
    │   ├── Path.tsx           — UI breadcrumb (e.g. "Vendas > Pedidos")
    │   ├── FaqAccordion.tsx   — collapsible Q&A wrapper
    │   ├── FaqItem.tsx        — single FAQ entry
    │   ├── TutorialFooter.tsx — brand + meta (version + difficulty)
    │   ├── TutorialPage.tsx   — outer wrapper / layout
    │   └── index.ts           — re-exports all of the above
    ├── modules/
    │   ├── blog/
    │   │   ├── models/Article.model.ts          # ArticleModel interface
    │   │   ├── services/Article.services.ts     # articles[] array
    │   │   └── pages/article/Article.tsx        # renderer (handles customRenderer)
    │   └── tutoriais/                            # rich TSX tutorials
    │       ├── renderers.tsx                     # slug -> ReactNode map
    │       ├── <category>/<slug>/<Name>.tsx
    │       └── <category>/_shared/RelatedTutorials.tsx
    └── modules/home/routes.tsx                   # `/article/:reference` route
```

### `ArticleModel` typical shape

```ts
interface ArticleModel {
  reference: string;        // kebab-case slug; URL is /article/<reference>
  title: string;
  subtitle: string;
  author: string;
  date: string;             // YYYY-MM-DD
  favorite: boolean;
  description: string;      // SEO / list page card description
  content: ArticleContent[]; // empty when customRenderer is set
  category?: string;
  difficulty?: 'Iniciante' | 'Intermediário' | 'Avançado';
  readingTime?: number;     // minutes
  tags?: string[];
  isNew?: boolean;
  isPopular?: boolean;
  customRenderer?: string;  // key into tutorialRenderers
}
```

### `tutorialRenderers` shape

```ts
export const tutorialRenderers: Record<string, ReactNode> = {
  "slug-of-tutorial": <ComponentName />,
};
```

The blog `Article.tsx` reads `customRenderer` from the article, looks it up here, and falls back to rendering `content[]` block-by-block when not set.

---

## Component contracts (cheat sheet)

```tsx
<Hero
  eyebrow="Module · Subsection"      // small text above title
  title={<>... <HeroAccent>highlighted phrase</HeroAccent></>}
  description={<>One paragraph explaining the goal.</>}
/>

<Section
  eyebrow="Phase name"
  title="Big section title"
  lede={<>1–2 sentence introduction.</>}
>
  {/* body */}
</Section>

<FeatureGrid>
  <FeatureCard badge="Tag" title="Card title">Body text.</FeatureCard>
</FeatureGrid>

<StepList>
  <Step number={1} title="Step name">
    <p>Paragraph.</p>
    <Figure src="/img_step1.png" alt="..." caption="..." />
    <Callout variant="info" label="Tip">...</Callout>
  </Step>
</StepList>

<Callout variant="info | success | warning | default" label="...">
  <p>Body. Use to draw attention to a constraint, warning, or extra context.</p>
</Callout>

<Figure src="/abs/path.png" alt="..." caption="..." />

<Path segments={["Settings", "Custom Fields"]} />

<FaqAccordion>
  <FaqItem question="...?"><p>Answer.</p></FaqItem>
</FaqAccordion>

<TutorialFooter brand="Product · Module" meta="Tutorial · v1 · Iniciante" />
```

---

## Screenshot conventions

### Naming

`<module-prefix>_<step|state>_<descriptor>.<ext>`

Examples:
- `nfe_step1_dropzone.png` — module prefix `nfe`, step 1, dropzone state
- `os_03_checklist.png` — OS module, screenshot 03, checklist
- `whatsapp_modal_emissao.png` — whatsapp module, modal state, emissão context

Rules:
- **snake_case PT-BR** (or follow existing folder's language)
- Prefix groups screenshots in `public/` listings
- `.png` for UI screenshots; `.webp` if the site already uses it
- Target file size < 250 KB. Use `pngquant` / `imagemin` if needed

### Viewport

- Desktop tutorials: **1280×800** (matches most help centers' max content width)
- Mobile shots (when documenting mobile-specific flows): **375×800**
- Don't use full-page screenshots for tiny details; capture the target element instead via `target: 'eXXX'`

### Where to save

Always `<docs-site>/public/`. Reference via absolute `/file.png` in JSX:

```tsx
<Figure src="/nfe_step1_dropzone.png" alt="..." />
```

The JSX `src` starts with `/` and is rooted at the public folder.

---

## Playwright recipe

### Initial setup

```ts
mcp__plugin_playwright_playwright__browser_resize({ width: 1280, height: 800 })
mcp__plugin_playwright_playwright__browser_navigate({ url: "http://localhost:3002/login" })
```

### Login

```ts
mcp__plugin_playwright_playwright__browser_fill_form({
  fields: [
    { name: "Email", type: "textbox", target: "<ref>", element: "Email", value: "..." },
    { name: "Senha", type: "textbox", target: "<ref>", element: "Senha", value: "..." },
  ],
})
mcp__plugin_playwright_playwright__browser_click({ target: "<submit-ref>", element: "Entrar" })
```

### Closing covering UI (sidebar submenus, tour modals)

Hover the main area to retract sidebar submenu popups:

```ts
mcp__plugin_playwright_playwright__browser_hover({ target: "<main-ref>", element: "Main content" })
```

Or null out hover via `browser_evaluate`:

```js
() => {
  document.querySelectorAll('.ant-menu-submenu-popup').forEach(p => p.style.display = 'none');
  document.querySelectorAll('.ant-menu-submenu-open').forEach(o => o.classList.remove('ant-menu-submenu-open'));
}
```

Tour / onboarding dialogs:

```ts
mcp__plugin_playwright_playwright__browser_click({ target: "<skip-ref>", element: "Pular Tour" })
```

### Capturing

Full viewport:

```ts
mcp__plugin_playwright_playwright__browser_take_screenshot({
  filename: "/abs/path/to/docs-site/public/module_step_state.png",
  type: "png",
})
```

Element-targeted (zoomed-in card / modal):

```ts
mcp__plugin_playwright_playwright__browser_take_screenshot({
  filename: "/abs/path/to/public/module_step_state.png",
  type: "png",
  target: "<element-ref>",
  element: "Card description",
})
```

### File uploads

Sandboxed — copy fixtures into project root first:

```bash
cp /Users/.../Downloads/sample.xml /your/project/.playwright-mcp/sample.xml
```

Then in Playwright:

```ts
mcp__plugin_playwright_playwright__browser_file_upload({
  paths: ["/your/project/.playwright-mcp/sample.xml"],
})
```

### Beforeunload dialogs

```ts
mcp__plugin_playwright_playwright__browser_handle_dialog({ accept: true })
```

### Suppressing tooltips/popovers for clean shots

```js
() => {
  document.querySelectorAll('.ant-tooltip, .ant-popover, [role="tooltip"]')
    .forEach(t => t.style.display = 'none');
}
```

---

## Verification helpers

### Audit broken `<img>` tags in dev

After spinning up `npm run dev`, navigate to each tutorial and run:

```js
() => [...document.querySelectorAll('img')]
  .filter(i => i.complete && i.naturalHeight === 0)
  .map(i => i.src.split('/').pop())
```

A non-empty result means missing screenshots.

### Cross-check referenced images vs. files on disk

```bash
# Inside the docs site
grep -rhoE 'src="/[a-zA-Z0-9_./-]+\.(png|webp|jpg|jpeg|gif|svg)"' src/modules/tutoriais/ \
  | sed 's/src="//;s/"$//' | sort -u > /tmp/referenced.txt

ls public/ | grep -iE '\.(png|webp|jpg|jpeg|gif|svg)$' | sort -u > /tmp/public.txt

while read -r ref; do
  filename=$(basename "$ref")
  if ! grep -qx "$filename" /tmp/public.txt; then
    echo "MISSING: $ref"
  fi
done < /tmp/referenced.txt
```

### Type-check

```bash
cd <docs-site> && npx tsc -b && echo "Exit: $?"
```

Expect `Exit: 0`. Common failures: unused imports (e.g. `Figure` imported but no longer used after replacing with Callouts).

---

## Series patterns

### Related tutorials component (DRY)

`src/modules/tutoriais/<category>/_shared/RelatedTutorials.tsx`:

```tsx
import { FC } from "react";
import { FeatureCard, FeatureGrid, Section } from "../../../../components/tutorial";

interface SeriesItem {
  slug: string;
  badge: string;
  title: string;
  description: string;
}

const SERIES: SeriesItem[] = [
  { slug: "feature-overview",       badge: "Overview",     title: "Map",     description: "..." },
  { slug: "feature-prereqs",        badge: "Prereqs",      title: "Before",  description: "..." },
  { slug: "feature-step1",          badge: "Step 1",       title: "...",     description: "..." },
  // ...
];

export const RelatedTutorials: FC<{ currentSlug: string }> = ({ currentSlug }) => {
  const others = SERIES.filter(t => t.slug !== currentSlug);
  return (
    <Section eyebrow="Continue aprendendo" title="Outros tutoriais da série">
      <FeatureGrid>
        {others.map(t => (
          <FeatureCard key={t.slug} badge={t.badge}
            title={<a href={`/article/${t.slug}`}>{t.title} →</a>}>
            {t.description}
          </FeatureCard>
        ))}
      </FeatureGrid>
    </Section>
  );
};
```

Each tutorial in the series imports it and passes its own slug:

```tsx
<RelatedTutorials currentSlug="feature-step1" />
```

The filter ensures the current page never links to itself.

---

## Difficulty heuristic

| Difficulty       | Use when                                                          |
|------------------|-------------------------------------------------------------------|
| `Iniciante`      | Single-screen action, no prerequisites, no irreversible decisions |
| `Intermediário`  | Multi-screen flow, optional decisions, configurable defaults      |
| `Avançado`       | Multi-day workflow, irreversible actions, multiple integrations   |

Reading time ≈ 1 minute per ~250 words of body, +1 minute per major Figure.

---

## When to split into multiple tutorials

Split when **any** of the following are true:

- TSX file exceeds ~250 lines
- More than 8 numbered steps
- Reading time exceeds 8 minutes
- The flow has 3+ optional branches (each branch deserves its own page)
- Users will jump in mid-flow (give them a direct URL to that step)

Otherwise, keep it as one tutorial — over-splitting hurts discoverability.
