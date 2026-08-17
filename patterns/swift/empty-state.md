# empty-state

Problem:    The zero-state that teaches the first action, on the system component.
Standard:   `memory/design-foundations.md` (Empty State Neglect is a named anti-pattern) · `memory/apple-platform.md` §11 (the empty state is the onboarding surface)
Verified:   2026-08 · iOS 26

## Solution

```swift
struct LibraryList: View {
    @Environment(LibraryModel.self) private var model

    var body: some View {
        Group {
            if model.items.isEmpty {
                ContentUnavailableView {
                    Label("No entries yet", systemImage: "text.alignleft")
                } description: {
                    Text("Everything you capture lands here, newest first.")
                } actions: {
                    Button("Add your first entry") { model.startCompose() }
                        .buttonStyle(.borderedProminent)
                }
            } else {
                List(model.visible) { ItemRow(item: $0) }
            }
        }
    }
}
// Search variant: ContentUnavailableView.search(text: query) — the system phrasing, free.
```

## Why this shape

`ContentUnavailableView` is the platform's empty-state idiom: correct type roles, spacing, Dynamic Type, and dark mode with zero custom layout — and its `actions` slot is what turns the zero state into the onboarding surface (the one moment with the user's full attention, per the anti-pattern's correction). The description says what *will* be here, in product voice, no apology; the action starts the first meaningful task directly.

## Prevents

Empty State Neglect (a blank list at first run), hand-built empty-state stacks re-deriving what the system component provides, and zero states that describe absence instead of teaching the first action.
