---
title: "smolagents"
url: "https://huggingface.co/blog/smolagents"
source: "Hugging Face"
published: "December 2024"
type: "framework"
---
- The entire library is roughly 1,000 lines of code — a deliberate rejection of the sprawling framework approach; minimal abstraction means you can read the whole agent runtime in one sitting
- Code agents outperform JSON tool-calling agents by ~30% fewer steps because code is inherently composable: you can nest calls, define variables, and loop — the same properties that make shell scripts powerful
- The core design insight maps directly to the shell thesis: agents should write executable actions (code), not describe desired actions (JSON) — the agent is a script
