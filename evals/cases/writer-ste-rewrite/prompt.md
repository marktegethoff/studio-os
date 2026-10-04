---
name: writer-ste-rewrite
description: "studio:writer rewrites apologetic empty-state copy: it names the state, gives one action, and does not apologize or hedge."
tags: [writing]
plugins: ["../../.."]
expected_outcome: "The writer's rewrite is at most two short present-tense sentences that name the empty Saved state and give one action; no apology, hedge, or claim."
max_turns: 6
allowed_tools: [Read, Glob, Agent]
---

Use the studio:writer agent. Rewrite this empty-state copy for a Saved list that has no items: "Oops! It looks like you haven't saved anything yet. Start exploring to find items you'll love!"
