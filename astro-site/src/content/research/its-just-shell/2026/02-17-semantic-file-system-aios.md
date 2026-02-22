---
title: "From Commands to Prompts: LLM-based Semantic File System for AIOS"
url: "https://arxiv.org/abs/2410.11843"
source: "Shi, Mei, Zhang et al."
published: "2025"
type: "paper"
---
- Proposes replacing shell commands with natural-language prompts that compile down to the same POSIX file operations — the filesystem API is the stable interface, whether the caller is a human or an LLM
- Demonstrates 15%+ retrieval accuracy gains and 2.1x speed improvement over traditional file systems by adding a semantic index layer, while preserving full POSIX semantics underneath
- Includes safety mechanisms (confirmation before destructive ops, rollback) that map exactly to the trust-gradient argument: the OS already has the permission model, the agent just needs to respect it
