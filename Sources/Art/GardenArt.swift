import SwiftUI

// Garden-of-Eden art: growing stages (soil → sprout → sapling → TreeArt),
// gardening tools, the generic fruit (deliberately NOT an apple), the basket,
// and the serpent. 120x120 canvas, storybook style.

struct SoilArt: View {
    private let dirt = Color(red: 0.55, green: 0.40, blue: 0.26)
    private let dirtDark = Color(red: 0.45, green: 0.32, blue: 0.20)

    var body: some View {
        ArtCanvas {
            Ellipse()
                .fill(dirt)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 84, height: 40)
                .offset(y: 30)
            Ellipse().fill(dirtDark).frame(width: 60, height: 22).offset(y: 26)
            // little stones
            Circle().fill(dirtDark).frame(width: 8).offset(x: -28, y: 38)
            Circle().fill(dirtDark).frame(width: 6).offset(x: 26, y: 40)
        }
    }
}

struct SeedArt: View {
    private let shell = Color(red: 0.78, green: 0.58, blue: 0.34)

    var body: some View {
        ArtCanvas {
            Ellipse()
                .fill(shell)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.35), lineWidth: 3))
                .frame(width: 44, height: 58)
                .rotationEffect(.degrees(-14))
            // highlight
            Ellipse().fill(Color.white.opacity(0.4)).frame(width: 12, height: 20)
                .rotationEffect(.degrees(-14)).offset(x: -8, y: -10)
            // tiny hopeful leaf on top
            Ellipse().fill(Theme.leaf).frame(width: 16, height: 9)
                .rotationEffect(.degrees(-40)).offset(x: 10, y: -32)
        }
    }
}

struct SproutArt: View {
    private let dirt = Color(red: 0.55, green: 0.40, blue: 0.26)

    var body: some View {
        ArtCanvas {
            Ellipse()
                .fill(dirt)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 80, height: 36)
                .offset(y: 34)
            // stem
            Capsule().fill(Theme.leaf).frame(width: 7, height: 40).offset(y: 6)
            // two baby leaves
            Ellipse().fill(Theme.leaf).frame(width: 26, height: 14)
                .rotationEffect(.degrees(-34)).offset(x: -14, y: -12)
            Ellipse().fill(Theme.leaf).frame(width: 26, height: 14)
                .rotationEffect(.degrees(34)).offset(x: 14, y: -12)
        }
    }
}

struct SaplingArt: View {
    private let dirt = Color(red: 0.55, green: 0.40, blue: 0.26)
    private let trunk = Color(red: 0.62, green: 0.44, blue: 0.28)

    var body: some View {
        ArtCanvas {
            Ellipse()
                .fill(dirt)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 80, height: 34)
                .offset(y: 38)
            // young trunk
            Capsule().fill(trunk).frame(width: 10, height: 52).offset(y: 8)
            // leafy top
            Circle().fill(Theme.leaf).frame(width: 34).offset(x: -14, y: -22)
            Circle().fill(Theme.leaf).frame(width: 34).offset(x: 14, y: -22)
            Circle().fill(Theme.leaf).frame(width: 38).offset(y: -34)
        }
    }
}

struct WateringCanArt: View {
    private let tin = Theme.sky
    private let tinDark = Color(red: 0.26, green: 0.52, blue: 0.76)

    var body: some View {
        ArtCanvas {
            // body
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tin)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 54, height: 46)
                .offset(x: -4, y: 8)
            // spout
            Capsule().fill(tin)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 44, height: 13)
                .rotationEffect(.degrees(-32))
                .offset(x: 32, y: -6)
            // spout head + drops
            Circle().fill(tinDark).frame(width: 16).offset(x: 48, y: -20)
            Capsule().fill(tin).frame(width: 4, height: 10).rotationEffect(.degrees(18)).offset(x: 52, y: -2)
            Capsule().fill(tin).frame(width: 4, height: 10).rotationEffect(.degrees(18)).offset(x: 58, y: 8)
            // handle
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(tinDark, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .frame(width: 34)
                .offset(x: -4, y: -16)
        }
    }
}

/// A generic golden fruit — intentionally not an apple: elongated pear-round
/// shape, golden color, paired leaves.
struct FruitArt: View {
    private let gold = Color(red: 0.98, green: 0.78, blue: 0.30)
    private let goldDeep = Color(red: 0.92, green: 0.64, blue: 0.20)

    var body: some View {
        ArtCanvas {
            Ellipse()
                .fill(LinearGradient(colors: [gold, goldDeep], startPoint: .top, endPoint: .bottom))
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 52, height: 64)
                .offset(y: 8)
            // shine
            Ellipse().fill(Color.white.opacity(0.45)).frame(width: 14, height: 22)
                .rotationEffect(.degrees(-16)).offset(x: -12, y: -4)
            // stem + two leaves
            Capsule().fill(Theme.woodDeep).frame(width: 6, height: 16).offset(y: -28)
            Ellipse().fill(Theme.leaf).frame(width: 22, height: 12)
                .rotationEffect(.degrees(-36)).offset(x: -12, y: -32)
            Ellipse().fill(Theme.leaf).frame(width: 18, height: 10)
                .rotationEffect(.degrees(30)).offset(x: 10, y: -30)
        }
    }
}

struct BasketArt: View {
    private let weave = Color(red: 0.80, green: 0.60, blue: 0.34)
    private let weaveDark = Color(red: 0.66, green: 0.47, blue: 0.25)

    var body: some View {
        ArtCanvas {
            // handle
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(weaveDark, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 64)
                .offset(y: -6)
            // body (upside-down trapezoid feel via rounded rect + clip)
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(weave)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 86, height: 52)
                .offset(y: 22)
            // weave lines
            Capsule().fill(weaveDark.opacity(0.7)).frame(width: 78, height: 4).offset(y: 12)
            Capsule().fill(weaveDark.opacity(0.7)).frame(width: 72, height: 4).offset(y: 26)
            Capsule().fill(weaveDark.opacity(0.7)).frame(width: 64, height: 4).offset(y: 40)
            // rim
            Capsule().fill(weaveDark)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 92, height: 14)
                .offset(y: -2)
        }
    }
}

/// The serpent — clearly a snake, stylized and calm, never gory or frightening.
struct SerpentArt: View {
    private let scale = Color(red: 0.45, green: 0.62, blue: 0.30)
    private let scaleDark = Color(red: 0.36, green: 0.51, blue: 0.24)
    private let belly = Color(red: 0.78, green: 0.85, blue: 0.55)

    var body: some View {
        ArtCanvas {
            // coiled body: three stacked coils, narrowing upward
            Capsule().fill(scale)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 84, height: 26)
                .offset(y: 36)
            Capsule().fill(scaleDark)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 68, height: 24)
                .offset(y: 16)
            Capsule().fill(scale)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 50, height: 22)
                .offset(y: -2)
            // neck + head
            Capsule().fill(scale).frame(width: 16, height: 30)
                .rotationEffect(.degrees(-16)).offset(x: 20, y: -22)
            Ellipse()
                .fill(scale)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 34, height: 26)
                .offset(x: 28, y: -38)
            Ellipse().fill(belly).frame(width: 18, height: 10).offset(x: 24, y: -32)
            // narrow sly eyes (not cute — this is the deceiver)
            Capsule().fill(Theme.outline).frame(width: 8, height: 3.5)
                .rotationEffect(.degrees(-10)).offset(x: 24, y: -42)
            Capsule().fill(Theme.outline).frame(width: 8, height: 3.5)
                .rotationEffect(.degrees(10)).offset(x: 36, y: -42)
            // forked tongue
            Capsule().fill(Theme.coral).frame(width: 12, height: 3).offset(x: 48, y: -38)
            Capsule().fill(Theme.coral).frame(width: 6, height: 2.5)
                .rotationEffect(.degrees(28)).offset(x: 54, y: -41)
            Capsule().fill(Theme.coral).frame(width: 6, height: 2.5)
                .rotationEffect(.degrees(-28)).offset(x: 54, y: -35)
        }
    }
}
