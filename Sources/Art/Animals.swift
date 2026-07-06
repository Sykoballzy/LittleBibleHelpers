import SwiftUI

// Friendly, front-facing "sticker" style animals: big head, soft colors,
// large eyes, blush cheeks. Designed in the shared 120x120 canvas.

struct ElephantArt: View {
    private let gray = Color(red: 0.64, green: 0.68, blue: 0.78)
    private let grayDark = Color(red: 0.52, green: 0.56, blue: 0.67)
    private let earPink = Color(red: 0.93, green: 0.76, blue: 0.78)

    var body: some View {
        ArtCanvas {
            // ears
            Circle().fill(grayDark).frame(width: 42).offset(x: -38, y: -10)
            Circle().fill(grayDark).frame(width: 42).offset(x: 38, y: -10)
            Circle().fill(earPink).frame(width: 24).offset(x: -38, y: -10)
            Circle().fill(earPink).frame(width: 24).offset(x: 38, y: -10)
            // head
            Circle()
                .fill(gray)
                .overlay(Circle().stroke(Theme.outline.opacity(0.30), lineWidth: 3))
                .frame(width: 74)
                .offset(y: -4)
            // trunk
            Capsule().fill(gray).frame(width: 17, height: 42).offset(y: 26)
            Capsule().fill(grayDark).frame(width: 11, height: 5).offset(y: 45)
            CuteEyes(spacing: 26, size: 11).offset(y: -14)
            Blush(spacing: 52).offset(y: -2)
        }
    }
}

struct GiraffeArt: View {
    private let yellow = Color(red: 0.98, green: 0.80, blue: 0.38)
    private let muzzle = Color(red: 0.99, green: 0.90, blue: 0.64)
    private let spot = Color(red: 0.88, green: 0.60, blue: 0.26)

    var body: some View {
        ArtCanvas {
            // ossicones
            Capsule().fill(yellow).frame(width: 6, height: 18).offset(x: -13, y: -52)
            Capsule().fill(yellow).frame(width: 6, height: 18).offset(x: 13, y: -52)
            Circle().fill(spot).frame(width: 11).offset(x: -13, y: -60)
            Circle().fill(spot).frame(width: 11).offset(x: 13, y: -60)
            // ears
            Ellipse().fill(yellow).frame(width: 22, height: 13)
                .rotationEffect(.degrees(-24)).offset(x: -35, y: -34)
            Ellipse().fill(yellow).frame(width: 22, height: 13)
                .rotationEffect(.degrees(24)).offset(x: 35, y: -34)
            // head
            Circle()
                .fill(yellow)
                .overlay(Circle().stroke(Theme.outline.opacity(0.30), lineWidth: 3))
                .frame(width: 72)
                .offset(y: -2)
            // spots
            Circle().fill(spot.opacity(0.85)).frame(width: 13).offset(x: -27, y: -20)
            Circle().fill(spot.opacity(0.85)).frame(width: 10).offset(x: 28, y: -14)
            // muzzle
            Ellipse().fill(muzzle).frame(width: 42, height: 28).offset(y: 20)
            Circle().fill(Theme.outline.opacity(0.7)).frame(width: 4).offset(x: -8, y: 18)
            Circle().fill(Theme.outline.opacity(0.7)).frame(width: 4).offset(x: 8, y: 18)
            CuteEyes(spacing: 24, size: 11).offset(y: -12)
            Blush(spacing: 54).offset(y: 2)
        }
    }
}

struct LionArt: View {
    private let mane = Color(red: 0.88, green: 0.54, blue: 0.20)
    private let face = Color(red: 0.99, green: 0.80, blue: 0.44)
    private let muzzle = Color(red: 1.00, green: 0.93, blue: 0.74)

    var body: some View {
        ArtCanvas {
            // bumpy mane
            ForEach(0..<8, id: \.self) { i in
                let angle = Double(i) * .pi / 4
                Circle()
                    .fill(mane)
                    .frame(width: 36)
                    .offset(x: CGFloat(cos(angle)) * 34, y: CGFloat(sin(angle)) * 34)
            }
            Circle().fill(mane).frame(width: 88)
            // face
            Circle()
                .fill(face)
                .overlay(Circle().stroke(Theme.outline.opacity(0.28), lineWidth: 3))
                .frame(width: 62)
            // muzzle + nose
            Ellipse().fill(muzzle).frame(width: 34, height: 24).offset(y: 14)
            Circle().fill(Color(red: 0.48, green: 0.31, blue: 0.20)).frame(width: 9).offset(y: 8)
            CuteEyes(spacing: 22, size: 10).offset(y: -8)
            Blush(spacing: 46).offset(y: 4)
        }
    }
}

struct SheepArt: View {
    private let wool = Color(red: 0.99, green: 0.98, blue: 0.94)
    private let skin = Color(red: 0.93, green: 0.80, blue: 0.66)

    var body: some View {
        ArtCanvas {
            // wool cloud
            ForEach(0..<6, id: \.self) { i in
                let angle = Double(i) * .pi / 3
                Circle()
                    .fill(wool)
                    .frame(width: 34)
                    .offset(x: CGFloat(cos(angle)) * 28, y: CGFloat(sin(angle)) * 28)
            }
            Circle()
                .fill(wool)
                .overlay(Circle().stroke(Theme.outline.opacity(0.22), lineWidth: 3))
                .frame(width: 64)
            // ears
            Ellipse().fill(skin).frame(width: 22, height: 12)
                .rotationEffect(.degrees(-16)).offset(x: -28, y: 2)
            Ellipse().fill(skin).frame(width: 22, height: 12)
                .rotationEffect(.degrees(16)).offset(x: 28, y: 2)
            // face
            Ellipse().fill(skin).frame(width: 34, height: 40).offset(y: 8)
            Circle().fill(Theme.outline.opacity(0.7)).frame(width: 3.5).offset(x: -5, y: 18)
            Circle().fill(Theme.outline.opacity(0.7)).frame(width: 3.5).offset(x: 5, y: 18)
            CuteEyes(spacing: 15, size: 9).offset(y: 2)
            // wool topknot
            Circle().fill(wool).frame(width: 22).offset(y: -34)
        }
    }
}

struct DoveArt: View {
    private let white = Color(red: 0.99, green: 0.99, blue: 0.97)
    private let wing = Color(red: 0.88, green: 0.92, blue: 0.97)
    private let leafGreen = Color(red: 0.44, green: 0.68, blue: 0.32)

    var body: some View {
        ArtCanvas {
            // tail
            Ellipse().fill(wing).frame(width: 30, height: 15)
                .rotationEffect(.degrees(-38)).offset(x: -34, y: 18)
            // body
            Ellipse()
                .fill(white)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 64, height: 44)
                .rotationEffect(.degrees(-12))
                .offset(x: -2, y: 8)
            // wing
            Ellipse().fill(wing).frame(width: 36, height: 20)
                .rotationEffect(.degrees(-28)).offset(x: -6, y: 0)
            // head
            Circle().fill(white).frame(width: 30).offset(x: 26, y: -16)
            // beak
            TriangleShape().fill(Color(red: 0.96, green: 0.65, blue: 0.25))
                .frame(width: 12, height: 10)
                .rotationEffect(.degrees(90))
                .offset(x: 43, y: -14)
            // eye
            Circle().fill(Theme.outline).frame(width: 6).offset(x: 28, y: -20)
            // olive sprig
            Capsule().fill(leafGreen).frame(width: 20, height: 3)
                .rotationEffect(.degrees(24)).offset(x: 50, y: -6)
            Ellipse().fill(leafGreen).frame(width: 11, height: 6)
                .rotationEffect(.degrees(-20)).offset(x: 54, y: -12)
            Ellipse().fill(leafGreen).frame(width: 11, height: 6)
                .rotationEffect(.degrees(50)).offset(x: 57, y: 0)
        }
    }
}

struct FishArt: View {
    private let blue = Color(red: 0.40, green: 0.69, blue: 0.92)
    private let blueDark = Color(red: 0.30, green: 0.56, blue: 0.82)
    private let belly = Color(red: 0.80, green: 0.91, blue: 0.99)

    var body: some View {
        ArtCanvas {
            // tail
            TriangleShape().fill(blueDark)
                .frame(width: 26, height: 26)
                .rotationEffect(.degrees(-90))
                .offset(x: -40, y: 0)
            // body
            Ellipse()
                .fill(blue)
                .overlay(Ellipse().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 66, height: 44)
                .offset(x: -2)
            // belly
            Ellipse().fill(belly).frame(width: 44, height: 22).offset(x: -2, y: 10)
            // top fin
            Ellipse().fill(blueDark).frame(width: 24, height: 14)
                .rotationEffect(.degrees(-16)).offset(x: -6, y: -24)
            // eye
            ZStack {
                Circle().fill(Color.white).frame(width: 14)
                Circle().fill(Theme.outline).frame(width: 8)
            }
            .offset(x: 16, y: -6)
            // bubbles
            Circle().stroke(blue.opacity(0.7), lineWidth: 2.5).frame(width: 9).offset(x: 42, y: -26)
            Circle().stroke(blue.opacity(0.5), lineWidth: 2).frame(width: 6).offset(x: 50, y: -14)
        }
    }
}
