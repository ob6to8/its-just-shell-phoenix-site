---
title: "Phoenix Framework"
url: "https://www.phoenixframework.org/"
source: "phoenixframework.org"
published: "2014"
type: "framework"
---
- Web framework for Elixir that exploits BEAM's concurrency model to handle massive numbers of persistent connections (channels, LiveView)
- LiveView eliminates the SPA/API split by rendering server-side HTML and pushing diffs over WebSockets — real-time UIs without JavaScript frameworks
- Each request and each WebSocket connection runs in its own BEAM process, inheriting fault isolation and preemptive scheduling for free
