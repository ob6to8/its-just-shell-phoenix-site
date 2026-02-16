%{
  title: "The Zen of Erlang",
  url: "https://ferd.ca/the-zen-of-erlang.html",
  source: "ferd.ca",
  published: "February 2016",
  tags: ["erlang", "otp", "fault-tolerance"]
}
---
- Explains how OTP supervision trees encode recovery strategies as explicit architectural decisions, not afterthought error handling
- Distinguishes between errors (expected, handle inline) and failures (unexpected, let the process crash and restart clean)
- "Let it crash" requires pre-planned supervision hierarchies — the crash is intentional, not accidental
