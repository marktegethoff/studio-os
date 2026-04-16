# Document Templates

Standard document formats for outputs the Write + Ship Gem produces. Use the template that matches the work.

---

## Copy audit document

Use when reviewing existing interface copy across a surface or feature.

```
## Copy Audit: [Surface or Feature Name]
Date: [YYYY-MM-DD]
Reviewer: [Gem / Author]

### Summary
[1–2 sentences on overall state of the copy. Is it mostly right? A specific pattern of failure?]

### Findings

| Element | Current string | Status | Revised string (if REVISE) | Notes |
|---------|----------------|--------|---------------------------|-------|
| [element name] | "[current]" | KEEP / REVISE / REMOVE | "[revised]" | [why] |

### Patterns
[If multiple findings share a root cause — e.g., "all error messages are too vague" — state the pattern. Address the pattern, not just the instances.]

### Priority
[Which REVISE items are blocking vs. recommended. Which REMOVE items will cause confusion vs. just noise.]
```

---

## Accessibility string reference

Use when producing all VoiceOver/TalkBack labels for a surface.

```
## Accessibility Strings: [Surface Name]
Platform: [iOS / Android / Web]
Date: [YYYY-MM-DD]

| Element | Type | Accessible label | Accessible hint (if needed) | Role |
|---------|------|-----------------|----------------------------|------|
| [name] | [button/image/toggle/etc.] | "[label]" | "[additional context]" | [role] |

### Notes
[Any elements with non-obvious reading order. Any dynamic labels that change with state.]
```

---

## Content requirements document

Use when a feature requires user-facing content to be authored (not just labeled).

```
## Content Requirements: [Feature Name]
Date: [YYYY-MM-DD]

### Onboarding
[List all strings that appear during first-use. Include context for each: where it appears, what state triggers it.]

### Empty states
| Surface | Condition | Required copy |
|---------|-----------|---------------|
| [surface] | [why it's empty] | [what the copy must communicate] |

### Error states
| Error | Trigger | Required copy |
|-------|---------|---------------|
| [error name] | [what causes it] | [what the copy must communicate: what happened + what to do] |

### System messages
| Message | Trigger | Required copy |
|---------|---------|---------------|
| [name] | [trigger] | [what the copy must communicate] |

### Voice register
[State the register for this feature: direct / warm / technical / instructional. Note any departures from the product's standard register and why.]
```

---

## Decision record

Use when a structural decision is made that should be logged for future reference.

```
## Decision: [Short name]
Date: [YYYY-MM-DD]
Status: DECIDED / SUPERSEDED BY [decision name]

**Decision:**
[One to three sentences. What was decided.]

**Why:**
[The reason. What alternatives were considered and why this direction was chosen. Include the rejected alternatives — they prevent re-litigating settled questions.]

**Constraints it creates:**
[What future decisions this closes off. What this requires going forward.]

**Open questions at decision time:**
[What was left open — and what would cause this decision to be revisited.]
```

---

## Phase closure note

A shorter alternative to the full sign-off for closing small phases.

```
## Closed: [Phase name]
Date: [YYYY-MM-DD]

What was done: [One sentence]
What was decided: [List of decisions]
Next: [What follows]
```
