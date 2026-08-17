# navigation-stack-path

Problem:    Navigation as state — one path owner, deep links as state restoration.
Standard:   `memory/apple-platform.md` §2 (deep links land as state, not replay) · swift-engineer § Platform doctrine (Navigation)
Verified:   2026-08 · iOS 26

## Solution

```swift
@Observable
final class Router {
    var path: [Destination] = []

    enum Destination: Hashable {
        case collection(Collection.ID)
        case item(Item.ID)
    }

    // A deep link constructs destination state — it does not replay taps.
    func open(_ url: URL) {
        guard let item = Item.ID(url) else { return }
        path = [.collection(item.collection), .item(item)]   // full, correct stack
    }
}

struct RootView: View {
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            LibraryView()
                .navigationDestination(for: Router.Destination.self) { dest in
                    switch dest {
                    case .collection(let id): CollectionView(id: id)
                    case .item(let id):       ItemView(id: id)
                    }
                }
        }
        .environment(router)
        .onOpenURL { router.open($0) }
    }
}
```

## Why this shape

One model owns the path; views *ask* to navigate (`router.path.append(...)`) instead of embedding destinations, so navigation is testable, restorable, and deep-linkable by construction. `open(_:)` assigning the whole path is what makes a link from a widget or intent land as a real place with a working back stack — never a stranded modal over the wrong context (§2).

## Prevents

Navigation state scattered across `NavigationLink(isActive:)` booleans, un-restorable stacks, and deep links that replay UI instead of constructing state.
