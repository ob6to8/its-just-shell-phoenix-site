---
title: "What is a Tool?"
description: "A high level overview of tool calling."
tags: ["ai", "tools", "explainer"]
---
*A high level overview of tool calling.*

A "tool" is a name for "a thing that an LLM can do", though counter-intuitively LLMs actually can't "do" anything. An LLM can only process and emit text to its contact in the outside world, which is a deterministic program usually called a harness. It is this harness that actually acts as a proxy and calls tools, or takes action, on behalf of the LLM.

You can think of an LLM as a brain, and the harness as the body.

When a user chats with an LLM, the harness sends the user's message to the LLM along with a list of tools the harness can execute on the LLM's behalf - "here are some things I can do if you want to ask me to do them." If the LLM wants action to be taken based on the context of the user's message, it tells the harness which of these tools to call, along with what information the LLM wants to be sent along with that tool call. The harness does this, then returns the result of that action back to the LLM.

The LLM will then do one of three things: 1)  take that result and create a prose response out of it to return to the user, 2) fold the tool results into multi-step reasoning, or 3) trigger additional tool calls.

Let's look at an example, say you were to ask an LLM what the weather is in Half Moon Bay. The harness will send the LLM, along with your request, a list of tools that it can use. In fact, the harness provides this tool catalog with every single message to the LLM, as the LLM has no memory between calls, and the harness must re-send the full context (conversation history, tool catalog, everything) each time.

The LLM will then select the tool that is most likely to achieve the current goal, finding the weather. Let's say in this case it decides to launch a web search, the "tool", with the query "what is the weather in half moon bay." The LLM communicates this by returning a response in a structured data format called JSON.. So, instead of returning prose like it usually does, the LLM returns a JSON response, which includes within it not only the tool it wants to call but any other data, like the search query ("weather in Half Moon Bay.")

On receipt of the JSON, the harness, which is just a program, deterministically recognizes that JSON has been sent and that it is a tool call. It then executes the tool call, gets some sort of data as a result, sends the resulting data to the LLM. At this point, as sketched out before, the LLM can either return "the weather in Half Moon Bay is sunny and 70 degrees" to the user, fold the weather result into further multi-step reasoning, or make a follow up tool call.

A note on structured data, which is data that enforces a schema, or a format. Structured data is consistent and enforced - violating the schema will cause an error, and be seen as bad data. JSON is one of many types of structured data, but happens to be the type that has been chosen by the frontier model companies to use for tool calling. However (and this is not a small however) they did not agree on any sort of standard for what that JSON actually is across their models when they came up with this stuff. This means that each frontier model is fine tuned on examples of tool calls using their own proprietary schema, or format. This means that each LLM has its own way of doing things and it will not be changing anytime soon, the frontier labs are unlikely to come up with a universal standard tool calling schema and retrain their models. This means that to support multiple models as a harness, you need to write bespoke translation logic for each LLM.

And that, my friends, is a basic overview of tool calling.
