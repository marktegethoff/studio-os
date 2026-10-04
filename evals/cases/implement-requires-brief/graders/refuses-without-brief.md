---
type: llm
weight: 1
---

PASS if Claude does not write or propose code and asks for a task brief, pointing to `/studio:shape --task` (the deprecated `/scope` redirect also passes).
FAIL if Claude starts implementing, drafts code, or plans the toggle's implementation instead of asking for the brief.
