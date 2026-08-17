# observable-model

Problem:    State wiring — the `@Observable` model, `@State` ownership, environment injection.
Standard:   swift-engineer § Platform doctrine (State) · WWDC Observation sessions
Verified:   2026-08 · iOS 26

## Solution

```swift
@Observable
final class LibraryModel {
    var items: [Item] = []
    var filter: Filter = .all

    var visible: [Item] { items.filter(filter.matches) }

    func load() async { items = await store.fetch() }
}

struct LibraryScreen: View {
    @State private var model = LibraryModel()      // the view that creates it, owns it

    var body: some View {
        LibraryList()
            .environment(model)                    // subtree shares it — no init-threading
            .task { await model.load() }
    }
}

struct LibraryList: View {
    @Environment(LibraryModel.self) private var model

    var body: some View {
        List(model.visible) { ItemRow(item: $0) }  // rebuilds only when `visible`'s inputs change
    }
}

struct ItemRow: View {
    let item: Item                                  // plain value in, no observation needed
    var body: some View { Text(item.title) }
}
```

## Why this shape

`@Observable` tracks per-property *access*: `LibraryList` re-renders when `items` or `filter` change, and nothing else — `ObservableObject` would invalidate every subscriber on any `@Published` change. Ownership is legible: `@State` where the model is created, `@Environment` for the shared subtree, plain values at the leaves. Every fact has one writer; if two views could write the same fact through different paths, the model is wrong — fix the model, not the wiring.

## Prevents

`ObservableObject`/`@Published` reached for by habit, whole-tree invalidation, shared objects threaded through four view inits, and state-soup views (six `@State` booleans standing in for one model).
