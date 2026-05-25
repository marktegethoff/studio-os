# Facilitator Guide

Run-of-show for the Studio OS design workshop.

---

## Before the session

- [ ] Fill in the challenge brief in `CLAUDE.md`
- [ ] Test the full flow yourself: install → start Claude Code → upload a sketch → get a prototype
- [ ] Confirm CDN-free output works in the sandboxed environment (run the prototype in a browser with no internet)
- [ ] Send the kit folder to all participants at least 24 hours before
- [ ] Confirm all participants have Claude Code installed
- [ ] Book a video call with screen-share enabled for the gallery walk

---

## Session structure (90 minutes)

### 0:00–0:15 — Install and orient

Participants install the kit and verify agents are active.

What to say:
> "We're going to start by installing three agents — think of them as specialized collaborators with specific disciplines. This takes about 5 minutes. Follow the README."

Facilitate troubleshooting live. Common issues: wrong directory, install script permissions, agents not showing up. All are fixable in under 2 minutes.

End state: everyone has run `claude` from the workshop folder and verified agents are active.

---

### 0:15–0:20 — Brief the challenge

Reveal the design challenge. It's already in `CLAUDE.md` — Claude knows it — but read it aloud.

What to say:
> "Here's the challenge you're all working on: [read the challenge brief]. Everyone has the same starting point. What you build will be completely different — because your sketches will be different. That divergence is the point of today."

One constraint to set:
> "Your first prototype is one screen. Not a flow. Not an app. One screen that addresses the challenge."

---

### 0:20–0:45 — First sketch and prototype

Participants sketch on paper (5–10 minutes) then build their first prototype.

What to say before they start:
> "Rough is fine. Boxes and arrows are fine. Claude is reading the sketch as a design intent, not a finished spec. The worse the sketch, the more interesting the interpretation sometimes."

When they have their first prototype:
> "Open it in your browser. Does it feel like what you drew? If not — don't type corrections. Sketch the correction. The loop is: draw, photograph, build, draw again."

---

### 0:45–1:05 — Iterate

Give participants two full iteration cycles: sketch → prototype → sketch → prototype.

What to say:
> "Push it. Add a second state. What happens when the user takes the action? What does success look like? Sketch that and feed it in."

Circulate (or check in on video) to see what's emerging. Note divergence you're seeing — you'll use this in the gallery walk.

---

### 1:05–1:15 — Use a discipline agent

Ask everyone to invoke one agent on their prototype before the gallery walk.

What to say:
> "Before we share — pick one agent. @workshop-critic to cut what doesn't belong. @workshop-writer to fix your copy. @workshop-designer to pressure-test your interaction model. Spend 5 minutes. Make one change based on what it tells you."

This demonstrates that the agents aren't just generators — they're critics. The distinction between "build this" and "evaluate this" is the point.

---

### 1:15–1:30 — Virtual gallery walk

Each participant screen-shares their prototype. 2 minutes each. No commentary on quality.

What to say before it starts:
> "We're going to see five different responses to the same problem. The goal is not to find the best one — the goal is to see how differently each of you interpreted the challenge. The AI amplified your thinking, it didn't replace it. Different sketches in, different prototypes out."

After all have shared:
> "What did you notice? Where did the sketches lead to different places? Where did they converge?"

---

## What the session proves

At the end, participants have experienced:
1. Visual input (sketch) → functional output (prototype) — breaks the "AI as chatbot" model
2. Iteration through drawing — shows this is a workflow, not a one-shot trick
3. Discipline agents as critics — shows AI can evaluate, not just generate
4. Divergence from a shared brief — shows AI amplifies individual thinking, doesn't homogenize it

---

## If something breaks

**Image input doesn't work:** Fall back to text-based sketch description. Ask participants to describe their sketch in a sentence ("a single screen with a large card at the top showing the transaction amount, two action buttons below, and a secondary link for 'this is fine'"). Still produces a prototype. Different workshop, still valuable.

**A prototype renders blank or broken:** Ask Claude Code to "rebuild prototype.html with simpler HTML, avoiding any browser compatibility issues." Usually resolves it.

**An agent isn't responding as expected:** Ask the participant to invoke it more explicitly: "@workshop-critic — evaluate each element of my current design and tell me what to remove."

**Time is running short:** Cut the agent exercise (1:05–1:15) and go directly to gallery walk. The sketch → prototype loop is the primary experience.
