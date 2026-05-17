# EXAMPLES — Real cases

Concrete walkthroughs of the workflow applied to real flows. Use these as templates when planning a new tutorial series.

---

## Example 1 — ManyConnect NF-e import series (7 tutorials)

**Project**: `manyconnect.help` (React 19 + Vite + Ant Design)
**Feature documented**: `/purchases/import` — 5-step wizard for importing NF-e XML
**Outcome**: 7 Rich tutorials, 16 real screenshots, 1 shared `RelatedTutorials` component

### Step 1 — Discovery findings

Read in this order:
- `src/modules/tutoriais/renderers.tsx` — `tutorialRenderers` map keyed by slug
- `src/modules/blog/models/Article.model.ts` — `ArticleModel` interface
- `src/modules/blog/services/Article.services.ts` — `articles[]` array (2900+ lines)
- `src/modules/tutoriais/cadastros/clientes/Clientes.tsx` — best template (Hero + FeatureGrid + StepList + Callouts + FaqAccordion)
- `src/components/tutorial/index.ts` — exports of all primitives
- `src/modules/home/routes.tsx` — route was `/article/:reference`, not `/blog/:reference`

Conventions found:
- Categories: `admin`, `cadastros`, `conta`, `financeiro`, `vendas` (no `compras` yet)
- Slugs in kebab-case
- Images flat in `public/` with snake_case PT-BR prefixes (`ativos_*`, `os_*`, `whatsapp_*`)
- Difficulty enum: `Iniciante` | `Intermediário` | `Avançado`

### Step 2 — Flow map

```
/purchases/import (wizard with 6 steps in UI, 5 logical tutorials):

  1. Upload          XML drag-drop OR SEFAZ key (44 digits)
  2. Fornecedor      Link existing / Create new / Skip
  3. Itens           Match by EAN/SKU/Name + bulk actions
  4. Confirmação     Cost policy + AP toggle
  5. Conclusão       Vincular OS / Concluir OC
  6. Done            Navigation back to list
```

Prerequisites: `purchase.post` permission, apps PRODUCTS + HUB_ESTOQUE, optionally a pre-registered supplier.

### Step 3 — Series composition

Decided with the user via `AskUserQuestion`:

| # | Slug                                | Title                                       | Time | Difficulty     |
|---|-------------------------------------|---------------------------------------------|------|----------------|
| 1 | `nfe-importacao-visao-geral`        | Importação de NF-e: visão geral             | 5min | Iniciante      |
| 2 | `nfe-importacao-pre-requisitos`     | Antes de importar: pré-requisitos           | 4min | Iniciante      |
| 3 | `nfe-importacao-upload`             | Etapa 1: upload do XML                      | 4min | Iniciante      |
| 4 | `nfe-importacao-fornecedor`         | Etapa 2: vincular ou criar fornecedor       | 4min | Iniciante      |
| 5 | `nfe-importacao-produtos`           | Etapa 3: conferir e vincular produtos       | 6min | Intermediário  |
| 6 | `nfe-importacao-confirmar`          | Etapa 4: confirmar a importação             | 5min | Intermediário  |
| 7 | `nfe-importacao-conclusao`          | Etapa 5: conclusão e próximos passos        | 3min | Iniciante      |

New category: `Compras`.

### Step 4 — Screenshot strategy chosen

Playwright MCP, real XML at `/Users/.../Downloads/<key>-procNFe.xml`. Test account `teste@manyconnect.com.br / Teste.1` on local `manyconnect.portal` (`localhost:3002`).

Naming: `nfe_<step>_<state>.png` (e.g. `nfe_step1_dropzone.png`).

### Step 5 — Captures (16 PNGs)

```
nfe_wizard_overview.png         full-page wizard
nfe_wizard_steps.png            stepper bar
nfe_step1_dropzone.png          Upload tab idle
nfe_step1_sefaz.png             SEFAZ tab
nfe_step2_fornecedor.png        supplier decision card
nfe_step2_criar.png             "Create new" selected
nfe_step2_pular.png             "Skip" selected
nfe_step3_lista.png             items list
nfe_step3_filtros.png           filter chips (zoomed)
nfe_step3_card_item.png         item card (zoomed)
nfe_step4_resumo.png            confirmation summary
nfe_step4_politica_custo.png    cost policy (zoomed)
nfe_step4_conta_pagar.png       AP toggle (zoomed)
nfe_step5_sucesso.png           result screen
nfe_step5_vincular_os.png       link-to-OS block (zoomed)
nfe_step5_concluir.png          close-OC block (zoomed)
```

Workflow per capture:
1. Navigate to `/purchases/import`
2. Walk through the wizard with the real XML (file_upload required copying it into `.playwright-mcp/` first because Playwright sandboxes Downloads)
3. Take viewport screenshot, or pass `target: 'eXXX'` for zoomed sub-elements
4. For the supplier step, click each radio (`Cadastrar`/`Pular`) and shoot variants

### Step 6 — Scaffold (per tutorial)

Each TSX ~150–250 lines. Same skeleton, different content. Example for tutorial 1:

```tsx
<TutorialPage>
  <Hero
    eyebrow="Compras · NF-e"
    title={<>Importação de NF-e: <HeroAccent>visão geral do fluxo</HeroAccent></>}
    description={<>Em 5 etapas guiadas o sistema lê o XML, cadastra fornecedor, faz match com seu estoque, atualiza custo e gera a conta a pagar.</>}
  />
  <Section eyebrow="Quando usar" title="O que esse fluxo resolve">
    <FeatureGrid>
      <FeatureCard badge="Estoque" title="Entrada automática">Cada item credita unidades…</FeatureCard>
      <FeatureCard badge="Custo" title="Política contábil">Você escolhe entre Média Ponderada…</FeatureCard>
      <FeatureCard badge="Financeiro" title="Conta a pagar opcional">Um toggle gera a Invoice…</FeatureCard>
    </FeatureGrid>
  </Section>
  <Section eyebrow="Mapa do wizard" title="As 5 etapas em sequência">
    <Figure src="/nfe_wizard_steps.png" alt="…" caption="…" />
    <StepList>
      <Step number={1} title="Upload">Envia o XML…</Step>
      {/* 4 more */}
    </StepList>
    <Figure src="/nfe_wizard_overview.png" alt="…" caption="…" />
    <Callout variant="info" label="Pré-requisitos antes de começar">…</Callout>
  </Section>
  <Section eyebrow="Dúvidas comuns" title="FAQ">
    <FaqAccordion>
      <FaqItem question="Preciso importar toda nota que entra?">…</FaqItem>
      {/* 4 more */}
    </FaqAccordion>
  </Section>
  <RelatedTutorials currentSlug="nfe-importacao-visao-geral" />
  <TutorialFooter brand="Many Connect · Importação de NF-e" meta="Tutorial · v1 · Iniciante" />
</TutorialPage>
```

### Step 7 — Registration

`renderers.tsx`:

```tsx
import { VisaoGeral as NfeVisaoGeral } from "./compras/visao-geral/VisaoGeral";
// ...6 more

export const tutorialRenderers: Record<string, ReactNode> = {
  // existing...
  "nfe-importacao-visao-geral":     <NfeVisaoGeral />,
  "nfe-importacao-pre-requisitos":  <NfePreRequisitos />,
  "nfe-importacao-upload":          <NfeUpload />,
  "nfe-importacao-fornecedor":      <NfeFornecedor />,
  "nfe-importacao-produtos":        <NfeProdutos />,
  "nfe-importacao-confirmar":       <NfeConfirmar />,
  "nfe-importacao-conclusao":       <NfeConclusao />,
};
```

`Article.services.ts`:

```ts
{
  reference: "nfe-importacao-visao-geral",
  title: "Importação de NF-e: visão geral",
  subtitle: "Mapa do wizard em 5 etapas — quando usar e o que cada etapa decide.",
  author: "ManyConnect",
  date: "2026-05-16",
  favorite: true,
  description: "Visão geral do fluxo /purchases/import: Upload, vínculo de fornecedor, matching de produtos…",
  category: "Compras",
  difficulty: "Iniciante",
  readingTime: 5,
  tags: ["NF-e","importação","compras","wizard","XML","estoque"],
  isNew: true,
  isPopular: true,
  customRenderer: "nfe-importacao-visao-geral",
  content: [],
}
// ... 6 more entries
```

### Step 8 — Verification

```bash
cd manyconnect.help && npx tsc -b   # Exit 0
npm run dev                          # localhost:5173
```

Navigate to each of the 7 slugs. Run audit:

```js
[...document.querySelectorAll('img')]
  .filter(i => i.complete && i.naturalHeight === 0)
  .map(i => i.src.split('/').pop())
// → [] (zero broken)
```

### Pitfalls hit in this case

1. **File chooser sandbox** — Playwright refused `~/Downloads/nf.xml`. Solution: `cp` into `.playwright-mcp/teste-nfe.xml`.
2. **Wizard auto-progressed** after upload — Step 1 "carregado" state couldn't be captured separately. Accepted.
3. **Sidebar submenus** kept overlapping screenshots. Solution: `browser_hover` on the main area before each shot.
4. **Beforeunload dialog** when navigating away with `isDirty=true`. Solution: load `browser_handle_dialog` and accept.
5. **Cost: 8 image variants × 6 wizard states = a lot.** Solution: prioritized 16 high-value shots, skipped redundant ones.
6. **Real CNPJ leaked** in supplier screenshot. Documented as a risk; recommended blur before commit.

---

## Example 2 — Adding "Related tutorials" section to an existing series

**Context**: 7 tutorials already shipped, no inter-tutorial navigation.

### Decision

Create a shared component, parameterized by `currentSlug`, that lists the other 6 in a `FeatureGrid` of cards. Filter out the current tutorial so the page never links to itself.

### Implementation

1. Create `src/modules/tutoriais/<category>/_shared/RelatedTutorials.tsx` containing a `SERIES` array and the filter+map render. See `REFERENCE.md` § "Series patterns".
2. For each of the 7 tutorials, add the import and place `<RelatedTutorials currentSlug="..." />` right before `<TutorialFooter>`.
3. Style decision: make the **title** of each card the clickable `<a>` with a `→` suffix, so the entire card visually invites a click.

### Snippet

```tsx
<FeatureCard
  key={t.slug}
  badge={t.badge}
  title={<a href={`/article/${t.slug}`}>{t.title} →</a>}
>
  {t.description}
</FeatureCard>
```

### Verification

```js
// On any tutorial page:
[...document.querySelectorAll('h3 a')]
  .filter(a => a.href.includes('/article/'))
  .map(a => a.href.split('/').pop())
// Should NOT include the slug of the current page
```

---

## Example 3 — Forward-looking tutorials with "em breve" Callouts

**Problem**: Tutorial references screenshots of a feature that hasn't shipped yet.

**Wrong**: Leave broken `<Figure src="/feature_x.png">` — renders as alt text or empty container.

**Right**: Replace each `<Figure>` with a Callout indicating WIP:

```tsx
<Callout variant="info" label="🚧 Imagem em breve">
  <p>
    Screenshot da [específica tela / estado] será adicionado quando a
    feature for liberada no portal.
  </p>
</Callout>
```

When done:

1. Remove the now-unused `Figure` import (TypeScript's `noUnusedLocals` will catch it)
2. Run `tsc -b` to confirm exit 0
3. Audit DOM with `naturalHeight === 0` filter — should be empty

This pattern was applied to:
- `CamposCustomizados.tsx` — 8 Figures → 8 Callouts (feature not yet implemented in portal)
- `BaixaOsParticularidades.tsx` — 2 Figures → 2 Callouts (deslocamento, checklist not yet in product)

When the features ship: swap each Callout back for `<Figure>` after capturing the real image.
