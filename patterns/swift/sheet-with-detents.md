# sheet-with-detents

Problem:    Presenting a task over a place — detent choice, dismissal rules, background interaction.
Standard:   `memory/apple-platform.md` §2 (a sheet is a task; detents are task weight) · HIG Sheets
Verified:   2026-08 · iOS 26

## Solution

```swift
struct LibraryView: View {
    @State private var newItem: DraftItem?

    var body: some View {
        ContentList()
            .sheet(item: $newItem) { draft in
                ComposeView(draft: draft)
                    .presentationDetents([.medium, .large])      // two working sizes, both designed
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.disabled) // focused task: the place waits
                    // Block swipe-dismiss ONLY for unsaved work, and pair it with a visible Cancel:
                    .interactiveDismissDisabled(draft.hasUnsavedChanges)
            }
    }
}
// Glanceable companion (e.g. filters over a map): .presentationDetents([.medium])
// + .presentationBackgroundInteraction(.enabled(upThrough: .medium))
```

## Why this shape

`item:`-driven presentation makes the sheet a function of state (dismiss = state cleared, no boolean drift). Offering `[.medium, .large]` is a promise both sizes work — offer one detent if only one is designed. Background interaction is the task/place boundary made explicit: disabled for focused tasks, enabled-up-through-medium only when the sheet is a companion to a live place. Blocking swipe-dismiss is the reserved-gesture exception (§3) — unsaved work only, never engagement.

## Prevents

A place trapped in a sheet (deep navigation inside a task container), boolean-state sheet drift, resizable detents offered decoratively, and blocked dismissal without an unsaved-work reason.
