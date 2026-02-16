# Project: ITS JUST — Multi-Tenant Phoenix Blog

## Architecture

Multi-tenant Phoenix app serving three sites from one codebase and one Fly.io deployment. No database — all content is compiled into the app at build time via NimblePublisher.

### Sites

| Slug | Domain | Thesis |
|---|---|---|
| `its-just-shell` | itsjustshell.dev | Simple composable tool loops for AI |
| `its-just-beam` | itsjustbeam.dev | Elixir, OTP, and the BEAM VM |
| `its-just-sound` | itsjustsound.dev | Sonification, music, observability through audio |

Sites are defined as structs in `lib/blog/sites.ex` with slug, domains, theme colors, logo, and about text. Default site is `its-just-shell`.

### Site Detection

`BlogWeb.Plugs.SitePlug` resolves the current site on every request:
1. `?site=<slug>` query param (dev convenience, saved to session)
2. HTTP host header matched against `site.domains` (production)
3. Falls back to default site

The resolved site is available as `conn.assigns.current_site`.

### Routes

```
GET  /           → redirects to /posts
GET  /about      → per-site about page
GET  /posts      → post index (filtered by current site)
GET  /posts/:id  → single post
GET  /research   → research index (filtered by current site, optional ?type= filter)
```

## Content Model

Both content types use NimblePublisher — markdown files compiled at build time into module attributes. No runtime file reads, no database.

### Posts

Path: `priv/posts/<site-slug>/<YEAR>/<MM>-<DD>-<slug>.md`
Struct fields: `id`, `site`, `title`, `body`, `date`, `description`, `tags`

Frontmatter: `title`, `description`, `tags` (list of strings).
Date and slug are parsed from the filename.

### Research Items

Path: `priv/research/<site-slug>/<YEAR>/<MM>-<DD>-<slug>.md`
Struct fields: `id`, `site`, `title`, `url`, `source`, `body`, `date`, `published`, `type`

Frontmatter: `title`, `url`, `source`, `published`, `type`.
Valid types: `docs`, `framework`, `paper`, `post`, `project`, `protocol`, `talk`.

Research items are curated external links. The body is bullet points explaining why the resource matters to the site's thesis. The `type` field is the only taxonomy — `tags` was deliberately removed to keep classification simple.

The `/research` page shows filter pills for each type. Filtering is via `?type=<type>` query param.

## Key Modules

- `Blog.Sites` — site definitions, lookup by host/slug
- `Blog.Posts` / `Blog.Posts.Post` — NimblePublisher for blog posts
- `Blog.Research` / `Blog.Research.ResearchItem` — NimblePublisher for research items
- `BlogWeb.Plugs.SitePlug` — multi-tenant site resolution middleware

## Development

```bash
mix setup          # install deps and build assets
mix phx.server     # start at localhost:4000
```

Switch sites in dev: `localhost:4000?site=its-just-beam`

After adding/editing markdown, recompile (`mix compile`) or let the live reloader handle it.

## Deployment

Single Fly.io app: `fly deploy`. Content is baked into the Docker image at build time.
