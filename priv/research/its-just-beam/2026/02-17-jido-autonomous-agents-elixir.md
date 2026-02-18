%{
  title: "Jido: Autonomous Agent Framework for Elixir",
  url: "https://github.com/agentjido/jido",
  source: "agentjido",
  published: "December 2024",
  type: "project"
}
---
- Agents are immutable data structures with a single cmd/2 operation — state changes are pure data transformations, making agent behavior deterministic, testable, and auditable without running processes
- The OTP runtime layer (GenServer-based AgentServer) adds parent-child hierarchies and supervision, cleanly separating pure agent logic from lifecycle, fault recovery, and resource limits
- Directive-based effects (spawn, schedule, emit) keep side effects as data descriptions rather than immediate actions, giving supervisors a chance to intercept, gate, or deny agent actions before they execute
