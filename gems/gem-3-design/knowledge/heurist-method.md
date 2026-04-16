# Heurist — Method

The Heurist evaluates screens and interactions against canonical usability heuristics and platform standards. Catches invisible friction, broken mental models, gesture dead-ends, and AI behavior that erodes trust.

---

## The ten heuristics (Nielsen)

Apply these as a structured checklist. For each: evaluate whether the design satisfies it. Flag violations with severity (P0–P3).

**1. Visibility of system status**
The system should always keep users informed about what is going on, through appropriate feedback within reasonable time.

Flag when:
- User performs an action with no visible feedback
- Loading states are absent or ambiguous
- Background processes are invisible

**2. Match between system and the world**
The system should speak the users' language — words, phrases, and concepts familiar to the user rather than system-oriented terms.

Flag when:
- Technical terms appear where plain language would serve
- Metaphors don't map to real-world equivalents
- Labels describe implementation rather than user intent

**3. User control and freedom**
Users often choose system functions by mistake. They need a clearly marked "emergency exit" to leave the unwanted state without having to go through an extended dialogue.

Flag when:
- There is no undo, back, or cancel
- Destructive actions have no confirmation
- Users can enter states they cannot leave

**4. Consistency and standards**
Users should not have to wonder whether different words, situations, or actions mean the same thing. Follow platform conventions.

Flag when:
- Similar interactions produce different outcomes on the same platform
- Platform conventions are violated without reason
- Similar elements use different visual treatments

**5. Error prevention**
Even better than good error messages is a careful design that prevents a problem from occurring in the first place.

Flag when:
- Users can easily trigger destructive actions by accident
- Form fields accept invalid input without constraint
- Gesture conflicts make accidental activation likely

**6. Recognition over recall**
Minimize the user's memory load by making objects, actions, and options visible. The user should not have to remember information from one part of the interface to another.

Flag when:
- Users must remember information from a previous screen
- Options are hidden requiring memorized gestures
- Context from a prior step is not visible

**7. Flexibility and efficiency of use**
Accelerators — unseen by the novice user — may often speed up the interaction for the expert user.

Flag when:
- Expert users have no shortcuts
- Novice users are exposed to complexity they don't need
- The same task requires the same number of steps regardless of expertise

**8. Aesthetic and minimalist design**
Dialogues should not contain irrelevant or rarely needed information. Every extra unit of information competes with the relevant units.

Flag when:
- Screens contain information that doesn't serve the current task
- Decorative elements compete with functional ones
- Multiple elements have equal visual weight where hierarchy is needed

**9. Help users recognize, diagnose, and recover from errors**
Error messages should be expressed in plain language, precisely indicate the problem, and constructively suggest a solution.

Flag when:
- Error messages use codes or technical language
- Errors do not suggest a resolution path
- Errors are modal and block the interface unnecessarily

**10. Help and documentation**
Even though it is better if the system can be used without documentation, it may be necessary to provide help. Documentation should be easy to search and focused on the user's task.

Flag when:
- The system requires documentation to use but none exists
- Help content is generic rather than contextual
- Users cannot access help from where they encounter difficulty

---

## Severity ratings

- **P0 — Critical:** Prevents task completion. Must fix before shipping.
- **P1 — Serious:** Significantly degrades user experience. Fix before shipping.
- **P2 — Moderate:** Causes friction but users can work around it. Fix before or shortly after shipping.
- **P3 — Minor:** Small issue with low impact. Note but do not block shipping.

---

## AI-specific heuristics

Apply these in addition to the ten standard heuristics for any surface involving AI behavior.

**AI transparency:** Users should understand when AI is acting on their behalf and why.
- Is it clear when content was AI-generated vs. user-authored?
- Are AI suggestions distinguishable from user content?

**Trust calibration:** Users should develop accurate expectations of what the AI can and cannot do.
- Does the interface imply higher AI capability than exists?
- Are AI errors clearly recoverable without data loss?

**User authority:** The AI assists; the user decides.
- Can the user always override, reject, or ignore AI suggestions?
- Does the AI ever act without visible user intent?

**Legible reasoning:** When the AI makes a recommendation, users should be able to understand the basis for it.
- Is the reason for an AI suggestion surfaced or suppressible?
- Does the AI cite specific content when making claims about it?
