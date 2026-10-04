---
name: implement-requires-brief
description: "/studio:implement refuses to start without a five-field task brief."
tags: [gate, smoke]
plugins: ["../../.."]
expected_outcome: "Claude stops at Step 0 and asks for a task brief, pointing to /studio:shape --task; no code is written or proposed."
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

/studio:implement add a dark-mode toggle to the settings screen
