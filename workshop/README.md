# Studio OS Workshop Kit

A structured design workshop experience: hand-drawn sketches → functional HTML prototypes.

---

## What's in this kit

```
workshop/
  CLAUDE.md           — Workshop brief and instructions (Claude reads this automatically)
  install.sh          — One-time agent installation script
  README.md           — This file
  agents/
    workshop-critic.md    — Removes what doesn't belong
    workshop-designer.md  — Defines how things should work before building
    workshop-writer.md    — Evaluates and writes interface copy
```

---

## Before the workshop (facilitator)

1. **Fill in the challenge brief** in `CLAUDE.md` — replace the `[CHALLENGE BRIEF HERE]` placeholder with the actual design problem.

2. **Send the kit folder** to each participant (via shared drive, email, or whatever your team uses).

3. **Confirm Claude Code is installed** on every participant's machine.

---

## Step 1 — Install (participants do this at session start)

Open Terminal and run:

```bash
cd path/to/workshop-kit
chmod +x install.sh
./install.sh
```

This copies the three workshop agents to `~/.claude/agents/` where Claude Code can find them.

**On Windows (Git Bash or PowerShell):**
```bash
# Create the agents directory if it doesn't exist
mkdir -p "$HOME/.claude/agents"

# Copy the agent files
cp agents/*.md "$HOME/.claude/agents/"
```

---

## Step 2 — Start Claude Code

Open Terminal, navigate to the workshop folder, and start Claude Code:

```bash
cd path/to/workshop-kit
claude
```

**Important:** Claude Code must be started from inside the `workshop-kit` folder. This is how it finds the `CLAUDE.md` file with the workshop brief.

Verify everything is working — type this in Claude Code:
```
what agents do I have available?
```

You should see the three workshop agents listed.

---

## Step 3 — Take your first sketch

Draw your idea on paper. It can be rough — stick figures, boxes, arrows. The sketch is the input, not the output.

Take a photo with your phone or use a scanner app. Get it onto your computer.

---

## Step 4 — Build your first prototype

Drag the photo into the Claude Code window (or use `/upload`).

Then describe what you drew:
> "This is a sketch of [what you're designing]. Here's the idea: [one sentence]."

Claude Code will:
1. Describe what it sees in your sketch and confirm the interpretation
2. Build a `prototype.html` file in your workshop folder
3. Tell you to open it in your browser

Open `prototype.html` in your browser. That's your first prototype.

---

## Step 5 — Iterate

Don't type changes — sketch them.

Draw the next version, or draw additional screens. Take another photo.
Feed it back in with a note about what you want to change.

The loop: **draw → photo → prototype → draw again**

---

## The discipline agents

Three agents are available during the workshop. Invoke them by name.

| Agent | Invoke with | Use when |
|-------|-------------|----------|
| @workshop-designer | "designer" or "@workshop-designer" | You want to think through how something should work before sketching |
| @workshop-critic | "critic" or "@workshop-critic" | You want to cut what doesn't belong |
| @workshop-writer | "writer" or "@workshop-writer" | You need help with copy in your prototype |

**Example:**
> "I have three buttons on this screen. @workshop-critic — what should be removed?"

---

## Troubleshooting

**"Claude doesn't know the workshop challenge"**
You're not running Claude Code from the workshop-kit folder. Navigate there first:
```bash
cd path/to/workshop-kit
claude
```

**"The prototype doesn't look right in the browser"**
Try a different browser. If elements are missing, it may be a rendering issue — ask Claude Code to rebuild with simpler HTML.

**"I can't drag an image into Claude Code"**
Use the desktop app (not the terminal CLI) — it supports image drag-and-drop. Alternatively, reference the image by file path:
> "Please read the file at /path/to/my-sketch.jpg and treat it as my design sketch."

**"The agents aren't showing up"**
Run the install script again. Make sure you're running it from the workshop-kit folder.

---

## At the end of the session

Every participant will have a `prototype.html` in their workshop folder.

The facilitator will ask each person to screen-share their prototype for 2 minutes.
No commentary on quality. The point is to see how differently each person interpreted the same challenge.

Same brief. Different sketches. Different prototypes. That's the result.

---

## Customizing this kit

**To change the challenge:** Edit the `[CHALLENGE BRIEF HERE]` section in `CLAUDE.md`.

**To add an agent:** Drop any `.md` agent file into the `agents/` folder and re-run `install.sh`.

**To change the output format:** Edit the `HTML Output Rules` section in `CLAUDE.md`.
