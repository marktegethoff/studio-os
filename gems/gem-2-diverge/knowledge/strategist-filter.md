# Strategist Filter for Ideation

The Strategist lens applied in the Diverge Gem. Used to filter generated directions before they become idea cards.

---

## What the Strategist filters

After generation, before reduction: run each direction through the Strategist filter.

Three questions. If any answer is clearly NO: the direction is removed from consideration, with one sentence on why.

**1. Does this direction deepen the product's core value loop, or expand away from it?**

Deepen: the product becomes more of what it already is. Users who came for the core value get more of it.
Expand: the product becomes something adjacent. This direction requires a different mental model or serves a different user need than the core.

Expansion is not automatically disqualifying — but it requires that the user explicitly choose to expand. Remove expanding directions from the ranked set and present them separately, labeled as expansions.

**2. Does this direction require behavior the current user base has not developed?**

Some directions are correct in principle but premature in practice. A direction that requires users to maintain complex organizational systems, establish habits that don't yet exist, or understand abstractions they haven't been exposed to is stage-mismatched.

Stage mismatch is not a permanent disqualification — it is a timing note. Remove stage-mismatched directions from the current set and label them as "future consideration."

**3. Does this direction require capabilities (technical, operational, regulatory) that don't yet exist?**

Capability gaps are implementation risks, not conceptual disqualifications. But if the required capability is years away or fundamentally uncertain, the direction belongs in a future backlog, not a current idea set.

---

## Strategist filter output

For each direction filtered:
- PASS — the direction survives the filter
- EXPAND — the direction is valid but expands the product's scope; present separately, not in the main ranked set
- PREMATURE — correct direction, wrong timing; label and defer
- BLOCKED — requires capability that doesn't exist; state what's missing

Directions that are PASS move to idea cards. All others are labeled and noted, not deleted — the user may want to see what was filtered and why.

---

## When to skip the Strategist filter

If the product purpose is not well defined, the Strategist filter cannot be applied accurately. Skip it and note that: "Without a clear product purpose statement, the Strategist filter cannot determine fit." Prompt the user to define the core purpose before proceeding.

If the user has explicitly asked for expansive exploration ("what could this become?") rather than directional focus: apply the filter lightly — flag expansions and premature directions, but do not remove them.
