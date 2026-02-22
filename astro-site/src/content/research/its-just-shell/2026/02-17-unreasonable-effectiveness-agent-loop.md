---
title: "The Unreasonable Effectiveness of an LLM Agent Loop with Tool Use"
url: "https://sketch.dev/blog/agent-loop"
source: "sketch.dev"
published: "May 2025"
type: "post"
---
- The entire agent pattern reduces to a 9-line while loop: read input, call tool, feed output back — this is a read-eval-print loop, the same pattern shells have used for fifty years
- With just one general-purpose tool — bash — current models can solve many problems in a single shot; the agent does not need a framework, it needs a shell
- Argues custom agent loops will replace tasks "too specific for general tools and too unstable to automate traditionally" — the exact niche shell scripts have always filled
