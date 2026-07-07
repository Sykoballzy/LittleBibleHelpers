import SwiftUI

// Story objects: Jonah's boat and the big fish, bread, and the meeting-life
// set (bag with packing stages, Bible, songbook, chair). 120x120 canvas.
// The Bible and songbook are deliberately generic — warm covers, no logos,
// nothing imitating any published edition.

struct BoatArt: View {
    private let sailCloth = Color(red: 0.99, green: 0.97, blue: 0.90)

    var body: some View {
        ArtCanvas {
            // mast
            Capsule().fill(Theme.woodDeep).frame(width: 7, height: 62).offset(x: 2, y: -18)
            // sail
            TriangleShape()
                .fill(sailCloth)
                .overlay(TriangleShape().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 44, height: 48)
                .rotationEffect(.degrees(90))
                .offset(x: 26, y: -22)
            // hull
            ArkHullShape()
                .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(ArkHullShape().stroke(Theme.outline.opacity(0.38), lineWidth: 3))
                .frame(width: 92, height: 56)
                .offset(y: 26)
            // water line
            Ellipse().fill(Color(red: 0.55, green: 0.78, blue: 0.92).opacity(0.7))
                .frame(width: 104, height: 14)
                .offset(y: 50)
        }
    }
}

/// The great fish Jehovah sent for Jonah — big, friendly, calm.
struct BigFishArt: View {
    private let body_ = Color(red: 0.42, green: 0.56, blue: 0.74)
    private let bodyDark = Color(red: 0.33, green: 0.45, blue: 0.62)
    private let belly = Color(red: 0.78, green: 0.86, blue: 0.94)

    var body: some View {
        ArtCanvas {
            // tail
            TriangleShape().fill(bodyDark)
                .frame(width: 34, height: 34)
                .rotationEffect(.degrees(-90))
                .offset(x: -48, y: -4)
            // big body
            Ellipse()
                .fill(body_)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.3), lineWidth: 3.5))
                .frame(width: 92, height: 60)
                .offset(x: 2)
            // belly
            Ellipse().fill(belly).frame(width: 66, height: 30).offset(x: 4, y: 14)
            // fin
            Ellipse().fill(bodyDark).frame(width: 30, height: 18)
                .rotationEffect(.degrees(-20)).offset(x: -2, y: -32)
            // gentle eye
            ZStack {
                Circle().fill(Color.white).frame(width: 16)
                Circle().fill(Theme.outline).frame(width: 9)
            }
            .offset(x: 30, y: -10)
            // calm mouth
            Circle()
                .trim(from: 0.10, to: 0.32)
                .stroke(Theme.outline.opacity(0.8), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 22)
                .offset(x: 40, y: 6)
            // bubbles
            Circle().stroke(body_.opacity(0.6), lineWidth: 2.5).frame(width: 10).offset(x: 52, y: -30)
            Circle().stroke(body_.opacity(0.4), lineWidth: 2).frame(width: 7).offset(x: 58, y: -18)
        }
    }
}

struct BreadArt: View {
    private let crust = Color(red: 0.87, green: 0.64, blue: 0.34)
    private let crustDeep = Color(red: 0.76, green: 0.52, blue: 0.24)

    var body: some View {
        ArtCanvas {
            // round loaf
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(LinearGradient(colors: [crust, crustDeep], startPoint: .top, endPoint: .bottom))
                .frame(width: 88)
                .offset(y: 22)
            Capsule()
                .fill(crustDeep)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 88, height: 16)
                .offset(y: 24)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Theme.outline.opacity(0.3), lineWidth: 3)
                .frame(width: 88)
                .offset(y: 22)
            // scoring lines
            Capsule().fill(crustDeep.opacity(0.8)).frame(width: 26, height: 4)
                .rotationEffect(.degrees(-30)).offset(x: -16, y: 0)
            Capsule().fill(crustDeep.opacity(0.8)).frame(width: 26, height: 4)
                .rotationEffect(.degrees(-30)).offset(x: 12, y: -6)
        }
    }
}

/// The meeting bag with packing stages: 0 = empty, 1 = Bible in,
/// 2 = Bible + songbook, ready to go.
struct BagArt: View {
    let contents: Int

    private let cloth = Color(red: 0.45, green: 0.60, blue: 0.56)
    private let clothDeep = Color(red: 0.35, green: 0.49, blue: 0.45)

    var body: some View {
        ArtCanvas {
            // strap
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(clothDeep, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 62)
                .offset(y: -14)
            // books peeking out (behind the front panel)
            if contents >= 1 {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.22))
                    .frame(width: 26, height: 34)
                    .rotationEffect(.degrees(-8))
                    .offset(x: -12, y: -10)
            }
            if contents >= 2 {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.coral)
                    .frame(width: 22, height: 30)
                    .rotationEffect(.degrees(7))
                    .offset(x: 12, y: -8)
            }
            // bag body
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(cloth)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 74, height: 54)
                .offset(y: 22)
            // pocket + button
            RoundedRectangle(cornerRadius: 10)
                .fill(clothDeep)
                .frame(width: 34, height: 26)
                .offset(y: 28)
            Circle().fill(Theme.sunny).frame(width: 10).offset(y: 20)
            // little star patch when fully packed
            if contents >= 2 {
                StarShape().fill(Theme.sunny).frame(width: 16, height: 16).offset(x: 24, y: 12)
            }
        }
    }
}

/// A generic warm-brown Bible — no lettering, no logos.
struct BookArt: View {
    private let cover = Color(red: 0.55, green: 0.35, blue: 0.22)
    private let coverDeep = Color(red: 0.44, green: 0.27, blue: 0.16)

    var body: some View {
        ArtCanvas {
            // pages
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(red: 0.99, green: 0.97, blue: 0.90))
                .frame(width: 66, height: 84)
                .offset(x: 4, y: 2)
            // cover
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(cover)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 68, height: 88)
                .offset(x: -2)
            // spine
            RoundedRectangle(cornerRadius: 4).fill(coverDeep).frame(width: 10, height: 88).offset(x: -32)
            // simple heart on the cover (love for Jehovah's word — not a logo)
            HeartShape().fill(Theme.sunny.opacity(0.9)).frame(width: 22, height: 20).offset(x: 2, y: -6)
            // ribbon bookmark
            Capsule().fill(Theme.coral).frame(width: 6, height: 20).offset(x: 14, y: 50)
        }
    }
}

struct SongbookArt: View {
    var body: some View {
        ArtCanvas {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.coral)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 62, height: 80)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.84, green: 0.40, blue: 0.30))
                .frame(width: 9, height: 80)
                .offset(x: -28)
            // music note
            Circle().fill(Color.white).frame(width: 16).offset(x: -4, y: 14)
            Capsule().fill(Color.white).frame(width: 5, height: 34).offset(x: 5, y: -2)
            Ellipse().fill(Color.white).frame(width: 16, height: 10)
                .rotationEffect(.degrees(-20)).offset(x: 10, y: -18)
        }
    }
}

/// A soft cleaning cloth with soap bubbles — for the Clean Up games.
struct ClothArt: View {
    private let fabric = Color(red: 0.58, green: 0.78, blue: 0.92)
    private let fabricDeep = Color(red: 0.44, green: 0.64, blue: 0.80)

    var body: some View {
        ArtCanvas {
            // folded cloth
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(fabric)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 72, height: 56)
                .rotationEffect(.degrees(-8))
                .offset(y: 10)
            // fold lines
            Capsule().fill(fabricDeep).frame(width: 58, height: 4)
                .rotationEffect(.degrees(-8)).offset(y: 0)
            Capsule().fill(fabricDeep).frame(width: 52, height: 4)
                .rotationEffect(.degrees(-8)).offset(y: 18)
            // soap bubbles
            Circle().stroke(Color.white, lineWidth: 3).frame(width: 16).offset(x: -30, y: -26)
            Circle().stroke(Color.white, lineWidth: 2.5).frame(width: 11).offset(x: -12, y: -34)
            Circle().stroke(Color.white, lineWidth: 2).frame(width: 8).offset(x: 4, y: -26)
            Circle().fill(Color.white.opacity(0.7)).frame(width: 6).offset(x: 16, y: -34)
        }
    }
}

struct ChairArt: View {
    private let seatColor = Color(red: 0.52, green: 0.60, blue: 0.72)
    private let frame = Color(red: 0.40, green: 0.46, blue: 0.56)

    var body: some View {
        ArtCanvas {
            // back
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(seatColor)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 52, height: 42)
                .offset(y: -26)
            // seat
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(seatColor)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 58, height: 14)
                .offset(y: 4)
            // legs
            Capsule().fill(frame).frame(width: 7, height: 44).rotationEffect(.degrees(8)).offset(x: -22, y: 30)
            Capsule().fill(frame).frame(width: 7, height: 44).rotationEffect(.degrees(-8)).offset(x: 22, y: 30)
            // cross bar
            Capsule().fill(frame).frame(width: 40, height: 5).offset(y: 34)
        }
    }
}
