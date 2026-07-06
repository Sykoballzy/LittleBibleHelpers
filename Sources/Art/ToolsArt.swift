import SwiftUI

// Build-the-Ark art: three tools and three ark build stages (planks → frame →
// hull → finished ArkArt). Same 120x120 canvas, thick friendly outlines.

struct SawArt: View {
    private let handle = Color(red: 0.72, green: 0.49, blue: 0.29)
    private let blade = Color(red: 0.80, green: 0.83, blue: 0.88)

    var body: some View {
        ArtCanvas {
            // blade
            SawBladeShape()
                .fill(blade)
                .overlay(SawBladeShape().stroke(Theme.outline.opacity(0.35), lineWidth: 2.5))
                .frame(width: 84, height: 34)
                .rotationEffect(.degrees(-12))
                .offset(x: 6, y: 6)
            // handle
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(handle)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.outline.opacity(0.35), lineWidth: 2.5))
                .frame(width: 30, height: 26)
                .rotationEffect(.degrees(-12))
                .offset(x: -44, y: -2)
        }
    }
}

struct SawBladeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let teeth = 7
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // toothed bottom edge
        let step = rect.width / CGFloat(teeth)
        for i in 0..<teeth {
            let x = rect.maxX - CGFloat(i) * step
            p.addLine(to: CGPoint(x: x - step / 2, y: rect.maxY))
            p.addLine(to: CGPoint(x: x - step, y: rect.minY + rect.height * 0.5))
        }
        p.closeSubpath()
        return p
    }
}

struct HammerArt: View {
    private let head = Color(red: 0.58, green: 0.62, blue: 0.70)
    private let handle = Color(red: 0.72, green: 0.49, blue: 0.29)

    var body: some View {
        ArtCanvas {
            // handle
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(handle)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 20, height: 74)
                .offset(y: 18)
            // head
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(head)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 66, height: 30)
                .offset(x: 4, y: -30)
            // claw hint
            Capsule().fill(head).frame(width: 16, height: 26).offset(x: -26, y: -28)
        }
    }
}

struct BrushArt: View {
    private let handle = Color(red: 0.62, green: 0.43, blue: 0.78)
    private let ferrule = Color(red: 0.80, green: 0.83, blue: 0.88)
    private let paint = Theme.coral

    var body: some View {
        ArtCanvas {
            // handle
            Capsule()
                .fill(handle)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 20, height: 64)
                .rotationEffect(.degrees(20))
                .offset(x: 14, y: -20)
            // ferrule
            RoundedRectangle(cornerRadius: 4).fill(ferrule)
                .frame(width: 22, height: 16)
                .rotationEffect(.degrees(20))
                .offset(x: -8, y: 18)
            // bristles with a paint blob
            TriangleShape().fill(paint)
                .frame(width: 26, height: 26)
                .rotationEffect(.degrees(200))
                .offset(x: -18, y: 34)
            Circle().fill(paint).frame(width: 22).offset(x: -30, y: 44)
        }
    }
}

// MARK: - Ark build stages

/// Stage 0: a neat pile of cut planks.
struct ArkPlanksArt: View {
    var body: some View {
        ArtCanvas {
            ForEach(0..<4, id: \.self) { i in
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(i.isMultiple(of: 2) ? Theme.wood : Theme.woodDeep)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.outline.opacity(0.3), lineWidth: 2))
                    .frame(width: 96 - CGFloat(i) * 6, height: 16)
                    .offset(y: CGFloat(i) * 20 - 30)
            }
        }
    }
}

/// Stage 1: the hull outline / skeleton frame.
struct ArkFrameArt: View {
    var body: some View {
        ArtCanvas {
            ArkHullShape()
                .stroke(Theme.woodDeep, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 116, height: 100)
                .offset(y: 8)
            // ribs
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(Theme.wood.opacity(0.8))
                    .frame(width: 5, height: 52 - CGFloat(i) * 4)
                    .offset(x: CGFloat(i - 1) * 26, y: 20)
            }
        }
    }
}

/// Stage 2: solid unpainted hull (no cabin, no paint yet).
struct ArkHullArt: View {
    var body: some View {
        ArtCanvas {
            ArkHullShape()
                .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(ArkHullShape().stroke(Theme.outline.opacity(0.4), lineWidth: 3))
                .frame(width: 116, height: 100)
                .offset(y: 8)
            Capsule().fill(Theme.woodDeep.opacity(0.55)).frame(width: 92, height: 3.5).offset(y: 16)
            Capsule().fill(Theme.woodDeep.opacity(0.55)).frame(width: 70, height: 3.5).offset(y: 32)
        }
    }
}
