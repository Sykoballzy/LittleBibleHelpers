import SwiftUI

// Story objects, characters, and badge artwork (120x120 canvas).

struct ArkHullShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.06, y: h * 0.38))
        p.addLine(to: CGPoint(x: w * 0.94, y: h * 0.38))
        p.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.96),
                       control: CGPoint(x: w * 0.97, y: h * 0.86))
        p.addLine(to: CGPoint(x: w * 0.30, y: h * 0.96))
        p.addQuadCurve(to: CGPoint(x: w * 0.06, y: h * 0.38),
                       control: CGPoint(x: w * 0.03, y: h * 0.86))
        p.closeSubpath()
        return p
    }
}

struct ArkArt: View {
    var body: some View {
        ArtCanvas {
            // cabin roof
            TriangleShape()
                .fill(Color(red: 0.85, green: 0.42, blue: 0.30))
                .frame(width: 58, height: 20)
                .offset(y: -46)
            // cabin
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Theme.wood)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.outline.opacity(0.35), lineWidth: 2.5))
                .frame(width: 44, height: 26)
                .offset(y: -23)
            // window
            Circle()
                .fill(Theme.cream)
                .overlay(Circle().stroke(Theme.woodDeep, lineWidth: 3))
                .frame(width: 15)
                .offset(y: -23)
            // hull
            ArkHullShape()
                .fill(LinearGradient(colors: [Theme.wood, Theme.woodDeep],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(ArkHullShape().stroke(Theme.outline.opacity(0.4), lineWidth: 3))
                .frame(width: 116, height: 100)
                .offset(y: 10)
            // plank lines
            Capsule().fill(Theme.woodDeep.opacity(0.55)).frame(width: 92, height: 3.5).offset(y: 18)
            Capsule().fill(Theme.woodDeep.opacity(0.55)).frame(width: 70, height: 3.5).offset(y: 34)
        }
    }
}

struct NoahArt: View {
    private let skin = Color(red: 0.97, green: 0.83, blue: 0.68)
    private let beard = Color(red: 0.96, green: 0.95, blue: 0.92)

    var body: some View {
        ArtCanvas {
            // robe / shoulders
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Theme.wood)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 74, height: 48)
                .offset(y: 40)
            // sash
            Capsule().fill(Theme.creamDeep).frame(width: 30, height: 44)
                .offset(y: 42)
            // head
            Circle()
                .fill(skin)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 48)
                .offset(y: -10)
            // hair
            Ellipse().fill(beard).frame(width: 46, height: 18).offset(y: -32)
            // beard
            Ellipse().fill(beard).frame(width: 46, height: 32).offset(y: 8)
            Circle().fill(beard).frame(width: 18).offset(x: -18, y: 2)
            Circle().fill(beard).frame(width: 18).offset(x: 18, y: 2)
            // face
            CuteEyes(spacing: 17, size: 9).offset(y: -14)
            Blush(spacing: 38).offset(y: -6)
            Ellipse().fill(skin).frame(width: 10, height: 8).offset(y: -6)
        }
    }
}

struct RainbowArt: View {
    var body: some View {
        ArtCanvas {
            Group {
                arc(radius: 88, color: Theme.coral)
                arc(radius: 68, color: Theme.sunny)
                arc(radius: 48, color: Theme.sky)
            }
            .offset(y: 22)
            cloud.offset(x: -44, y: 22)
            cloud.offset(x: 44, y: 22)
        }
    }

    private func arc(radius: CGFloat, color: Color) -> some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(color, style: StrokeStyle(lineWidth: 11, lineCap: .round))
            .frame(width: radius, height: radius)
            .rotationEffect(.degrees(180))
    }

    private var cloud: some View {
        ZStack {
            Circle().frame(width: 22).offset(x: -12, y: 3)
            Circle().frame(width: 28)
            Circle().frame(width: 22).offset(x: 13, y: 4)
        }
        .foregroundColor(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 2, y: 2)
    }
}

struct StormCloudArt: View {
    private let cloudGray = Color(red: 0.72, green: 0.77, blue: 0.85)
    private let cloudDark = Color(red: 0.60, green: 0.66, blue: 0.76)
    private let drop = Color(red: 0.42, green: 0.66, blue: 0.90)

    var body: some View {
        ArtCanvas {
            // cloud
            Circle().fill(cloudDark).frame(width: 42).offset(x: -26, y: -14)
            Circle().fill(cloudDark).frame(width: 42).offset(x: 26, y: -12)
            Circle().fill(cloudGray).frame(width: 56).offset(y: -20)
            Capsule().fill(cloudGray).frame(width: 92, height: 36).offset(y: -4)
            // rain
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(drop)
                    .frame(width: 7, height: 17)
                    .rotationEffect(.degrees(14))
                    .offset(x: CGFloat(i - 1) * 24, y: 32)
            }
            ForEach(0..<2, id: \.self) { i in
                Capsule()
                    .fill(drop.opacity(0.7))
                    .frame(width: 6, height: 14)
                    .rotationEffect(.degrees(14))
                    .offset(x: CGFloat(i) * 24 - 12, y: 50)
            }
        }
    }
}

struct SunArt: View {
    var body: some View {
        ArtCanvas {
            ForEach(0..<8, id: \.self) { i in
                Capsule()
                    .fill(Theme.sunny)
                    .frame(width: 9, height: 24)
                    .offset(y: -44)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            Circle()
                .fill(LinearGradient(colors: [Color(red: 1.0, green: 0.85, blue: 0.35), Theme.sunny],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(Circle().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 58)
            CuteEyes(spacing: 18, size: 9).offset(y: -6)
            Circle()
                .trim(from: 0.08, to: 0.42)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .frame(width: 22)
                .offset(y: 2)
            Blush(spacing: 40).offset(y: 4)
        }
    }
}

struct HeartArt: View {
    var body: some View {
        ArtCanvas {
            HeartShape()
                .fill(LinearGradient(colors: [Theme.coral, Color(red: 0.88, green: 0.36, blue: 0.32)],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(HeartShape().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 84, height: 78)
                .offset(y: -2)
            Circle().fill(Color.white.opacity(0.55)).frame(width: 15).offset(x: -20, y: -22)
        }
    }
}

struct HallArt: View {
    private let wall = Color(red: 0.95, green: 0.90, blue: 0.79)

    var body: some View {
        ArtCanvas {
            // roof
            TriangleShape()
                .fill(Color(red: 0.85, green: 0.42, blue: 0.30))
                .overlay(TriangleShape().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 100, height: 34)
                .offset(y: -28)
            // walls
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(wall)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 84, height: 50)
                .offset(y: 14)
            // windows
            RoundedRectangle(cornerRadius: 5).fill(Theme.skyTop).frame(width: 17, height: 17)
                .offset(x: -26, y: 8)
            RoundedRectangle(cornerRadius: 5).fill(Theme.skyTop).frame(width: 17, height: 17)
                .offset(x: 26, y: 8)
            // door
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Theme.woodDeep)
                .frame(width: 21, height: 28)
                .offset(y: 25)
            // welcome heart over the door
            HeartShape().fill(Theme.coral).frame(width: 13, height: 12).offset(y: -6)
            // path
            Ellipse().fill(Theme.creamDeep).frame(width: 44, height: 10).offset(y: 44)
        }
    }
}

struct StarArt: View {
    var body: some View {
        ArtCanvas {
            StarShape()
                .fill(LinearGradient(colors: [Color(red: 1.0, green: 0.87, blue: 0.40), Theme.sunny],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(StarShape().stroke(Theme.outline.opacity(0.3), lineWidth: 3))
                .frame(width: 92, height: 92)
            CuteEyes(spacing: 15, size: 8).offset(y: -2)
            Circle()
                .trim(from: 0.12, to: 0.38)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 16)
                .offset(y: 6)
        }
    }
}
