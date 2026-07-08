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

/// Three stone jars side by side — they fill with water one at a time, then
/// all become wine at the miracle (John 2:6, 7).
struct JarTrioArt: View {
    let filled: Int
    let wine: Bool

    private let clay = Color(red: 0.80, green: 0.66, blue: 0.50)
    private let clayDeep = Color(red: 0.68, green: 0.53, blue: 0.38)
    private let water = Theme.sky
    private let wineRed = Color(red: 0.55, green: 0.16, blue: 0.28)

    var body: some View {
        ArtCanvas {
            ForEach(0..<3, id: \.self) { i in
                miniJar(index: i)
                    .offset(x: CGFloat(i - 1) * 40, y: CGFloat(i == 1 ? 6 : 0))
            }
            if wine {
                StarShape().fill(Theme.sunny).frame(width: 18, height: 18).offset(x: 34, y: -46)
                StarShape().fill(Theme.sunny.opacity(0.7)).frame(width: 12, height: 12).offset(x: -38, y: -50)
                StarShape().fill(Theme.sunny.opacity(0.5)).frame(width: 9, height: 9).offset(x: 0, y: -56)
            }
        }
    }

    @ViewBuilder
    private func miniJar(index: Int) -> some View {
        let hasContents = wine || index < filled
        ZStack {
            // belly
            Ellipse()
                .fill(LinearGradient(colors: [clay, clayDeep], startPoint: .top, endPoint: .bottom))
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 34, height: 44)
                .offset(y: 18)
            // neck + rim
            RoundedRectangle(cornerRadius: 4).fill(clay)
                .frame(width: 18, height: 12)
                .offset(y: -8)
            Capsule()
                .fill(clayDeep)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2))
                .frame(width: 26, height: 8)
                .offset(y: -15)
            // contents at the rim
            if hasContents {
                Ellipse()
                    .fill(wine ? wineRed : water)
                    .frame(width: 19, height: 5)
                    .offset(y: -15)
            } else {
                Ellipse().fill(Color.black.opacity(0.25)).frame(width: 17, height: 4).offset(y: -15)
            }
        }
    }
}

/// A sturdy broom for sweeping the hall floor.
struct BroomArt: View {
    private let straw = Color(red: 0.90, green: 0.74, blue: 0.40)
    private let strawDeep = Color(red: 0.78, green: 0.60, blue: 0.28)

    var body: some View {
        ArtCanvas {
            // handle
            Capsule()
                .fill(Theme.wood)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.32), lineWidth: 2.5))
                .frame(width: 10, height: 74)
                .rotationEffect(.degrees(14))
                .offset(x: 8, y: -18)
            // binding
            Capsule().fill(Theme.coral).frame(width: 34, height: 10)
                .rotationEffect(.degrees(14)).offset(x: -6, y: 20)
            // bristles
            ForEach(0..<5, id: \.self) { i in
                Capsule()
                    .fill(i.isMultiple(of: 2) ? straw : strawDeep)
                    .frame(width: 9, height: 34)
                    .rotationEffect(.degrees(14 + Double(i - 2) * 7))
                    .offset(x: -12 + CGFloat(i - 2) * 9, y: 40)
            }
        }
    }
}

/// A spray bottle for washing the windows.
struct SprayArt: View {
    private let bottle = Color(red: 0.55, green: 0.80, blue: 0.75)
    private let trigger = Color(red: 0.35, green: 0.55, blue: 0.52)

    var body: some View {
        ArtCanvas {
            // bottle body
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(bottle)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 42, height: 54)
                .offset(x: -6, y: 22)
            // neck
            RoundedRectangle(cornerRadius: 5).fill(trigger).frame(width: 16, height: 18).offset(x: -6, y: -12)
            // head + nozzle
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(trigger)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 40, height: 18)
                .offset(x: 2, y: -26)
            // trigger
            Capsule().fill(trigger).frame(width: 8, height: 18)
                .rotationEffect(.degrees(-20)).offset(x: -18, y: -14)
            // mist
            Circle().fill(Theme.sky.opacity(0.7)).frame(width: 6).offset(x: 32, y: -30)
            Circle().fill(Theme.sky.opacity(0.5)).frame(width: 5).offset(x: 40, y: -24)
            Circle().fill(Theme.sky.opacity(0.4)).frame(width: 4).offset(x: 38, y: -36)
        }
    }
}

/// The stone water jars from the wedding at Cana — empty, water, or wine.
struct JarArt: View {
    enum Fill { case empty, water, wine }
    let fill: Fill

    private let clay = Color(red: 0.80, green: 0.66, blue: 0.50)
    private let clayDeep = Color(red: 0.68, green: 0.53, blue: 0.38)

    var body: some View {
        ArtCanvas {
            // body (amphora belly)
            Ellipse()
                .fill(LinearGradient(colors: [clay, clayDeep], startPoint: .top, endPoint: .bottom))
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 66, height: 74)
                .offset(y: 16)
            // handles
            Circle()
                .trim(from: 0.25, to: 0.75)
                .stroke(clayDeep, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .frame(width: 26)
                .offset(x: -38, y: -6)
            Circle()
                .trim(from: 0.75, to: 1.25)
                .stroke(clayDeep, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .frame(width: 26)
                .offset(x: 38, y: -6)
            // neck + rim
            RoundedRectangle(cornerRadius: 6).fill(clay)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 34, height: 22)
                .offset(y: -26)
            Capsule()
                .fill(clayDeep)
                .overlay(Capsule().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 46, height: 12)
                .offset(y: -38)
            // contents visible at the rim
            switch fill {
            case .empty:
                Ellipse().fill(Color.black.opacity(0.25)).frame(width: 30, height: 7).offset(y: -37)
            case .water:
                Ellipse().fill(Theme.sky).frame(width: 34, height: 9).offset(y: -38)
                Circle().fill(Color.white.opacity(0.7)).frame(width: 6).offset(x: -8, y: -39)
            case .wine:
                Ellipse().fill(Color(red: 0.55, green: 0.16, blue: 0.28)).frame(width: 34, height: 9).offset(y: -38)
                Circle().fill(Color.white.opacity(0.4)).frame(width: 5).offset(x: -8, y: -39)
            }
            // a happy sparkle when the miracle has happened
            if fill == .wine {
                StarShape().fill(Theme.sunny).frame(width: 16, height: 16).offset(x: 30, y: -48)
                StarShape().fill(Theme.sunny.opacity(0.7)).frame(width: 10, height: 10).offset(x: -32, y: -50)
            }
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
