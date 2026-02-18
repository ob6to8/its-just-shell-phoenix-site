%{
  title: "The Soul of Erlang and Elixir",
  url: "https://www.youtube.com/watch?v=JvBT4XBdoUE",
  source: "Sasa Juric / GOTO Conferences",
  published: "2019",
  type: "talk"
}
---
- Live-demos the exact properties agents need: process isolation, preemptive scheduling, and supervision — showing a spinning computation that cannot block or crash its neighbors
- Demonstrates shelling into a running BEAM node to inspect and manipulate processes, the kind of runtime observability that agent governance frameworks are trying to build from scratch
- Makes "let it crash" visceral — supervisors restart failed processes automatically, which is precisely the graduated containment that multi-agent safety papers prescribe
