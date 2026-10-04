---
name: critic-refutation-sound
description: "Critic refutes a CD SHIP on a sound artifact: the refutation fails, no defects are manufactured."
tags: [refutation]
plugins: ["../../.."]
expected_outcome: "The critic reports the refutation failed and the verdict stands, or names only defects quoted from the artifact."
max_turns: 6
allowed_tools: [Read, Glob, Agent]
---

Use the studio:critic agent. The Creative Director ruled SHIP on this empty state for a list screen: one line of body text, "Nothing here yet. Items you add will appear in this list.", and one primary button, "Add item". No illustration, no secondary actions. Refute that verdict.
