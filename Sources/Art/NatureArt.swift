import SwiftUI

// Creation-world art: moon, tree, earth. Same friendly storybook style,
// 120x120 canvas, thick soft outlines, big eyes where a face fits.

struct MoonArt: View {
    private let moon = Color(red: 0.99, green: 0.93, blue: 0.66)
    private let crater = Color(red: 0.93, green: 0.84, blue: 0.52)

    var body: some View {
        ArtCanvas {
            // soft glow
            Circle().fill(moon.opacity(0.25)).frame(width: 104)
            // crescent: full disc minus an offset disc
            Circle()
                .fill(moon)
                .overlay(Circle().stroke(Theme.outline.opacity(0.22), lineWidth: 3))
                .frame(width: 82)
                .overlay(
                    Circle()
                        .fill(Theme.skyTop.opacity(0.0))
                )
            // craters
            Circle().fill(crater).frame(width: 15).offset(x: -14, y: -12)
            Circle().fill(crater).frame(width: 10).offset(x: 10, y: 8)
            Circle().fill(crater).frame(width: 7).offset(x: -6, y: 18)
            // sleepy face
            HStack(spacing: 16) {
                sleepyEye
                sleepyEye
            }
            .offset(x: 6, y: -4)
            Blush(spacing: 40).offset(x: 6, y: 8)
        }
    }

    private var sleepyEye: some View {
        Circle()
            .trim(from: 0.0, to: 0.5)
            .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 12, height: 12)
            .rotationEffect(.degrees(180))
    }
}

struct TreeArt: View {
    private let leaf = Color(red: 0.46, green: 0.72, blue: 0.36)
    private let leafDark = Color(red: 0.36, green: 0.62, blue: 0.28)
    private let trunk = Color(red: 0.62, green: 0.44, blue: 0.28)

    var body: some View {
        ArtCanvas {
            // trunk
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(trunk)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.outline.opacity(0.28), lineWidth: 2.5))
                .frame(width: 20, height: 46)
                .offset(y: 34)
            // canopy — clustered leafy circles
            Circle().fill(leafDark).frame(width: 46).offset(x: -22, y: -6)
            Circle().fill(leafDark).frame(width: 46).offset(x: 22, y: -6)
            Circle().fill(leaf).frame(width: 40).offset(x: -20, y: -8)
            Circle().fill(leaf).frame(width: 40).offset(x: 20, y: -8)
            Circle().fill(leaf).frame(width: 58).offset(y: -24)
            Circle().fill(leaf).frame(width: 44).offset(y: -2)
            // a couple of fruits
            Circle().fill(Theme.coral).frame(width: 10).offset(x: -16, y: 2)
            Circle().fill(Theme.coral).frame(width: 10).offset(x: 18, y: -14)
        }
    }
}

struct EarthArt: View {
    private let ocean = Color(red: 0.35, green: 0.64, blue: 0.90)
    private let oceanDeep = Color(red: 0.27, green: 0.54, blue: 0.82)
    private let land = Color(red: 0.50, green: 0.75, blue: 0.40)

    var body: some View {
        ArtCanvas {
            Circle()
                .fill(LinearGradient(colors: [ocean, oceanDeep],
                                     startPoint: .top, endPoint: .bottom))
                .overlay(Circle().stroke(Theme.outline.opacity(0.25), lineWidth: 3))
                .frame(width: 96)
            // continents — soft blobby land masses, clipped to the globe
            ZStack {
                Capsule().fill(land).frame(width: 40, height: 26)
                    .rotationEffect(.degrees(-18)).offset(x: -16, y: -18)
                Capsule().fill(land).frame(width: 30, height: 34)
                    .rotationEffect(.degrees(12)).offset(x: 18, y: 6)
                Ellipse().fill(land).frame(width: 22, height: 16).offset(x: -18, y: 22)
            }
            .frame(width: 96, height: 96)
            .clipShape(Circle())
            // happy face
            CuteEyes(spacing: 26, size: 11).offset(y: -2)
            Circle()
                .trim(from: 0.08, to: 0.42)
                .stroke(Theme.outline, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .frame(width: 24)
                .offset(y: 8)
            Blush(spacing: 52).offset(y: 6)
            // shine
            Circle().fill(Color.white.opacity(0.35)).frame(width: 16).offset(x: -26, y: -26)
        }
    }
}
