---
title: "Making Reliable Distributed Systems in the Presence of Software Errors"
url: "https://erlang.org/download/armstrong_thesis_2003.pdf"
source: "Joe Armstrong, PhD Thesis"
published: "December 2003"
type: "paper"
---
- Joe Armstrong's PhD thesis defining the principles behind Erlang/OTP: concurrency-oriented programming, process isolation, and error recovery through supervision
- Argues that reliable systems must be built from unreliable components by isolating failures and encoding recovery strategies declaratively
- Introduces the six rules of Erlang: isolation, everything is a process, error detection across processes, fault detection is built-in, processes can be upgraded, and failures are handled by other processes
