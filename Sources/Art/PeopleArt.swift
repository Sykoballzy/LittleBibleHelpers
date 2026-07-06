import SwiftUI

// People and message art: townspeople for Noah's preaching game, Adam,
// Adam & Eve together, and the scroll/message. 120x120 canvas, storybook style.

/// A friendly townsperson. Robe and hair colors vary per villager key so the
/// crowd feels like different people without three separate drawings.
struct VillagerArt: View {
    let robe: Color
    let hair: Color

    private let skin = Color(red: 0.97, green: 0.83, blue: 0.68)

    var body: some View {
        ArtCanvas {
            // robe / body
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(robe)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 62, height: 52)
                .offset(y: 38)
            // sash
            Capsule().fill(Color.white.opacity(0.35)).frame(width: 24, height: 46).offset(y: 40)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 46)
                .offset(y: -10)
            // hair cap
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 48)
                .offset(y: -12)
            CuteEyes(spacing: 16, size: 9).offset(y: -12)
            Blush(spacing: 36).offset(y: -4)
        }
    }
}

struct AdamArt: View {
    private let skin = Color(red: 0.93, green: 0.76, blue: 0.60)
    private let hair = Color(red: 0.32, green: 0.22, blue: 0.14)

    var body: some View {
        ArtCanvas {
            // simple leaf-green tunic
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Theme.leaf)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 64, height: 50)
                .offset(y: 38)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            // short dark hair
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 50)
                .offset(y: -12)
            CuteEyes(spacing: 17, size: 9).offset(y: -12)
            Blush(spacing: 38).offset(y: -4)
            // friendly smile
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 16)
                .offset(y: 0)
        }
    }
}

/// Adam and Eve side by side — used for "Jehovah made people" story beats.
struct PeopleArt: View {
    private let skinA = Color(red: 0.93, green: 0.76, blue: 0.60)
    private let skinB = Color(red: 0.98, green: 0.85, blue: 0.70)
    private let hairA = Color(red: 0.32, green: 0.22, blue: 0.14)
    private let hairB = Color(red: 0.55, green: 0.35, blue: 0.16)

    var body: some View {
        ArtCanvas {
            figure(x: -24, skin: skinA, hair: hairA, robe: Theme.leaf, longHair: false)
            figure(x: 24, skin: skinB, hair: hairB, robe: Theme.sunny, longHair: true)
        }
    }

    @ViewBuilder
    private func figure(x: CGFloat, skin: Color, hair: Color, robe: Color, longHair: Bool) -> some View {
        // body
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(robe)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
            .frame(width: 42, height: 40)
            .offset(x: x, y: 34)
        // long hair behind the head
        if longHair {
            Ellipse().fill(hair).frame(width: 40, height: 52).offset(x: x, y: -2)
        }
        // head
        Circle()
            .fill(skin)
            .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 2.5))
            .frame(width: 36)
            .offset(x: x, y: -8)
        // hair cap
        Circle()
            .trim(from: 0.5, to: 1.0)
            .fill(hair)
            .frame(width: 38)
            .offset(x: x, y: -10)
        CuteEyes(spacing: 11, size: 7).offset(x: x, y: -10)
        Blush(spacing: 26).offset(x: x, y: -3)
    }
}

/// A rolled message scroll — Noah's warning.
struct ScrollArt: View {
    private let paper = Color(red: 0.99, green: 0.95, blue: 0.85)
    private let roll = Color(red: 0.93, green: 0.85, blue: 0.68)

    var body: some View {
        ArtCanvas {
            // open parchment
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(paper)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 64, height: 74)
            // rolled ends
            Capsule().fill(roll)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 78, height: 16)
                .offset(y: -38)
            Capsule().fill(roll)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 78, height: 16)
                .offset(y: 38)
            // simple picture-writing: rain cloud over an ark (a warning anyone can read)
            Group {
                Circle().fill(Theme.sky.opacity(0.7)).frame(width: 16).offset(x: -8, y: -14)
                Circle().fill(Theme.sky.opacity(0.7)).frame(width: 13).offset(x: 4, y: -12)
                Capsule().fill(Theme.sky.opacity(0.7)).frame(width: 28, height: 10).offset(y: -8)
                Capsule().fill(Theme.sky).frame(width: 3, height: 8).rotationEffect(.degrees(14)).offset(x: -8, y: 2)
                Capsule().fill(Theme.sky).frame(width: 3, height: 8).rotationEffect(.degrees(14)).offset(x: 2, y: 2)
            }
            ArkHullShape()
                .fill(Theme.wood)
                .frame(width: 36, height: 26)
                .offset(y: 18)
        }
    }
}
