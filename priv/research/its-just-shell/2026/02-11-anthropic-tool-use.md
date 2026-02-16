%{
  title: "Anthropic Tool Use Documentation",
  url: "https://docs.anthropic.com/en/docs/build-with-claude/tool-use/overview",
  source: "Anthropic Docs",
  published: "2024",
  type: "docs"
}
---
- Reference for Claude's native tool-use interface: define tools as JSON schemas, the model emits structured tool_use blocks, you execute and return results
- The interaction pattern is a synchronous tool loop — exactly the shell paradigm of prompt → command → output → prompt
- Supports forced tool use, parallel tool calls, and streaming, showing how the simple loop extends without changing its fundamental shape
