import SwiftUI

// David-the-shepherd world art: David, his shepherd tools, the water bucket,
// and the sheep-pen build stages. 120x120 canvas, storybook style.

struct DavidArt: View {
    private let skin = Color(red: 0.94, green: 0.78, blue: 0.62)
    private let hair = Color(red: 0.48, green: 0.32, blue: 0.16)

    var body: some View {
        ArtCanvas {
            // staff leaning at his side
            Capsule().fill(Theme.woodDeep).frame(width: 7, height: 84)
                .rotationEffect(.degrees(10)).offset(x: 40, y: 6)
            // young shepherd's tunic
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.sunny)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 58, height: 48)
                .offset(y: 38)
            Capsule().fill(Theme.wood).frame(width: 46, height: 8).offset(y: 24) // belt
            // head — a boy, so a slightly bigger head ratio
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            // ruddy hair (1 Samuel 16:12)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 50)
                .offset(y: -12)
            Circle().fill(hair).frame(width: 12).offset(x: -22, y: -4)
            Circle().fill(hair).frame(width: 12).offset(x: 22, y: -4)
            CuteEyes(spacing: 17, size: 9).offset(y: -12)
            Blush(spacing: 38).offset(y: -4)
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 16)
                .offset(y: 0)
        }
    }
}

/// A shepherd's sling: a small pouch on two cords (a tool, drawn at rest).
struct SlingArt: View {
    private let leather = Color(red: 0.66, green: 0.47, blue: 0.28)

    var body: some View {
        ArtCanvas {
            // cords
            Capsule().fill(leather).frame(width: 6, height: 62)
                .rotationEffect(.degrees(-24)).offset(x: -20, y: -14)
            Capsule().fill(leather).frame(width: 6, height: 62)
                .rotationEffect(.degrees(24)).offset(x: 20, y: -14)
            // pouch
            Ellipse()
                .fill(leather)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 46, height: 30)
                .offset(y: 22)
            // smooth stone
            Circle()
                .fill(Color(red: 0.72, green: 0.74, blue: 0.78))
                .overlay(Circle().stroke(Theme.outline.opacity(0.25), lineWidth: 2))
                .frame(width: 18)
                .offset(y: 18)
        }
    }
}

struct HarpArt: View {
    private let gold = Color(red: 0.90, green: 0.72, blue: 0.30)
    private let goldDeep = Color(red: 0.78, green: 0.58, blue: 0.20)

    var body: some View {
        ArtCanvas {
            // frame: pillar + curved neck + soundboard
            Capsule().fill(goldDeep).frame(width: 12, height: 88)
                .rotationEffect(.degrees(-12)).offset(x: -26, y: 0)
            Capsule().fill(gold).frame(width: 12, height: 74)
                .rotationEffect(.degrees(64)).offset(x: 8, y: -34)
            Capsule().fill(gold)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 14, height: 80)
                .rotationEffect(.degrees(26))
                .offset(x: 22, y: 14)
            // strings
            ForEach(0..<4, id: \.self) { i in
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 2.5, height: 52 - CGFloat(i) * 8)
                    .offset(x: -12 + CGFloat(i) * 12, y: -4 + CGFloat(i) * 3)
            }
        }
    }
}

struct StaffArt: View {
    var body: some View {
        ArtCanvas {
            // rod
            Capsule()
                .fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 11, height: 92)
                .offset(x: 4, y: 12)
            // shepherd's crook
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Theme.wood, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                .frame(width: 34)
                .offset(x: -12, y: -36)
        }
    }
}

struct BucketArt: View {
    private let wood = Theme.wood
    private let water = Color(red: 0.55, green: 0.78, blue: 0.94)

    var body: some View {
        ArtCanvas {
            // handle
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Theme.woodDeep, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .frame(width: 56)
                .offset(y: -12)
            // pail
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(wood)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 62, height: 52)
                .offset(y: 18)
            // bands
            Capsule().fill(Theme.woodDeep.opacity(0.7)).frame(width: 58, height: 4).offset(y: 8)
            Capsule().fill(Theme.woodDeep.opacity(0.7)).frame(width: 52, height: 4).offset(y: 32)
            // water
            Ellipse().fill(water)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.2), lineWidth: 2))
                .frame(width: 54, height: 16)
                .offset(y: -6)
            Circle().fill(Color.white.opacity(0.6)).frame(width: 8).offset(x: -12, y: -7)
        }
    }
}

// MARK: - Sheep pen build stages

struct PenFrameArt: View {
    var body: some View {
        ArtCanvas {
            // two posts and a single rail — the start of the pen
            Capsule().fill(Theme.woodDeep).frame(width: 10, height: 58).offset(x: -34, y: 16)
            Capsule().fill(Theme.woodDeep).frame(width: 10, height: 58).offset(x: 34, y: 16)
            Capsule().fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 96, height: 11)
                .offset(y: 0)
        }
    }
}

struct PenArt: View {
    var body: some View {
        ArtCanvas {
            ForEach(0..<3, id: \.self) { i in
                Capsule().fill(Theme.woodDeep)
                    .frame(width: 10, height: 62)
                    .offset(x: CGFloat(i - 1) * 38, y: 14)
            }
            Capsule().fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 104, height: 11)
                .offset(y: -6)
            Capsule().fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 104, height: 11)
                .offset(y: 22)
        }
    }
}

struct PenFullArt: View {
    private let wool = Color(red: 0.99, green: 0.98, blue: 0.94)

    var body: some View {
        ArtCanvas {
            // two happy sheep peeking over the rails
            sheepFace.offset(x: -22, y: -18)
            sheepFace.offset(x: 24, y: -22)
            // fence in front
            ForEach(0..<3, id: \.self) { i in
                Capsule().fill(Theme.woodDeep)
                    .frame(width: 10, height: 56)
                    .offset(x: CGFloat(i - 1) * 38, y: 22)
            }
            Capsule().fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 104, height: 11)
                .offset(y: 6)
            Capsule().fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 104, height: 11)
                .offset(y: 32)
        }
    }

    private var sheepFace: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                let angle = Double(i) * 2 * .pi / 5
                Circle().fill(wool).frame(width: 18)
                    .offset(x: CGFloat(cos(angle)) * 13, y: CGFloat(sin(angle)) * 13)
            }
            Circle().fill(wool).frame(width: 28)
            Ellipse().fill(Color(red: 0.93, green: 0.80, blue: 0.66)).frame(width: 16, height: 19).offset(y: 3)
            CuteEyes(spacing: 7, size: 5).offset(y: 0)
        }
    }
}
