%{
  title: "Announcing Bumblebee: GPT2, Stable Diffusion, and More in Elixir",
  url: "https://news.livebook.dev/announcing-bumblebee-gpt2-stable-diffusion-and-more-in-elixir-3Op73O",
  source: "Livebook.dev",
  published: "December 2022",
  type: "post"
}
---
- Nx.Serving runs ML inference as supervised BEAM processes, which means model serving gets the same fault tolerance, hot-code-upgrade, and per-process isolation that OTP gives to any other workload
- Models deploy into existing Phoenix apps or Broadway pipelines without external inference servers — the BEAM is the orchestrator, not a sidecar to one
- Distributed Nx.Serving scales inference across clustered BEAM nodes using the same primitives (message passing, process groups, supervisors) that would govern a multi-agent system, proving the runtime is ready for AI workloads
