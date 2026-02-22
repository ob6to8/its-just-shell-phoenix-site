# Astro Migration Plan

## Current State

Phoenix 1.7 multi-tenant app serving 3 sites from one codebase. No database — all content compiled at build time via NimblePublisher from markdown files. Deployed as a single Fly.io container running on the BEAM.

### What exists today

| Aspect | Current |
|---|---|
| Runtime | Elixir/Phoenix on BEAM |
| Content | 2 posts, 41 research items (markdown + frontmatter) |
| Sites | 3 tenants: its-just-shell, its-just-beam, its-just-sound |
| Theming | CSS custom properties injected per-site at render time |
| Routing | 5 routes: `/`, `/about`, `/posts`, `/posts/:id`, `/research` |
| Deploy | Docker → Fly.io (1 GB shared VM) |

---

## Migration Strategy: One Astro Project, Three Static Outputs

Since there's no database and all content is compiled at build time anyway, Astro's static site generation (SSG) is a natural fit. The key architectural decision is how to handle multi-tenancy.

### Recommended approach: Build-time site parameter

Use a single Astro codebase with an environment variable (`SITE=its-just-shell`) that controls which site to build. Run the build three times to produce three static outputs. This preserves the "one codebase, three sites" philosophy while eliminating the server entirely.

**Why not a single build with dynamic routing?** The three sites have separate domains and separate themes. Building them as separate static outputs means each site gets a clean, self-contained deployment with no client-side routing logic to resolve tenants. Simpler, faster, more cacheable.

**Alternative considered: Three separate Astro projects.** Rejected — the shared layouts, components, and styling logic would need duplication or a shared package, adding complexity for no benefit.

---

## Phase 1 — Project Scaffolding

### 1.1 Initialize Astro project

Create a new `astro-site/` directory in the repo root (keeps the Phoenix code around during migration).

```
astro-site/
├── astro.config.mjs
├── package.json
├── tsconfig.json
├── src/
│   ├── config/
│   │   └── sites.ts           # port of Blog.Sites
│   ├── content/
│   │   ├── config.ts          # content collection schemas
│   │   ├── posts/             # symlink or copy from priv/posts/
│   │   └── research/          # symlink or copy from priv/research/
│   ├── layouts/
│   │   └── BaseLayout.astro   # port of root.html.heex + app.html.heex
│   ├── components/
│   │   ├── Header.astro
│   │   ├── ResearchCard.astro
│   │   └── FilterPills.astro
│   ├── pages/
│   │   ├── index.astro        # redirect to /posts (or just render posts)
│   │   ├── about.astro
│   │   ├── posts/
│   │   │   ├── index.astro
│   │   │   └── [slug].astro
│   │   └── research/
│   │       └── index.astro
│   ├── styles/
│   │   └── global.css         # port of app.css (prose-terminal, syntax highlighting)
│   └── lib/
│       └── dates.ts           # date formatting helper
└── public/
    ├── favicon.ico
    └── images/                # copy from priv/static/images/
```

### 1.2 Dependencies

```json
{
  "dependencies": {
    "astro": "^5.x"
  },
  "devDependencies": {
    "@astrojs/tailwind": "^6.x",
    "@tailwindcss/typography": "^0.5.x",
    "tailwindcss": "^4.x"
  }
}
```

Astro v5 includes built-in content collections with Zod schema validation, markdown rendering, and syntax highlighting (Shiki) out of the box. No extra markdown plugins needed.

### 1.3 Tailwind configuration

Port the existing `tailwind.config.js`. Drop the Phoenix LiveView plugins (`phx-click-loading`, `phx-submit-loading`, `phx-change-loading`) and the Heroicons embedding plugin. Use `astro-icon` or inline SVGs for the one icon used (external link arrow ↗).

---

## Phase 2 — Site Configuration

### 2.1 Port `Blog.Sites` → `src/config/sites.ts`

```ts
export interface Site {
  slug: string;
  name: string;
  titleSuffix: string;
  domains: string[];
  theme: Record<string, string>;
  logoPath: string;
  aboutText: string;
}

const sites: Site[] = [
  {
    slug: "its-just-shell",
    name: "its-just-shell",
    titleSuffix: " - its just shell",
    domains: ["itsjustshell.dev", "www.itsjustshell.dev"],
    theme: {
      bg: "#282a36",
      text: "#d4d4d8",
      accent: "#60a5fa",
      // ... all 10 theme vars
    },
    logoPath: "/images/logo.png",
    aboutText: "its just shell",
  },
  // ... its-just-beam, its-just-sound
];

export function getCurrentSite(): Site {
  const slug = import.meta.env.SITE || "its-just-shell";
  return sites.find((s) => s.slug === slug)!;
}
```

### 2.2 Build scripts

```json
{
  "scripts": {
    "build:shell": "SITE=its-just-shell astro build --outDir dist/its-just-shell",
    "build:beam":  "SITE=its-just-beam  astro build --outDir dist/its-just-beam",
    "build:sound": "SITE=its-just-sound astro build --outDir dist/its-just-sound",
    "build:all":   "npm run build:shell && npm run build:beam && npm run build:sound",
    "dev":         "SITE=its-just-shell astro dev",
    "dev:beam":    "SITE=its-just-beam  astro dev",
    "dev:sound":   "SITE=its-just-sound astro dev"
  }
}
```

---

## Phase 3 — Content Collections

### 3.1 Migrate markdown files

The existing markdown frontmatter is already compatible with Astro content collections. Move files preserving the directory structure:

```
priv/posts/its-just-shell/2026/02-15-what-is-a-tool.md
  → src/content/posts/its-just-shell/2026/02-15-what-is-a-tool.md

priv/research/its-just-beam/2026/02-17-bumblebee.md
  → src/content/research/its-just-beam/2026/02-17-bumblebee.md
```

### 3.2 Define content schemas (`src/content/config.ts`)

```ts
import { defineCollection, z } from "astro:content";

const posts = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    description: z.string(),
    tags: z.array(z.string()),
  }),
});

const research = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    url: z.string().url(),
    source: z.string(),
    published: z.string(),
    type: z.enum([
      "docs", "framework", "paper", "post",
      "project", "protocol", "site", "talk",
    ]),
  }),
});

export const collections = { posts, research };
```

### 3.3 Parse date and site from filename

The Phoenix app extracts `date` and `site` from the file path (`priv/posts/<site>/<year>/<mm>-<dd>-<slug>.md`). Astro content collections can access the file's `id` (relative path), so we parse the same way:

```ts
// src/lib/content.ts
export function parseMeta(id: string) {
  // id = "its-just-shell/2026/02-15-what-is-a-tool.md"
  const parts = id.split("/");
  const site = parts[0];
  const year = parts[1];
  const filename = parts[2].replace(".md", "");
  const [month, day, ...slugParts] = filename.split("-");
  const slug = slugParts.join("-");
  const date = new Date(`${year}-${month}-${day}`);
  return { site, date, slug };
}
```

### 3.4 Query content filtered by site

```ts
import { getCollection } from "astro:content";
import { getCurrentSite } from "../config/sites";
import { parseMeta } from "../lib/content";

const site = getCurrentSite();
const allPosts = await getCollection("posts");
const sitePosts = allPosts
  .filter((p) => parseMeta(p.id).site === site.slug)
  .sort((a, b) => parseMeta(b.id).date.getTime() - parseMeta(a.id).date.getTime());
```

---

## Phase 4 — Layouts and Components

### 4.1 `BaseLayout.astro` — merges root + app layouts

Port the two Phoenix layouts into one Astro layout:

- HTML boilerplate from `root.html.heex`
- CSS variable injection via `style` attribute on `<body>` (same `theme_style` approach)
- Header with logo, gradient site name, nav links from `app.html.heex`
- JetBrains Mono font import
- Slot for page content

```astro
---
import { getCurrentSite } from "../config/sites";
const site = getCurrentSite();

function themeStyle(theme: Record<string, string>): string {
  return Object.entries(theme)
    .map(([k, v]) => `--${k.replace(/_/g, "-")}:${v}`)
    .join(";");
}

const { title } = Astro.props;
---
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{title ? `${title}${site.titleSuffix}` : site.name}</title>
  <link rel="icon" href={site.logoPath} />
  <!-- JetBrains Mono font -->
  <!-- global.css import -->
</head>
<body style={themeStyle(site.theme)} class="bg-[var(--bg)] text-[var(--text)] antialiased font-sans">
  <header><!-- nav --></header>
  <main><slot /></main>
</body>
</html>
```

### 4.2 Components to extract

| Component | Source | Notes |
|---|---|---|
| `Header.astro` | `app.html.heex` lines 1-20 | Logo + nav links, gradient text |
| `ResearchCard.astro` | `research/index.html.heex` lines 52-69 | Card with title, type badge, source, body |
| `FilterPills.astro` | `research/index.html.heex` lines 5-28 | Type filter pills with active state |
| `PostListItem.astro` | `post/index.html.heex` lines 8-16 | Post title, date, description |

---

## Phase 5 — Pages

### 5.1 `pages/index.astro`

Redirect to `/posts` (matches current Phoenix behavior where `GET /` → redirect to `/posts`).

Or: render the posts list directly at `/` and make `/posts` the redirect. Either preserves behavior.

### 5.2 `pages/posts/index.astro`

Query posts collection filtered by current site. Render list with title, date, description. Direct port of `post_html/index.html.heex`.

### 5.3 `pages/posts/[slug].astro`

Use `getStaticPaths()` to generate one page per post for the current site. Render markdown body with prose styling. Direct port of `post_html/show.html.heex`.

```astro
---
export async function getStaticPaths() {
  const site = getCurrentSite();
  const posts = await getCollection("posts");
  return posts
    .filter((p) => parseMeta(p.id).site === site.slug)
    .map((post) => ({
      params: { slug: parseMeta(post.id).slug },
      props: { post },
    }));
}
---
```

### 5.4 `pages/research/index.astro`

This is the most complex page. Port the research controller logic:

1. Query research items for current site
2. Read `type` from `Astro.url.searchParams` for filtering
3. Group by month, sort descending
4. Render filter pills + conditional layout (cards vs. compact list for type "site")

**Important:** The `?type=` filtering currently works server-side. In a static site, two options:

- **Option A (recommended): Static with client-side filtering.** Build the page once with all items, use a small `<script>` to show/hide cards based on URL param or click. Keeps the pill URLs working (`/research?type=docs`).
- **Option B: Pre-render per type.** Use `getStaticPaths` to generate `/research/`, `/research/docs/`, `/research/paper/`, etc. Changes URLs but eliminates client JS. Filter pills link to `/research/paper/` instead of `?type=paper`.

Option A is closer to current behavior and simpler. Option B is purer SSG.

### 5.5 `pages/about.astro`

Simplest page — render `site.aboutText` with prose styling, plus GitHub/X.com links.

---

## Phase 6 — Styling

### 6.1 Port `app.css` → `src/styles/global.css`

- Keep `.prose-terminal` overrides (they reference CSS variables, work unchanged)
- Keep scrollbar theming
- Replace Makeup syntax highlighting classes (`.highlight .k`, etc.) with Shiki theme config in `astro.config.mjs`

### 6.2 Syntax highlighting

Phoenix uses Makeup (Elixir syntax highlighter). Astro uses Shiki, which supports far more languages. Configure a dark theme that approximates the current Makeup colors:

```js
// astro.config.mjs
export default defineConfig({
  markdown: {
    shikiConfig: {
      theme: "dracula", // close to current dark theme colors
    },
  },
});
```

Or define a custom theme to match the exact Makeup colors if visual parity matters.

### 6.3 Tailwind v4

Astro 5 + Tailwind v4 uses `@import "tailwindcss"` instead of the three separate imports. The `tailwind.config.js` merges into `astro.config.mjs` or stays as a config file — either works. The custom font families and brand colors port directly.

---

## Phase 7 — Static Assets

Copy from Phoenix to Astro:

```
priv/static/favicon.ico    → public/favicon.ico
priv/static/images/        → public/images/
priv/static/robots.txt     → public/robots.txt
```

---

## Phase 8 — Deployment

### Option A: Three static sites on separate hosts

Deploy each build output to its own domain:
- `dist/its-just-shell/` → itsjustshell.dev (Cloudflare Pages, Netlify, Vercel, etc.)
- `dist/its-just-beam/` → itsjustbeam.dev
- `dist/its-just-sound/` → itsjustsound.dev

Eliminates the server entirely. Free tier on most static hosts. Global CDN.

### Option B: Keep Fly.io with a lightweight static server

Build all three, serve with nginx or Caddy with virtual hosts. Preserves single-deployment model but adds a static file server where none is needed.

### Option C: Fly.io static site (Fly.io supports static sites natively)

Fly.io can serve static assets directly. Three apps, or one app with host-based routing in a `fly.toml` + Caddy config.

**Recommendation:** Option A. The whole point of going static is to eliminate the server. Three separate deploys on Cloudflare Pages (free, global CDN, automatic HTTPS) is the simplest production setup.

---

## Phase 9 — Cleanup

After migration is verified:

1. Remove all Elixir/Phoenix files (`lib/`, `config/`, `mix.exs`, `rel/`, `Dockerfile`, `fly.toml`)
2. Move `astro-site/` contents to repo root
3. Update `CLAUDE.md` to reflect the new Astro architecture
4. Update CI/CD if applicable

---

## Migration Mapping Reference

| Phoenix | Astro |
|---|---|
| `Blog.Sites` | `src/config/sites.ts` |
| `Blog.Posts` (NimblePublisher) | `getCollection("posts")` |
| `Blog.Research` (NimblePublisher) | `getCollection("research")` |
| `SitePlug` (middleware) | `SITE` env var at build time |
| `root.html.heex` + `app.html.heex` | `BaseLayout.astro` |
| `post_html/index.html.heex` | `pages/posts/index.astro` |
| `post_html/show.html.heex` | `pages/posts/[slug].astro` |
| `research_html/index.html.heex` | `pages/research/index.astro` |
| `page_html/about.html.heex` | `pages/about.astro` |
| `app.css` | `src/styles/global.css` |
| `tailwind.config.js` | `tailwind.config.mjs` (simplified) |
| Makeup (Elixir highlighter) | Shiki (built into Astro) |
| `priv/posts/**/*.md` | `src/content/posts/**/*.md` |
| `priv/research/**/*.md` | `src/content/research/**/*.md` |
| `priv/static/` | `public/` |
| `Dockerfile` + `fly.toml` | Static host config (e.g., Cloudflare `wrangler.toml`) |
| `mix.exs` | `package.json` |

---

## Risks and Decisions

1. **Research filtering (`?type=`)**: Need to decide between client-side JS filtering (preserves URLs) or pre-rendered per-type pages (changes URLs). Recommend client-side for URL parity.

2. **Markdown rendering differences**: NimblePublisher uses Earmark (Elixir markdown). Astro uses remark/rehype. Output should be nearly identical for standard markdown, but verify edge cases in existing posts.

3. **Syntax highlighting colors**: Makeup → Shiki color mapping won't be pixel-perfect. Need to test with any code blocks in posts/research and tune the Shiki theme.

4. **Content frontmatter compatibility**: The existing frontmatter uses Elixir map syntax (`%{ title: "..." }`) — this needs to be converted to YAML frontmatter for Astro. This is a **required transformation** on every markdown file.

5. **Date parsing from filenames**: Both systems derive the date from the filepath. The Astro implementation needs to replicate this exactly so URLs and sort order match.

6. **`its-just-beam` is a light theme**: While the other two sites are dark, its-just-beam uses light colors. The CSS variable approach handles this already, but `prose-invert` (used in templates) will need to be conditional — only applied for dark-theme sites.
