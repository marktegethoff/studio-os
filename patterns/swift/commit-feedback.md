# commit-feedback

Problem:    The commit micro-interaction — spring + haptic pairing + reduce-motion variant, as one designed unit.
Standard:   `memory/apple-platform.md` §5–6 (motion ladder; haptics earned by mechanism, weight-paired) · choreographer output format
Verified:   2026-08 · iOS 26

## Solution

```swift
struct ComposeBar: View {
    @Binding var draft: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let onCommit: () -> Void
    @State private var committed = false

    var body: some View {
        HStack(spacing: 12) {
            TextField("Add an entry…", text: $draft)
                .onSubmit(commit)
            if !draft.isEmpty {
                Button(action: commit) {
                    Image(systemName: "arrow.up.circle.fill").font(.title2)
                }
                .accessibilityLabel("Add entry")
                .transition(reduceMotion
                    ? .opacity                                       // designed reduced variant
                    : .scale.combined(with: .opacity))
            }
        }
        // Non-spatial state change: quick, certain (feedback tier of the ladder)
        .animation(reduceMotion ? nil : .snappy, value: draft.isEmpty)
        // Haptic on the MECHANISM (the commit), weight-matched to the motion:
        .sensoryFeedback(.impact(weight: .light), trigger: committed)
    }

    private func commit() {
        guard !draft.isEmpty else { return }
        withAnimation(reduceMotion ? nil : .spring(response: 0.4, dampingFraction: 0.8)) {
            onCommit()          // the entry travels to its place — spatial, considered tier
            draft = ""
        }
        committed.toggle()      // trigger fires per commit
    }
}
```

## Why this shape

One interaction, both tiers of the ladder used correctly: the button's appearance is non-spatial (`.snappy`, quiet), the committed entry's travel is spatial (considered spring). The haptic fires on the *mechanism* — the commit — never on appearance, and its weight matches the motion's (light impact for a light spring, §6). Reduce Motion is a designed variant shipped in the same view: cross-fade transitions, no travel, haptic retained (it isn't motion).

## Prevents

Haptics on appearance/scroll, heavy impact on light interactions, spatial motion spent on a button fade, and Reduce Motion handled as "animations off" instead of a designed variant.
