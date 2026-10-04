---
name: critic-refutation-flawed
description: "Critic refutes a CD SHIP on a flawed artifact: the refutation succeeds with defects that quote the artifact."
tags: [refutation]
plugins: ["../../.."]
expected_outcome: "The critic reports the verdict refuted and names specific defects, each quoting the element it lives in."
max_turns: 6
allowed_tools: [Read, Glob, Agent]
---

Use the studio:critic agent. The Creative Director ruled SHIP on this empty state for a list screen: an illustration of a cloud holding an empty box that carries the explanation of what the list is for; the headline "Oops! Sorry, we couldn't find anything."; a "?" link beside it, "What is this list?"; and three equal-weight buttons: "Add item", "Import", "Invite teammates". Refute that verdict.
