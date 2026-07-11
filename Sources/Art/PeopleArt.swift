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

/// The meeting speaker — modern day, suit and tie, warm smile.
struct SpeakerArt: View {
    private let skin = Color(red: 0.94, green: 0.78, blue: 0.62)
    private let hair = Color(red: 0.30, green: 0.22, blue: 0.15)
    private let suit = Color(red: 0.25, green: 0.32, blue: 0.45)

    var body: some View {
        ArtCanvas {
            // suit jacket
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(suit)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 64, height: 50)
                .offset(y: 38)
            // white shirt
            TriangleShape()
                .fill(Color.white)
                .frame(width: 26, height: 22)
                .rotationEffect(.degrees(180))
                .offset(y: 24)
            // tie
            Capsule().fill(Theme.coral).frame(width: 9, height: 26).offset(y: 34)
            // lapels
            Capsule().fill(suit).frame(width: 8, height: 22)
                .rotationEffect(.degrees(24)).offset(x: -12, y: 26)
            Capsule().fill(suit).frame(width: 8, height: 22)
                .rotationEffect(.degrees(-24)).offset(x: 12, y: 26)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 46)
                .offset(y: -10)
            // tidy hair
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 48)
                .offset(y: -12)
            CuteEyes(spacing: 16, size: 9).offset(y: -12)
            Blush(spacing: 36).offset(y: -4)
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 15)
                .offset(y: -1)
        }
    }
}

/// A little child — the player's stand-in for pathway games.
struct ChildArt: View {
    private let skin = Color(red: 0.96, green: 0.80, blue: 0.64)
    private let hair = Color(red: 0.45, green: 0.30, blue: 0.16)

    var body: some View {
        ArtCanvas {
            // small tunic
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Theme.sky)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 50, height: 42)
                .offset(y: 40)
            // big friendly head (kid proportions)
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 52)
                .offset(y: -6)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 54)
                .offset(y: -8)
            // little tuft
            Ellipse().fill(hair).frame(width: 14, height: 10).offset(y: -34)
            CuteEyes(spacing: 17, size: 10).offset(y: -8)
            Blush(spacing: 40).offset(y: 2)
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 16)
                .offset(y: 6)
        }
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
            // plain written lines — a message, whatever the message is
            VStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule()
                        .fill(Theme.outline.opacity(0.35))
                        .frame(width: i == 3 ? 26 : 44, height: 5)
                        .frame(maxWidth: .infinity,
                               alignment: i == 3 ? .leading : .center)
                }
            }
            .frame(width: 44)
        }
    }
}

/// A friendly, completely generic magazine for the ministry games — bright
/// cover with a sun picture and title bars. No real publication is imitated.
struct MagazineArt: View {
    private let cover = Color(red: 0.55, green: 0.78, blue: 0.91)

    var body: some View {
        ArtCanvas {
            // back page peeking out
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 62, height: 82)
                .rotationEffect(.degrees(4))
                .offset(x: 4, y: 2)
            // cover
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(cover)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Theme.outline.opacity(0.35), lineWidth: 3))
                .frame(width: 62, height: 82)
                .rotationEffect(.degrees(-3))
            Group {
                // title bar
                Capsule().fill(Color.white.opacity(0.95))
                    .frame(width: 42, height: 9)
                    .offset(y: -28)
                // cover picture: a little sunrise
                Circle().fill(Theme.sunny)
                    .frame(width: 24)
                    .offset(y: 2)
                Capsule().fill(Theme.leaf.opacity(0.85))
                    .frame(width: 44, height: 12)
                    .offset(y: 16)
                // caption lines
                Capsule().fill(Color.white.opacity(0.9)).frame(width: 36, height: 5).offset(y: 30)
            }
            .rotationEffect(.degrees(-3))
        }
    }
}
