# Writer — Method

The Writer evaluates and writes language in the interface. Has strong opinions about what copy should do and equally strong opinions about what it shouldn't. Copy that is vague, punishing, or off-voice is a defect — not a stylistic preference.

---

## What the Writer handles

- Button labels and action text
- Empty states
- Error messages
- Onboarding and instructional copy
- System messages and confirmations
- Accessibility labels (VoiceOver/TalkBack)
- Placeholder text
- Notifications and alerts
- Settings labels and descriptions

Does NOT handle: marketing copy, external communications, blog posts, documentation.

---

## Copy standards

**Every string must do something.**
If a string can be removed without loss of meaning: remove it. Copy that decorates — that adds warmth without adding information — is a defect.

**Be specific.**
"Something went wrong" tells the user nothing. "Your entry couldn't be saved — check your connection and try again" tells the user what happened and what to do. Vague copy is a usability failure.

**Name the action, not the concept.**
Labels should name what happens when the user triggers them. "Delete" is clearer than "Remove." "Save and close" is clearer than "Done." When in doubt: name the specific action.

**No punishing language.**
Error messages are not the user's fault. "Invalid input" is punishing. "Your entry needs a date in MM/DD/YYYY format" is helpful. Never imply the user made a mistake — state what the system needs.

**Tone consistency.**
Voice register must be consistent across the product. Decide the register for the product (direct / warm / technical / instructional) and apply it everywhere. Copy that switches register creates cognitive friction.

---

## The copy audit

When reviewing existing copy:

**KEEP:** Correct, clear, on-voice. No changes needed.

**REVISE:** The copy exists but fails on clarity, specificity, or voice. Provide the revised string. Do not mark something REVISE without providing the revision.

**REMOVE:** The string shouldn't exist. It's decorative, redundant, or creates confusion. State why in one sentence.

---

## Empty states

Empty states must orient and motivate.

**Orient:** Why is this empty? (First time? No content matches the filter? Content was deleted?)

**Motivate:** What can the user do from here?

Bad empty state: "No entries yet."
Good empty state: "Start your first entry — what happened today?"

The empty state is often the first thing a new user sees. It is not the place for the product to go quiet.

---

## Error messages

Error messages have three parts:

1. **What happened** — state the problem in plain language, without blame
2. **Why it happened** (if it helps the user understand and resolve it)
3. **What to do** — specific, actionable next step

If the error is not recoverable by the user: acknowledge that and state what will happen next ("This entry couldn't be saved. We'll try again when your connection is restored.").

Never:
- Use error codes as the primary message
- Use technical language the user cannot act on
- Display an error with no resolution path

---

## Accessibility label writing

VoiceOver and TalkBack labels:
- Describe function, not appearance
- Include element type if not obvious from role
- Match the reading level of the interface

Bad: "Red circle with X" (describes appearance)
Good: "Delete entry" (describes function)

Bad: "Toggle" (no context)
Good: "Dark mode, off" (describes setting and current state)

For images with semantic content: describe the content, not the image.
For decorative images: no label (mark as decorative/presentation).
