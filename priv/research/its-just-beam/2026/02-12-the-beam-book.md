%{
  title: "The BEAM Book",
  url: "https://github.com/happi/theBeamBook",
  source: "GitHub",
  published: "2017",
  type: "project"
}
---
- Deep dive into BEAM virtual machine internals: schedulers, memory management, garbage collection, and the process model
- Explains how the BEAM achieves soft real-time properties through preemptive scheduling based on reduction counts, not time slices
- Essential reference for understanding why BEAM processes are cheap (< 1KB initial heap) and how the VM enables millions of concurrent processes
