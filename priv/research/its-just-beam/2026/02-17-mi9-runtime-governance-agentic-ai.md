%{
  title: "MI9: An Integrated Runtime Governance Framework for Agentic AI",
  url: "https://arxiv.org/abs/2508.03858",
  source: "Wang, Singhal, Kelkar, Tuo",
  published: "August 2025",
  type: "paper"
}
---
- Proposes FSM-based conformance engines, graduated containment (monitoring to tool restriction to isolation), and per-agent telemetry — all patterns that map directly to OTP supervision trees, process isolation, and :observer
- The paper's graduated containment escalation (restrict, then isolate, then kill) is exactly what an OTP supervisor already does with its restart strategies: one_for_one, rest_for_one, one_for_all
- Validates the BEAM thesis from the other direction: AI safety researchers are independently deriving the runtime governance model that Erlang shipped in production thirty years ago
