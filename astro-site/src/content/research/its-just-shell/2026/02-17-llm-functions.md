---
title: "llm-functions"
url: "https://github.com/sigoden/llm-functions"
source: "sigoden"
published: "2024"
type: "project"
---
- Defines LLM tools as plain Bash functions with structured comments — the tool schema is generated automatically from the script itself, no SDK or serialization layer needed
- Agents are composed from tools + prompts + documents, assembled at the filesystem level; adding a capability means dropping a shell script into a directory
- Proves that function calling does not require a framework: a shell function, a naming convention, and a comment block are sufficient for an LLM to discover and invoke a tool
