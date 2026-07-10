import SwiftUI
import UIKit

/// Per-world background: if a bundled `bg_<worldID>.png` exists (Phase 3 of
/// the art pass), it fills the screen automatically; otherwise the shared
/// meadow. Drop a background in Resources/ and the world dresses itself.
struct WorldBackground: View {
    let worldID: String

    var body: some View {
        if let image = bundledArtImage("bg_\(worldID)") {
            GeometryReader { geo in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
        } else {
            MeadowBackground()
        }
    }
}

/// Soft storybook meadow used behind most screens: sky gradient, gentle sun,
/// puffy clouds, rolling hills.
struct MeadowBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.skyTop, Theme.skyBottom],
                           startPoint: .top, endPoint: .bottom)

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                Group {
                    // sun with soft glow
                    Circle()
                        .fill(Theme.sunny.opacity(0.25))
                        .frame(width: 120)
                        .position(x: w * 0.90, y: h * 0.14)
                    Circle()
                        .fill(Theme.sunny)
                        .frame(width: 66)
                        .position(x: w * 0.90, y: h * 0.14)

                    CloudPuff()
                        .position(x: w * 0.18, y: h * 0.16)
                    CloudPuff()
                        .scaleEffect(0.75)
                        .position(x: w * 0.58, y: h * 0.09)

                    // hills
                    Ellipse()
                        .fill(Theme.grassDeep)
                        .frame(width: w * 1.6, height: h * 0.60)
                        .position(x: w * 0.85, y: h * 1.12)
                    Ellipse()
                        .fill(Theme.grass)
                        .frame(width: w * 1.5, height: h * 0.66)
                        .position(x: w * 0.20, y: h * 1.10)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct CloudPuff: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 34).offset(x: -23, y: 7)
            Circle().frame(width: 48)
            Circle().frame(width: 34).offset(x: 25, y: 8)
            Capsule().frame(width: 88, height: 32).offset(y: 13)
        }
        .foregroundColor(.white.opacity(0.92))
        .frame(width: 100, height: 66)
    }
}
