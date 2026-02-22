---
title: "Model Context Protocol (MCP)"
url: "https://modelcontextprotocol.io/"
source: "Anthropic"
published: "November 2024"
type: "protocol"
---
- Open protocol for connecting AI assistants to external data sources and tools through a standardized JSON-RPC interface
- Servers expose tools, resources, and prompts; clients (LLMs) discover and invoke them — the AI equivalent of USB-C for context
- Keeps tool integration composable: each server is a single-purpose process, orchestrated by the model's own tool loop
