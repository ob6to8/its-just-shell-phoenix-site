%{
  title: "Hello World",
  description: "My first blog post built with Phoenix and NimblePublisher.",
  tags: ["elixir", "phoenix"]
}
---
Welcome to my blog! This is a post written in **Markdown** and compiled at build time by NimblePublisher.

No database required — just markdown files in the repo.

## How it works

1. Write a markdown file in `priv/posts/`
2. NimblePublisher compiles it into your app
3. Deploy to Fly.io

```elixir
IO.puts("Hello from Phoenix!")
```
