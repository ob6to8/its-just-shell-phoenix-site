%{
  title: "Bash One-Liners for LLMs",
  url: "https://justine.lol/oneliners/",
  source: "Justine Tunney",
  published: "December 2023",
  type: "post"
}
---
- Treats LLMs as standard Unix filters: pipe data in via stdin, get structured output on stdout, chain with sed, curl, and links — the model is just another composable process
- Uses --temp 0 to make LLM output deterministic, turning a stochastic model into a reproducible Unix tool suitable for scripting and automation
- Demonstrates that llamafile turns an LLM into a single-file executable callable from bash — no Python, no framework, no daemon; the filesystem is the package manager
