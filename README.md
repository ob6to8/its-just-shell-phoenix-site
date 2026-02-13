# Blog

A Phoenix blog powered by [NimblePublisher](https://github.com/dashbitco/nimble_publisher). Posts are markdown files compiled into the app at build time — no database required.

## Local development

```bash
mix setup          # install dependencies and build assets
mix phx.server     # start the server at http://localhost:4000
```

Or run inside IEx for interactive debugging:

```bash
iex -S mix phx.server
```

## Writing a post

Add a markdown file to `priv/posts/` following this naming convention:

```
priv/posts/<YEAR>/<MM>-<DD>-<slug>.md
```

For example: `priv/posts/2026/02-12-hello-world.md`

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
