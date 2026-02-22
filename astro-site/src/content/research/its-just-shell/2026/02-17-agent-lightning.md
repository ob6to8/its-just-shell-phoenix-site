---
title: "Agent Lightning"
url: "https://www.microsoft.com/en-us/research/project/agent-lightning/"
source: "Microsoft Research"
published: "2025"
type: "project"
---
- Decouples agent optimization from agent execution via a sidecar that collects traces non-intrusively — the same separation of concerns that Unix process boundaries already enforce between a program and its observer
- The sidecar pattern is tee for training data: watch what the agent does, capture the interaction traces, optimize separately — no modification to the agent's own code or workflow
- Proves that optimization is orthogonal to orchestration; if your agent is a shell loop, the traces are already in your filesystem (stdout logs, exit codes, tool call records) and the training pipeline is just another downstream consumer
