# liquid-glass-chrome

Problem:    Adopting the platform's Liquid Glass material — what gets glass, how, and what never does.
Standard:   `memory/apple-platform.md` §4 (Materials) · HIG Materials · WWDC25 Liquid Glass sessions
Verified:   2026-08 · iOS 26

## Solution

```swift
// 1. Standard chrome gets Liquid Glass for free. Ship system components and do nothing:
NavigationStack {
    ContentList()
        .navigationTitle("Library")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add", systemImage: "plus") { add() }
            }
        }
}
// Toolbars, tab bars, and sheets built from standard components render the
// current material automatically — including glass — with no adoption code.

// 2. Custom floating chrome earns glass explicitly, grouped in one container
//    so adjacent glass shapes blend and morph together:
GlassEffectContainer {
    HStack(spacing: 12) {
        Button("Capture", systemImage: "circle.fill", action: capture)
        Button("Flip", systemImage: "arrow.triangle.2.circlepath", action: flip)
    }
    .buttonStyle(.glass)
    .glassEffect(in: .capsule)
}
.padding()

// 3. Content on glass uses vibrant/semantic styles — never raw colors:
Label("Now Playing", systemImage: "waveform")
    .foregroundStyle(.secondary)   // vibrancy handled by the material
```

## Why this shape

The platform applies Liquid Glass to its own chrome; adoption is mostly *not fighting it* — standard bars and sheets get the material, its scroll-edge behavior, and its accessibility fallbacks (reduced transparency, increased contrast) for free. Explicit `glassEffect` is only for custom controls that float *above* content, and grouping them in one `GlassEffectContainer` is what makes neighboring shapes read as one material instead of stacked scrims. Content never gets glass: glass says "chrome, above your content" — a content card in glass reads as furniture (contract §4).

## Prevents

Hand-rolled blur stacks (`.ultraThinMaterial` + shadow + border) imitating glass on chrome the system would have rendered correctly — and glass applied to content surfaces.
