# Product Brief: HTML Prototype Annotation Skill
Date: 2026-05-03
Status: LOCKED

## Problem statement
Designers, PMs, and engineers at Capital One who iterate on HTML prototypes daily cannot give structured, element-specific feedback in a format Claude Code understands, because feedback tools (Figma, Docs, spreadsheets) are disconnected from the prototype and require manual translation — which inflates cycle time and loses fidelity.

## Who has it
Designers primarily; PMs and engineers secondarily. Capital One teams adopting Claude Code for HTML prototype iteration. Daily use. The designer is the primary feedback author; the triad is the intended audience for the output.

## What they do today
Fragmented across Figma comments, Google Docs, and spreadsheets. Figma is the most natural channel but comments stay there — they don't flow back into the prototype or iteration prompt. Manual translation required at every step.

## Success conditions
- A designer can click any element in an HTML prototype and attach a comment
- Feedback output is formatted for Claude Code consumption (structured, element-specific, copy-paste ready)
- No translation layer between observation and prompt
- Cycle time for a feedback round drops measurably
- Agents/Claude can also surface questions to the user through the same interface

## Out of scope
- Server-side infrastructure
- Application delivery — this is a skill that generates a temporary HTML wrapper
- v0.0.5: full persistence architecture (local storage within the HTML file is acceptable if low-cost; building a dedicated storage layer is not)

## Nice to have
- In-session persistence via local storage within the generated HTML file
