# dynamic-type-layout

Problem:    Layouts that survive the AX sizes — axis-switching, scaled metrics, no clipped containers.
Standard:   `memory/apple-platform.md` §7 (never fight Dynamic Type) · typesetter § Platform Face
Verified:   2026-08 · iOS 26

## Solution

```swift
struct StatRow: View {
    let title: String
    let value: String
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .body) private var iconSize = 20   // glyph scales with its text

    var body: some View {
        // The row that breaks at AX sizes becomes a column — by design, not by accident:
        layout {
            Label {
                Text(title)
            } icon: {
                Image(systemName: "chart.bar")
                    .frame(width: iconSize, height: iconSize)
            }
            Spacer(minLength: 0)
            Text(value)
                .font(.body.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        // Never a fixed height; the container grows with the text.
    }

    private var layout: AnyLayout {
        typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(alignment: .firstTextBaseline))
    }
}
```

## Why this shape

Body text reaches ~53pt at AX5 — a horizontal row of title + value cannot survive that, so the break to vertical is *designed in* (`AnyLayout` switches axis without rebuilding structural identity, so state and animation survive). `@ScaledMetric` keeps the glyph proportionate to its text instead of stranding a 20pt icon beside 50pt type. Text wraps; nothing truncates; no `.frame(height:)` caps a text container. "It breaks at large sizes" is a failed layout, not an edge case (§7).

## Prevents

Fixed-height containers that clip at AX sizes, `.lineLimit(1)` as a layout strategy, fixed-size glyphs beside scaling text, and `.minimumScaleFactor` used to shrink text the layout should have made room for.
