%{
  title: "AgentFS — The Missing Abstraction for AI Agents",
  url: "https://turso.tech/blog/agentfs",
  source: "Turso",
  published: "November 2025",
  type: "post"
}
---
- Everything an agent does — files, state, tool calls — lives in a single SQLite database exposed as a POSIX filesystem; the abstraction is not a new API, it is the filesystem itself
- FUSE support lets agents use git, grep, and standard Unix tools directly against their state store with zero integration code; the trust boundary is the mount point, not a permission model in application code
- Makes agent state portable (one file), auditable (SQL queries over history), and composable (multiple agents share a filesystem with conflict resolution) — the same properties Unix gives processes via /tmp and pipes
