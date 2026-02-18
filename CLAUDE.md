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
Valid types: `docs`, `framework`, `paper`, `post`, `project`, `protocol`, `site`, `talk`.

Research items are curated external links. The body is bullet points explaining why the resource matters to the site's thesis. The `type` field is the only taxonomy — `tags` was deliberately removed to keep classification simple.

The `/research` page groups items by month (date added, from filename) with dividers, and shows filter pills for each type. Filtering is via `?type=<type>` query param. New items should use today's date in the filename so they sort to the top.

Items with `type: "site"` are for featuring full websites. They behave differently from other types: hidden from the default "all" card grid, and when the "site" pill is clicked, they render as a compact vertical list (title + one-line blurb) instead of cards. The body should be a single short sentence, not bullet points.

#### Editorial Guidance — Research Placement

The same resource can appear on multiple sites. What determines placement is whether you can write bullets that tie it back to *that site's thesis* without forcing the connection.

- **its-just-shell**: Does this resource illustrate that the pattern is a tool loop? Bullets should connect to composability, read-eval-print cycles, Unix primitives. AI/agent research belongs here when the point is that agents are just shell — tool loops, not a new paradigm.
- **its-just-beam**: Does this resource illustrate something about the runtime, process model, or fault tolerance? Bullets should connect to OTP, supervision, concurrency, the BEAM.
- **its-just-sound**: Does this resource illustrate sonification, audio as an interface, or music as computation? Bullets should connect to listening as an observability channel.

The test: can you write three bullets that naturally tie the resource to the site's thesis? If the bullets feel forced, it doesn't belong on that site.

#### Research Curation Process

When searching for new research items to add:

1. **Batch size**: 6 items per site per batch.
2. **Deduplicate**: Check existing items in `priv/research/<site-slug>/` before searching. Never add a resource that's already featured.
3. **Search strategy**: Use each site's thesis as the search lens:
   - *its-just-shell*: tool loops, Unix composability, filesystem-as-state, agent architectures that reduce to shell, trust gradients, script-driven vs LLM-driven control
   - *its-just-beam*: OTP supervision, process isolation, actor model for agents, distributed coordination, fault tolerance, BEAM ecosystem AI tooling
   - *its-just-sound*: data sonification, auditory displays, sound for monitoring/observability, audio as interface, music-as-computation
4. **Three-bullet test**: Every candidate must pass — can you write 3 bullets that naturally tie it to the site's thesis? If forced, skip it.
5. **Type diversity**: Aim for a mix of types (post, paper, project, talk, framework, docs) within each batch. Don't load up on one type.
6. **Filename**: Use today's date — `<MM>-<DD>-<slug>.md` — so new items sort to the top.
7. **Verify URLs**: All URLs must be real and reachable. Prefer primary sources over summaries.

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
