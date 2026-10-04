---
name: ideate-rejects-solution
description: "/studio:ideate refuses a solution-in-disguise and asks for the underlying problem."
tags: [gate, smoke]
plugins: ["../../.."]
expected_outcome: "Claude names the input as a solution and asks for the problem; no ideas are generated."
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

/studio:ideate add a Kanban board
