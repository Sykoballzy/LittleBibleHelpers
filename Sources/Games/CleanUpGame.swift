import SwiftUI

/// Template 14 (NEW): Clean Up. Smudges dot the scene; drag the cloth onto
/// each one and it wipes away with a sparkle. Everything ends clean and
/// ready — a helper's game (clean the hall; kindness clean-up).
struct CleanUpGame: View {
    let tool: ArtKey
    let surface: ArtKey
    let messCount: Int
    let onComplete: () -> Void

    @EnvironmentObject private var audio: AudioService

    private static let smudgeSpots: [CGPoint] = [
        CGPoint(x: 0.30, y: 0.26), CGPoint(x: 0.64, y: 0.20),
        CGPoint(x: 0.44, y: 0.52), CGPoint(x: 0.72, y: 0.56),
        CGPoint(x: 0.24, y: 0.60)
    ]
    private static let wipeLines = ["Scrub, scrub!", "All shiny!", "Wiped clean!"]

    @State private var cleaned: Set<Int> = []
    @State private var sparkles: Set<Int> = []
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let smudgeSize = min(w, h) * 0.15
            let toolSize = min(w, h) * 0.20
            let toolHome = CGPoint(x: w * 0.50, y: h * 0.85)
            let spotCount = min(messCount, Self.smudgeSpots.count)

            ZStack {
                // The place being cared for.
                ArtView(key: surface)
                    .frame(width: min(w, h) * 0.52, height: min(w, h) * 0.52)
                    .opacity(0.9)
                    .position(x: w * 0.5, y: h * 0.38)

                // Smudges (and the sparkles they become).
                ForEach(0..<spotCount, id: \.self) { i in
                    let spot = CGPoint(x: w * Self.smudgeSpots[i].x, y: h * Self.smudgeSpots[i].y)
                    if !cleaned.contains(i) {
                        SmudgeView()
                            .frame(width: smudgeSize, height: smudgeSize)
                            .position(spot)
                    } else if sparkles.contains(i) {
                        StarShape()
                            .fill(Theme.sunny)
                            .frame(width: smudgeSize * 0.6, height: smudgeSize * 0.6)
                            .position(spot)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                // The cloth.
                ArtView(key: tool)
                    .frame(width: toolSize, height: toolSize)
                    .scaleEffect(isDragging ? 1.1 : 1.0)
                    .offset(dragOffset)
                    .position(toolHome)
                    .zIndex(5)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                dragOffset = value.translation
                                // Wipe anything the cloth passes over.
                                let point = CGPoint(x: toolHome.x + value.translation.width,
                                                    y: toolHome.y + value.translation.height)
                                wipeIfTouching(point, size: geo.size, radius: smudgeSize * 0.8, spotCount: spotCount)
                            }
                            .onEnded { _ in
                                isDragging = false
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                                    dragOffset = .zero
                                }
                            }
                    )

                ProgressPips(filled: cleaned.count, total: spotCount)
                    .position(x: w * 0.5, y: h * 0.96)
            }
        }
    }

    private func wipeIfTouching(_ point: CGPoint, size: CGSize, radius: CGFloat, spotCount: Int) {
        for i in 0..<spotCount where !cleaned.contains(i) {
            let spot = CGPoint(x: size.width * Self.smudgeSpots[i].x,
                               y: size.height * Self.smudgeSpots[i].y)
            let dx = point.x - spot.x
            let dy = point.y - spot.y
            guard dx * dx + dy * dy <= radius * radius else { continue }

            Haptics.soft()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                _ = cleaned.insert(i)
                _ = sparkles.insert(i)
            }
            audio.speak(Self.wipeLines[cleaned.count % Self.wipeLines.count])
            // The sparkle fades after a moment.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    _ = sparkles.remove(i)
                }
            }

            if cleaned.count == spotCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    audio.speak("Everything is clean and ready!")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4, execute: onComplete)
            }
        }
    }
}

/// A soft, unscary smudge — overlapping dusty blobs.
struct SmudgeView: View {
    private let dust = Color(red: 0.55, green: 0.50, blue: 0.44)

    var body: some View {
        ZStack {
            Ellipse().fill(dust.opacity(0.35)).frame(width: 54, height: 38)
                .rotationEffect(.degrees(-12))
            Ellipse().fill(dust.opacity(0.3)).frame(width: 40, height: 30)
                .rotationEffect(.degrees(18)).offset(x: 14, y: 8)
            Circle().fill(dust.opacity(0.4)).frame(width: 12).offset(x: -16, y: 10)
            Circle().fill(dust.opacity(0.35)).frame(width: 8).offset(x: 8, y: -12)
        }
        .frame(width: 70, height: 55)
    }
}
