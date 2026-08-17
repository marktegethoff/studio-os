# list-row-actions

Problem:    Row actions — swipe + context menu + rotor custom actions, destructive placement.
Standard:   `memory/apple-platform.md` §3 (reserved gestures) · accessibility § Verify (traits and actions)
Verified:   2026-08 · iOS 26

## Solution

```swift
List(model.visible) { item in
    ItemRow(item: item)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) { model.delete(item) } label: {
                Label("Delete", systemImage: "trash")
            }
            Button { model.archive(item) } label: {
                Label("Archive", systemImage: "archivebox")
            }
        }
        .swipeActions(edge: .leading) {
            Button { model.pin(item) } label: {
                Label("Pin", systemImage: "pin")
            }
            .tint(.orange)
        }
        // Long-press previews the same actions — a mirror, never the only path:
        .contextMenu {
            Button("Pin", systemImage: "pin") { model.pin(item) }
            Button("Archive", systemImage: "archivebox") { model.archive(item) }
            Divider()
            Button("Delete", systemImage: "trash", role: .destructive) { model.delete(item) }
        }
        // VoiceOver reaches every action from the rotor without gesture gymnastics:
        .accessibilityActions {
            Button("Pin") { model.pin(item) }
            Button("Archive") { model.archive(item) }
            Button("Delete") { model.delete(item) }
        }
}
```

## Why this shape

Swipe, context menu, and accessibility actions are the *same verbs* on three access paths — the platform's contract is that no action hides behind exactly one gesture (§3, designer's invisible-affordance ban). The destructive role gets system red, confirm-on-full-swipe behavior, and placement farthest from content. `accessibilityActions` is what makes a three-action row navigable in one rotor stop instead of forcing element-by-element traversal.

## Prevents

Long-press as the only path to an action, hand-tinted "destructive" buttons without the role, and swipe-only verbs invisible to VoiceOver and Voice Control.
