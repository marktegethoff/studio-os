---
description: The Slop Test — the studio's quality floor. Checks a piece of studio output (an agent response, an artifact, a spec, a verdict) for competent-looking-but-vacuous content — discipline vocabulary applied without discipline judgment. Built to run on top of a passing eval suite: the evals confirm the agent did the right thing; the Slop Test confirms the output actually says something.
argument-hint: "<the output to test — paste it, or point to a file>"
---

Test studio output for slop — competent-looking emptiness.

Arguments: $ARGUMENTS

An eval can pass while the output is still hollow: the right sections, the right words, the right format — and no actual judgment underneath. That is slop. This is the last gate, the quality floor, and it is deliberately hard to pass: it does not ask "does this look like good studio work?" It asks "does this output make a specific, falsifiable, useful claim — or is it discipline cosplay?"

Run it on any output before it ships, especially output that *passed its evals* (a passing suite is necessary, not sufficient).

---

## The seven slop markers

Read the output and check each. Any marker firing is a finding; the verdict is SLOP if the output's core claim rests on one.

1. **Vocabulary without judgment** — uses discipline terms (parti, register, invariant, leading indicator, binding constraint) without applying them to *this specific* decision. Term-dropping in place of thinking.
2. **Generic, not specific** — the output would read identically for a different product or problem. It names nothing concrete — no specific element, value, user, or tradeoff.
3. **Format without substance** — every section of the template is filled, and every section is hollow. Structure used as a substitute for content.
4. **Hedging as analysis** — "it depends," "consider," "you might want to," a list of options with no recommendation. Optionality offered where a judgment was owed.
5. **Prompt restatement** — describes the problem back to the user, possibly reorganized, without advancing it. Motion mistaken for progress.
6. **Unfalsifiable claim** — an assertion with no counter-argument and no failure condition. If it can't be wrong, it isn't a claim.
7. **Citation without lesson** — name-drops a reference, figure, or precedent without the method or what to do differently because of it.

---

## Procedure

1. Identify the output's **core claim or recommendation** — the one thing it is actually asserting. If you can't find one, that is itself the finding (likely markers 3 + 5).
2. Test that core claim against the seven markers.
3. For each marker that fires, quote the offending span and name the marker.
4. Render the verdict.

---

## Output

```
## Slop Test — [what was tested]

Core claim: [the one thing it asserts — or "none found"]

Markers fired:
- [marker] — "[quoted span]" — [why it's hollow]

Verdict: CLEAN / SLOP
[If SLOP: the single change that would make it substantive — usually "make the
core claim specific and falsifiable, then say what to do about it."]
```

---

## Rules

- **The floor is high.** Looking like studio work is the thing being tested *against*, not for. Competent surface + empty core = SLOP.
- **One real, specific, falsifiable claim clears the floor.** Slop is the absence of that, however polished the wrapper.
- **Built on the evals, not instead of them.** Behavior evals first (did the agent act right?), then the Slop Test (did it actually say something?). A studio output is shippable only when both pass.
- **Apply to your own output too.** Before delivering a verdict or artifact, run the markers on it. The Slop Test is also a self-check.
