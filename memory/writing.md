# Writing — Registers

How the studio writes. Every artifact declares one register. `evals/ste-check.sh` enforces the limits.

**Principle:** strictness follows the cost of a misreading. A builder acts on a procedure, a reader weighs a verdict, a thinker explores.

The registers adapt ASD-STE100 (Simplified Technical English, STE). Each register relaxes the standard by the reader's task.

---

## Registers

| Register | Used for | Sentence limit | Rule |
|---|---|---|---|
| `procedure` | specs, task briefs, handoff, motion specs, state inventories, wireframe and flow annotations, implement steps | 20 words | Strict STE |
| `verdict` | reviews, critiques, heuristic reports, decision records, risk registers, metrics plans, experiment plans, design briefs | 25 words | About 80% STE |
| `exploratory` | ideation, journeys, narratives, competitive teardowns, conversation | 25 words, as a guide | Current voice |

**Procedure**
1. Write one instruction in each sentence.
2. Use the imperative for an instruction.
3. Use the active voice.
4. Keep each sentence to 20 words or fewer.
5. Use no -ing form, except in a technical name.
6. Use no hedge and no interjection.

**Verdict**
1. Keep each sentence to 25 words or fewer.
2. Use the active voice.
3. Write one topic in each paragraph.
4. Use simple tenses.
5. Use studio terms. They need no gloss.
6. Use no hedge and no interjection.

**Exploratory**
1. Write in the current voice.
2. Treat the STE limits as a guide. Split a sentence over 25 words when it reads better.

## Product copy and the dictionary

Product copy that ships (UI strings) is not studio prose. It follows the product's voice. Only the dictionary applies.

The project's `.claude/memory/design-vocabulary.md` (Product tier) is the dictionary. It holds the STE technical names and verbs. One word has one meaning.

1. Add a section headed exactly `## Dictionary`. Put one table in it: `| Word (part of speech) | Status | Meaning or alternative |`.
2. Write an approved word in UPPERCASE. Write a not-approved word in lowercase.
3. Set the status to exactly `approved` or `not approved`.

Example rows: `| SAVE (v) | approved | Add an item to Saved |` and `| bookmark (v) | not approved | SAVE |`.

## Markup contract

1. Declare the register in `<head>`: `<meta name="studio:register" content="procedure|verdict|exploratory">`.
2. Override the register for one subtree with `data-register="…"` on its element.
3. Mark a subtree `data-ste="off"` to skip it. Use it for quoted drafts under critique, rule-break examples, and third-party text.
4. Mark shipping product copy `data-ste="copy"`. The checker applies the dictionary check only.
5. Give the `.orig` class (a quoted draft with red rule breaks) `data-ste="off"`.

The checker always skips `<script>`, `<style>`, `<svg>`, `<pre>`, `<code>`, and `<head>` content. It also skips bracketed placeholders `[…]`.

## The checker

`evals/ste-check.sh [--vocab <design-vocabulary.md>] <file.html>...` exits 0 with no FAIL, 1 with a FAIL, and 2 for a bad call. `artifacts/kit/README.md` holds the step skills run after they write an artifact.

**FAIL** (lint R13 enforces it)
- The `studio:register` meta is missing or invalid.
- A sentence is over the limit in `procedure` (20) or `verdict` (25).

**WARN** (listed in the summary)
- A sentence is over 25 words in `exploratory`.
- A hedge or interjection occurs in `procedure` or `verdict`: oops, sorry, unfortunately, hopefully, perhaps, maybe, "it looks like", "seems to", "kind of", "sort of".
- An -ing word occurs in `procedure`. It is not an allowlisted noun or adjective, and not an approved dictionary word.
- A not-approved dictionary word occurs in any text, `copy` included. The WARN names the alternative.

## Before and after

| Register | Before | After |
|---|---|---|
| `procedure` | Oops! It looks like you haven't saved anything yet. | Nothing saved yet. |
| `verdict` | Perhaps this could ship, but it seems to have a few small issues. | No-ship. Two defects block release: contrast fails and the label truncates. |
| `exploratory` | Maria opens the app on the train, sees an empty list, and wonders whether her saved items from yesterday, which she remembers adding twice, have disappeared. | Maria opens the app on the train and sees an empty list. She wonders whether yesterday's saved items have disappeared. |

The `procedure` after-string is shipping copy when it appears in the product. Mark it `data-ste="copy"`.
