---
title: "Web Audio API"
url: "https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API"
source: "MDN"
published: "2011"
type: "protocol"
---
- W3C specification for high-performance audio processing in the browser through a directed graph of audio nodes
- The audio graph model (source → processing → destination) maps naturally to data sonification pipelines: connect data to oscillators, filters, and gain nodes
- Runs on a separate high-priority thread from the main JavaScript event loop, enabling real-time audio even when the UI thread is busy
