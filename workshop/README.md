# Workshop Kit: Sketch to Prototype

Draw an idea. Take a photo. Walk away with something you can click.

This kit is for anyone who designs — researchers, strategists, UX designers, visual designers, service designers, design systems practitioners, and everyone in between. You don't need to know how to code. You don't need to be comfortable in the terminal. You just need an idea and something to draw on.

---

## What's in this kit

```
workshop/
  CLAUDE.md           — Workshop instructions (Claude reads this automatically)
  install.sh          — One-time setup script
  README.md           — This file
  FACILITATOR.md      — Run-of-show guide for workshop hosts
  agents/
    workshop-critic.md    — Tells you exactly what to cut
    workshop-designer.md  — Works out how something should behave before you build it
    workshop-xd-writer.md    — Evaluates and sharpens words in your design
    workshop-visual.md    — Improves visual hierarchy, spacing, and weight
```

---

## Before the workshop (facilitator)

1. **Fill in the challenge brief** in `CLAUDE.md` — replace the `[CHALLENGE BRIEF HERE]` placeholder with the actual design problem.

2. **Send the kit folder** to each participant (via shared drive or email).

3. **Confirm Claude Code is installed** on every participant's machine.

---

## Step 1 — Set up (do this at the start of the session)

Open Terminal and run these two commands. The first makes the setup script runnable. The second runs it.

```bash
chmod +x install.sh
./install.sh
```

This copies the workshop collaborators to the place Claude Code looks for them. It takes about 10 seconds.

**If you'd prefer to do this manually (Windows or if the script doesn't run):**
```bash
mkdir -p "$HOME/.claude/agents"
cp agents/*.md "$HOME/.claude/agents/"
```

---

## Step 2 — Start Claude Code

Open Terminal, navigate to the workshop folder, and start Claude Code:

```bash
cd path/to/workshop-kit
claude
```

Claude Code must be started from inside the workshop folder. That's how it finds the workshop instructions.

---

## Step 3 — Answer six quick questions

The first time you start, Claude will ask you six questions before the workshop begins. This takes about four minutes, and it's how Claude learns to work with you specifically.

The questions:
1. What's your name, and what's your role or team at Capital One?
2. What kind of design work fills most of your time right now?
3. What's the part of design work you genuinely enjoy — the thing you could lose yourself in?
4. What's the part of the process that always takes longer than it should?
5. Is there a part of the process where you usually wish you had someone to think alongside?
6. Are you comfortable in Terminal, or do you prefer step-by-step guidance?

Answer honestly — Claude uses this to adapt throughout the day. A researcher gets different support than a visual designer. Someone new to Terminal gets different instructions than someone comfortable there.

After you answer, Claude will introduce the challenge and you're ready to go.

---

## Step 4 — Take your first sketch

Draw your idea on paper. It doesn't need to be good — it needs to exist. Boxes and arrows work. So do scribbles.

Take a photo with your phone or scan it. Get the image onto your computer.

---

## Step 5 — Build your first prototype

Drag your photo into the Claude Code window (or type the file path).

Then say what you drew:
> "This is a sketch of [what you're designing]. Here's the idea: [one sentence]."

Claude will:
1. Describe what it sees and confirm the interpretation
2. Build a `prototype.html` file in your workshop folder
3. Tell you how to open it in your browser

Open `prototype.html`. That's your first prototype.

---

## Step 6 — Iterate

Don't type corrections — sketch them.

Draw what you want to change. Take another photo. Feed it back in.

The loop: **draw → photo → prototype → draw again**

---

## Your collaborators

Four specialists are available during the workshop. Invoke them by name when you want a different perspective.

| Collaborator | Invoke with | Reach for it when |
|---|---|---|
| @workshop-designer | "designer" | You're not sure how something should behave |
| @workshop-critic | "critic" | Something feels like too much |
| @workshop-xd-writer | "xd-writer" | The words in your design need work |
| @workshop-visual | "visual" | The layout feels flat or unbalanced |

**Example:**
> "I have three buttons on this screen. @workshop-critic — what should be removed?"

---

## Troubleshooting

**"Claude doesn't know the workshop challenge"**
You're not running Claude Code from the workshop folder. Navigate there first:
```bash
cd path/to/workshop-kit
claude
```

**"The prototype looks wrong in the browser"**
Try a different browser. If things are missing, ask Claude Code to rebuild with simpler HTML.

**"I can't drag an image into Claude Code"**
Use the desktop app — it supports image drag-and-drop. Or give the file path directly:
> "The sketch is at /path/to/my-sketch.jpg — treat it as my design."

**"The collaborators aren't showing up"**
Run the setup script again. Make sure you're running it from the workshop folder.

---

## At the end of the session

Everyone will have a `prototype.html` in their workshop folder.

The facilitator will ask each person to share their screen for two minutes. No commentary on quality — the point is to see how differently each person interpreted the same challenge. Same brief, different sketches, different prototypes. That divergence is the result.
