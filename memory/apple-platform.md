# Apple Platform Contract

**As of iOS 26 · last swept: 2026-08-17 · refreshed by `surveyor`** — this file is the *current* layer, the deliberate complement to the timeless `design-foundations.md`. Foundations change when they are wrong; this file changes when the platform does. The surveyor's Apple beat owns the date above: each sweep either updates this file or confirms it, and drift between this file and the shipping platform is a surveyor finding.

Design agents cite sections of this contract by name, the way they cite `anti-patterns.md` entries. API-bridging vocabulary appears only here and in `agents/swift-engineer.md` — design agents speak the platform's design language, the specialist speaks its code.

---

## 1. Platform first

**Every platform-facing discipline starts from full fluency in the platform's current language — then develops the tenant application's language within it.** The platform is not a constraint to route around; it is the material. Users arrive carrying the entire ecosystem's conventions, and every departure spends their trust.

- First move on any surface: name the platform and its current system (navigation, materials, motion, type) before proposing anything.
- The tenant's language is derived *inside* the platform's: it may extend, tune, or deliberately depart — but a departure is a **named decision with a reason**, recorded where the decision lives. A departure by omission is a defect.
- This pattern generalizes: `web-platform.md`, `android-platform.md` follow the same shape when those practices are installed. This file covers Apple platforms; iOS is primary, with macOS/watchOS/visionOS differences noted only where they change a decision.

---

## 2. Navigation contract

Navigation is semantics, not layout. The container announces what kind of thing the user is looking at:

- **A push is a place.** Drill-in, hierarchical, part of where-you-are. The back edge always returns. Pushes carry context forward; they never present a task.
- **A sheet is a task.** Scoped, completable, dismissible. When the task is done or abandoned, the sheet leaves and the place remains. A sheet that navigates deeply inside itself is usually a place wrongly framed as a task.
- **Detents are task weight.** Medium detent (~half height): a glanceable or single-input task with the context still visible behind it. Large detent: a focused task that earns the full surface. Resizable detents are a promise the task has two working sizes — don't offer them decoratively.
- **A tab is a mode.** Tabs partition the app's few coequal contexts. Tabs never disappear, never rearrange by state, and tapping the active tab returns to its root. More than five modes means the model is wrong, not the tab bar.
- **A sidebar is a library** (iPad/Mac): breadth-first collections the user names and owns.
- **Full-screen covers are commitments** — reserved for flows that must not be casually dismissed (capture in progress, payment). Rare by definition.
- **Deep links land as state, not as replay.** Arriving from a link, widget, or intent must reconstruct the place (correct stack, correct tab) — never a stranded modal over the wrong context.
- **Alerts interrupt; they do not converse.** One question, destructive option marked, cancel always honest. Anything richer is a sheet.

## 3. Reserved gestures

The system owns a gesture vocabulary; an app never repurposes it:

- **Edge-swipe from left = back.** Never attach anything else to that edge.
- **Swipe-down on a sheet = dismiss.** Blocking it is a named decision reserved for unsaved work — and pair it with a visible affordance.
- **Long-press = context menu / preview.** Not a hidden primary action.
- **Swipe on a list row = row actions**, leading and trailing, with the destructive action farthest from the content.
- **Pull-down past top = refresh** (content that can be newer) or search reveal — one, not both improvised.
- Custom gestures are additive, discoverable from the resting interface, and never the *only* path to an action (`designer`'s invisible-affordance ban applies).

## 4. Materials

The platform's material system as of iOS 26 is **layered glass**: translucent surfaces (bars, sheets, sidebars, controls) that blur and refract what lies beneath, with vibrancy keeping content legible on top and specular depth signaling interactivity. The material hierarchy — from ultra-thin to opaque — encodes *how much a surface belongs to the content beneath it*.

- **Material implies behavior.** On this platform, glass says "system chrome, floating above your content"; opaque says "this is the content." A control rendered in content material reads as inert; content rendered in chrome material reads as furniture.
- **Vibrancy is the legibility contract**: text and symbols on translucent material use vibrant styles, never raw colors — that's what keeps them readable over anything.
- **Depth is earned by function** — a layer floats because it can be dismissed or acts on the layer below, not for drama.
- **Tenant material language** (per §1): an app may run a flatter, more opaque, more tonal language than the platform default — several of the studio's Positive references do — but it is developed *from* the platform system: it must state which platform layers it keeps (system bars? sheets?), where the boundary sits, and why. "No shadows, tonal separation" is a legitimate tenant language; it is never a reason to be ignorant of what the platform's sheets and bars are doing around it.
- Dark mode is a **material shift, not an inversion**: surfaces get nearer black, elevation reads as *lighter* overlay, and any warm/cool delta is retuned — a palette flip that ignores material reads broken in dark.

## 5. Motion

The platform animates with **springs — physics, not curves**. A spring is specified by *response* (how fast it settles: the deliberateness of the change) and *damping* (how much it overshoots: the personality). Duration is an outcome, not an input.

The working ladder:

| Intent | Response | Damping | Reads as |
|---|---|---|---|
| Immediate feedback (toggle, selection) | ~0.3 | ~0.8–0.9 | quick, certain |
| Considered change (expand, reorder, commit) | ~0.5–0.6 | ~0.8 | deliberate, calm |
| Weighty transition (full surface, modal) | ~0.8–1.0 | ~0.85–0.9 | consequential |

System presets carry the same semantics: *snappy* = feedback, *smooth* = considered (no bounce), *bouncy* = playful (earned rarely). Prefer presets; reach for explicit values when the tenant motion language tunes them.

- **Spatial vs non-spatial.** Motion that moves things *between places* (push, sheet, expansion) teaches the app's geography — it must be spatially truthful (a thing returns the way it came). Motion that changes *state in place* (opacity, selection) is non-spatial and should be shorter and quieter. Never spend spatial motion on a non-spatial change.
- **Interruptibility is non-negotiable**: springs retarget mid-flight; a user action during an animation redirects it, never queues behind it.
- **Reduce Motion is a designed variant, not an off-switch**: replace spatial movement with cross-fades; keep the state change legible. Ship both variants specified.
- Frame budget is real: 8ms on ProMotion. Motion that can't hold its frame rate is worse than no motion (see `swift-engineer` for the instrumentation).

## 6. Haptics & sound

Feedback can be felt — the studio's Tapbots reference, made operational. Haptics confirm **mechanism**, not decoration:

- **Vocabulary**: selection ticks (discrete steps through options: pickers, steppers); impact — light / medium / heavy / soft / rigid (a collision or commit whose weight matches the visual weight of what moved); notification — success / warning / error (an outcome the user awaited).
- **A haptic is earned when** the interaction has a *mechanism* — something latched, crossed a threshold, committed, or completed. Scrolling, appearing, and animating are not mechanisms. If everything vibrates, nothing does.
- **Weight pairing**: haptic weight matches motion weight — a light spring gets a light impact; a heavy commit (send, delete, capture) may earn medium; heavy impact is nearly always too much. The choreographer owns this pairing in the motion spec.
- **Sound is the same discipline at higher stakes**: a sound is earned by completed mechanism (sent, captured, saved) and must survive being heard 100×/day. Default silent; respect the ring switch; never duplicate what the haptic already said.

## 7. Type

The platform face is **SF Pro** — with optical sizing (Display above ~20pt, Text below) handled by the system when you use it as the system.

- **Text styles are roles, not sizes**: largeTitle 34 · title 28 · title2 22 · title3 20 · headline 17 semibold · body 17 · callout 16 · subheadline 15 · footnote 13 · caption 12 · caption2 11 (pt, at default size). Specify surfaces in roles; the typesetter maps roles to the tenant scale.
- **Never fight Dynamic Type.** Every layout is designed to survive the AX sizes (body reaches ~53pt at AX5): text wraps rather than truncates, containers grow, HStacks that break become VStacks by design, glyph-and-text pairs scale together. "It breaks at large sizes" is a failed layout, not an edge case.
- A custom face is a tenant decision that buys identity at the cost of optical sizing, Dynamic Type tuning, and system rhythm — pay it knowingly, and keep body/reading surfaces on the system face unless reading *is* the product.
- Monospaced digits for anything that counts or ticks.

## 8. Color

- **Semantic first**: primary/secondary/tertiary for content hierarchy, system background stacks for elevation, one tint as the app's accent verb. Semantic colors buy correct dark mode, vibrancy, and increased-contrast support for free — a raw hex buys none of it.
- **Dark mode is designed, not derived** (see §4): elevated surfaces lighten, saturated colors are retuned slightly toward pastel to hold contrast on near-black, and pure white text is avoided.
- **Displays are P3**: brand colors are authored wide-gamut with sRGB fallback; contrast floors (per `design-foundations.md`: WCAG AA as the floor) are measured in the shipped rendering, both modes, with increased-contrast variants where the tenant palette runs low.

## 9. Icons

- **SF Symbols first.** They match SF Pro's weights and baselines, scale with Dynamic Type, and carry rendering modes (monochrome / hierarchical / palette / multicolor) — hierarchical is the studio default for depth without color noise.
- Symbol weight matches adjacent text weight; symbols align to text via the type baseline, not optical guessing.
- **A custom symbol is earned** only where the concept has no adequate symbol or the mark *is* the brand — and it is drawn on the symbol grid, exported with variable weights, and behaves like a symbol (Dynamic Type, rendering modes). A custom icon set that ignores the grid reads foreign on the platform (the plugin's `memory/design-system.md`'s icon rules govern the tenant set).

## 10. Platform surfaces

The constructive counterpart to the marketer's **Platform Theater** ban: a platform surface is *earned by shape*, never by ambition.

- **A widget is earned by glanceable state** — a value that changes and matters between app opens (next event, streak, balance). A widget that is only a launcher is theater. Widgets are read-only-ish: one glance, at most one tap-through per element, designed in all sizes with real data.
- **A Live Activity is earned by a live process with an end** — delivery, timer, workout, score. It must terminate; a Live Activity that never ends is a notification abuse. Its Dynamic Island states (compact/minimal/expanded) are designed, not defaulted.
- **An App Intent is earned by a verb the system can speak** — an action complete in one sentence with typed parameters (log X, start Y, mark Z done). Intents make the app composable (Shortcuts, Siri, Spotlight, Action Button); expose the verbs users actually repeat, not the whole menu.
- **Watch/CarPlay/visionOS presence** follows the same test: name the moment where the surface beats pulling out the phone, or don't ship it. The marketer's ban still governs the *decision*; this section governs the *execution* once earned.

## 11. Arrival

The last mile — the App Store to the first successful minute — is design surface, not marketing residue:

- **Value before demand.** The first run reaches the product's core value before asking for anything — account, permissions, payment, notifications. Every screen between install and first value must justify itself; the empty state is the onboarding surface (`design-foundations.md` already holds this).
- **Permissions are asked in context, after intent.** The user taps the camera feature, *then* the camera prompt appears — primed by one line of the app's own copy stating the benefit. A launch-time permission barrage is the fastest way to a permanent no. Never ask for notifications before the app has done anything worth notifying about.
- **Paywall craft**: charge the daily case honestly (the palette's Apple Notes / Loom lesson) — the paywall states what is free forever, what trial ends when, and price-per-period without dark patterns; restore purchases is visible; the close button is real. A paywall that performs scarcity erodes the same trust the rest of the studio's work builds.
- **Review-readiness basics**: App Store screenshots show the product doing its parti (first screenshot = the one-sentence idea, visible); metadata copy is the writer's surface, in product voice; the app works logged-out enough for review; permission strings explain *why* in the product's own words.

---

## API bridge (for `swift-engineer` and specs)

Design specs written against this contract land in Swift as follows — this section exists so a spec's vocabulary has one named mapping, and it is the only place outside `swift-engineer.md` where API names appear:

- Motion ladder → `.spring(response:dampingFraction:)`; presets → `.snappy` / `.smooth` / `.bouncy`; state-driven via `withAnimation` / `.animation(_:value:)`; Reduce Motion via the environment's `accessibilityReduceMotion`, shipping the cross-fade variant.
- Haptics → `.sensoryFeedback(_:trigger:)` (selection, `.impact(weight:)`, `.success/.warning/.error`).
- Materials → `Material` tiers (`.ultraThinMaterial` … `.thickMaterial`), vibrant foreground styles; glass effects per the current SDK.
- Type roles → `Font.TextStyle`; monospaced digits → `.monospacedDigit()`.
- Semantic color → `.foregroundStyle(.primary/.secondary/.tertiary)`, background stacks, `.tint`.
- Navigation semantics → `NavigationStack` (places), `.sheet` + `presentationDetents` (tasks), `TabView` (modes), `.fullScreenCover` (commitments).
- Surfaces → WidgetKit, ActivityKit, App Intents.

Canonical worked solutions — compilable snippets with provenance — live in `patterns/swift/` (start at `INDEX.md`). Specs cite patterns; engineers start from them.
