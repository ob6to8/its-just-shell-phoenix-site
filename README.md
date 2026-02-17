# Blog

A multi-tenant Phoenix blog powered by [NimblePublisher](https://github.com/dashbitco/nimble_publisher). Three sites — **itsjustshell.com**, **itsjustbeam.com**, and **itsjustsound.com** — are served from a single codebase and deployment. Each site has its own posts, color theme, and logo. Posts are markdown files compiled into the app at build time — no database required.

## Local development

```bash
mix setup          # install dependencies and build assets
mix phx.server     # start the server at http://localhost:4000
```

Or run inside IEx for interactive debugging:

```bash
iex -S mix phx.server
```

In dev, all sites share `localhost:4000`. Switch sites with a query param:

- `localhost:4000` — its-just-shell (default)
- `localhost:4000?site=its-just-beam` — its-just-beam
- `localhost:4000?site=its-just-sound` — its-just-sound

The `?site=` param is saved in the session so you can navigate without repeating it. In production, site detection is automatic via hostname.

## Writing a post

Add a markdown file to the appropriate site directory following this naming convention:

```
priv/posts/<site-slug>/<YEAR>/<MM>-<DD>-<slug>.md
```

For example: `priv/posts/its-just-shell/2026/02-12-hello-world.md`

Available site slugs: `its-just-shell`, `its-just-beam`, `its-just-sound`.

Each file needs frontmatter at the top (valid Elixir map syntax), separated from the body by `---`:

```markdown
%{
  title: "My Post Title",
  description: "A short summary shown on the index page.",
  tags: ["elixir", "phoenix"]
}
---
Your **markdown** content goes here.

Code blocks get syntax highlighting:

```elixir
IO.puts("Hello!")
```
```

The date and slug are parsed from the filename — no need to repeat them in the frontmatter.

## Adding a research item

Research items are curated links to external resources (papers, projects, frameworks, docs, talks). Add a markdown file:

```
priv/research/<site-slug>/<YEAR>/<MM>-<DD>-<slug>.md
```

Frontmatter requires `title`, `url`, `source`, `published`, and `type`:

```markdown
%{
  title: "Example Paper",
  url: "https://example.com/paper",
  source: "arXiv",
  published: "January 2025",
  type: "paper"
}
---
- A bullet summarizing why this resource matters to the site's thesis
```

Valid types: `docs`, `framework`, `paper`, `post`, `project`, `protocol`, `site`, `talk`. The `/research` page displays filter pills for each type present on the current site. Items with type `site` are shown as a compact row of links above the card grid instead of as cards.

## How NimblePublisher works

Posts are compiled into the application at build time, not read from disk at runtime. This means:

- After adding or editing a post, you need to recompile (`mix compile`) or restart the server
- In dev mode, the live reloader watches `priv/posts/*.md` and triggers recompilation automatically
- Posts are stored as a module attribute — zero runtime cost, no database

## Running tests

```bash
mix test
```

## Deploy to Fly.io

First-time setup:

```bash
fly launch              # creates the app and updates fly.toml
fly secrets set SECRET_KEY_BASE=$(mix phx.gen.secret)
```

Deploy (every time you add/change posts or code):

```bash
fly deploy
```

That's it. No database provisioning, no migrations. The markdown posts are baked into the Docker image at build time.

### Fly.io configuration

The `fly.toml` ships with placeholder values. After running `fly launch`, update:

- `app` — your Fly app name
- `PHX_HOST` — your app's hostname (e.g. `your-app.fly.dev`)
