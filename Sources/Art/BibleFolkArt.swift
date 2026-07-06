import SwiftUI

// Characters for the Daniel, Jonah, and Jesus worlds, plus Daniel's window,
// the crown, and the angel. Doctrinal notes: the angel is a glowing, humanlike
// figure — no halo, no wings. All faces warm and friendly. 120x120 canvas.

struct DanielArt: View {
    private let skin = Color(red: 0.90, green: 0.72, blue: 0.55)
    private let hair = Color(red: 0.20, green: 0.15, blue: 0.11)

    var body: some View {
        ArtCanvas {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Theme.berry)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 64, height: 50)
                .offset(y: 38)
            Capsule().fill(Theme.sunny.opacity(0.8)).frame(width: 24, height: 46).offset(y: 40)
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 50)
                .offset(y: -12)
            // short beard
            Ellipse().fill(hair).frame(width: 34, height: 18).offset(y: 8)
            Ellipse().fill(skin).frame(width: 16, height: 9).offset(y: 3)
            CuteEyes(spacing: 17, size: 9).offset(y: -14)
            Blush(spacing: 38).offset(y: -6)
        }
    }
}

/// A glowing, humanlike messenger — deliberately no halo and no wings.
struct AngelArt: View {
    private let robe = Color(red: 0.99, green: 0.98, blue: 0.94)
    private let skin = Color(red: 0.96, green: 0.82, blue: 0.66)
    private let hair = Color(red: 0.85, green: 0.68, blue: 0.38)

    var body: some View {
        ArtCanvas {
            // soft radiance
            Circle().fill(Theme.sunny.opacity(0.22)).frame(width: 112)
            Circle().fill(Theme.sunny.opacity(0.14)).frame(width: 92)
            // robe
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(robe)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Theme.sunny.opacity(0.6), lineWidth: 3))
                .frame(width: 60, height: 52)
                .offset(y: 36)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 46)
                .offset(y: -10)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 48)
                .offset(y: -12)
            CuteEyes(spacing: 16, size: 9).offset(y: -12)
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 15)
                .offset(y: -1)
        }
    }
}

struct CrownArt: View {
    private let gold = Color(red: 0.95, green: 0.76, blue: 0.26)
    private let goldDeep = Color(red: 0.84, green: 0.62, blue: 0.16)

    var body: some View {
        ArtCanvas {
            // band
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(gold)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 84, height: 30)
                .offset(y: 22)
            // points
            ForEach(0..<3, id: \.self) { i in
                TriangleShape()
                    .fill(gold)
                    .overlay(TriangleShape().stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                    .frame(width: 30, height: 34)
                    .offset(x: CGFloat(i - 1) * 28, y: -8)
            }
            ForEach(0..<3, id: \.self) { i in
                Circle().fill(goldDeep).frame(width: 10)
                    .offset(x: CGFloat(i - 1) * 28, y: -22)
            }
            // jewels on the band
            Circle().fill(Theme.coral).frame(width: 12).offset(y: 22)
            Circle().fill(Theme.sky).frame(width: 10).offset(x: -26, y: 22)
            Circle().fill(Theme.leaf).frame(width: 10).offset(x: 26, y: 22)
        }
    }
}

/// Daniel's open evening window — where he prayed three times a day.
struct WindowArt: View {
    private let night = Color(red: 0.22, green: 0.28, blue: 0.48)
    private let frame = Color(red: 0.93, green: 0.88, blue: 0.78)

    var body: some View {
        ArtCanvas {
            // arched frame
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(frame)
                .overlay(RoundedRectangle(cornerRadius: 34).stroke(Theme.outline.opacity(0.32), lineWidth: 3))
                .frame(width: 78, height: 100)
                .offset(y: 0)
            // night sky inside
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(night)
                .frame(width: 62, height: 84)
                .offset(y: 0)
            // crescent moon + stars
            Circle().fill(Color(red: 0.99, green: 0.93, blue: 0.66)).frame(width: 22).offset(x: 12, y: -22)
            Circle().fill(night).frame(width: 18).offset(x: 18, y: -26)
            StarShape().fill(Color.white.opacity(0.9)).frame(width: 10, height: 10).offset(x: -14, y: -10)
            StarShape().fill(Color.white.opacity(0.7)).frame(width: 7, height: 7).offset(x: -4, y: 14)
            // sill
            RoundedRectangle(cornerRadius: 5).fill(frame)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Theme.outline.opacity(0.3), lineWidth: 2.5))
                .frame(width: 92, height: 12)
                .offset(y: 52)
        }
    }
}

struct JonahArt: View {
    private let skin = Color(red: 0.93, green: 0.76, blue: 0.58)
    private let hair = Color(red: 0.42, green: 0.28, blue: 0.16)

    var body: some View {
        ArtCanvas {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(red: 0.30, green: 0.62, blue: 0.62))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 64, height: 50)
                .offset(y: 38)
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 50)
                .offset(y: -12)
            Ellipse().fill(hair).frame(width: 34, height: 16).offset(y: 9)
            Ellipse().fill(skin).frame(width: 16, height: 8).offset(y: 4)
            CuteEyes(spacing: 17, size: 9).offset(y: -13)
            Blush(spacing: 38).offset(y: -5)
        }
    }
}

struct JesusArt: View {
    private let skin = Color(red: 0.91, green: 0.74, blue: 0.57)
    private let hair = Color(red: 0.35, green: 0.24, blue: 0.14)
    private let robe = Color(red: 0.97, green: 0.95, blue: 0.90)

    var body: some View {
        ArtCanvas {
            // simple robe with a warm sash — no symbols, no halo
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(robe)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 66, height: 50)
                .offset(y: 38)
            Capsule().fill(Theme.coral).frame(width: 16, height: 48)
                .rotationEffect(.degrees(18)).offset(x: -8, y: 38)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            // shoulder-length hair
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(hair)
                .frame(width: 52)
                .offset(y: -12)
            Capsule().fill(hair).frame(width: 12, height: 34).offset(x: -22, y: 0)
            Capsule().fill(hair).frame(width: 12, height: 34).offset(x: 22, y: 0)
            // short beard
            Ellipse().fill(hair).frame(width: 32, height: 16).offset(y: 9)
            Ellipse().fill(skin).frame(width: 15, height: 8).offset(y: 4)
            CuteEyes(spacing: 17, size: 9).offset(y: -13)
            // warm smile
            Circle()
                .trim(from: 0.14, to: 0.36)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 16)
                .offset(y: -2)
        }
    }
}
