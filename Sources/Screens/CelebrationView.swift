import SwiftUI

/// Gentle success screen: banner, sticker reveal, calm twinkling stars.
/// No loud fanfare — encouraging, never overstimulating.
struct CelebrationView: View {
    let worldID: String
    let activityID: String

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService

    @State private var revealed = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.cream, Theme.creamDeep],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            GentleSparkles()

            if let pair = ContentLibrary.lookup(worldID: worldID, activityID: activityID) {
                VStack(spacing: 22) {
                    BannerTitle(text: "Great Job!", color: Theme.leaf, textSize: 42)

                    Text(pair.activity.completionLine)
                        .font(Theme.body(26))
                        .foregroundColor(Theme.textDark)

                    StickerView(collectible: pair.activity.reward)
                        .frame(width: 210, height: 210)
                        .scaleEffect(revealed ? 1 : 0.1)
                        .opacity(revealed ? 1 : 0)

                    Text("\(pair.activity.reward.name) joined your collection!")
                        .font(Theme.body(20))
                        .foregroundColor(Theme.textDark.opacity(0.72))

                    HStack(spacing: 26) {
                        ChunkyButton(title: "More Games", icon: "arrow.backward", color: Theme.sunny, size: 24) {
                            router.go(.storyHub(worldID: worldID))
                        }
                        ChunkyButton(title: "Home", icon: "house.fill", color: Theme.sky, size: 24) {
                            router.go(.home)
                        }
                    }
                    .padding(.top, 6)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.25)) {
                revealed = true
            }
            if let pair = ContentLibrary.lookup(worldID: worldID, activityID: activityID) {
                audio.speak("Great job! " + pair.activity.completionLine)
            }
        }
    }
}

struct StickerView: View {
    let collectible: Collectible

    var body: some View {
        ZStack {
            Circle().fill(Color.white)
            Circle()
                .strokeBorder(Theme.sunny,
                              style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [1, 12]))
                .padding(6)
            ArtView(key: collectible.art).padding(34)
        }
        .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
    }
}

/// Calm twinkling stars — slow fades, no motion, no flashing.
struct GentleSparkles: View {
    private struct Spark: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let delay: Double
        let color: Color
    }

    @State private var sparks: [Spark] = []
    @State private var twinkle = false

    var body: some View {
        GeometryReader { geo in
            ForEach(sparks) { spark in
                StarShape()
                    .fill(spark.color)
                    .frame(width: spark.size, height: spark.size)
                    .position(x: spark.x * geo.size.width, y: spark.y * geo.size.height)
                    .opacity(twinkle ? 0.85 : 0.15)
                    .scaleEffect(twinkle ? 1 : 0.6)
                    .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true).delay(spark.delay),
                               value: twinkle)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            if sparks.isEmpty {
                let colors = [Theme.sunny, Theme.coral, Theme.sky, Theme.berry, Theme.leaf]
                sparks = (0..<14).map { i in
                    // keep sparkles near the edges, away from the sticker
                    let x: CGFloat = Bool.random() ? .random(in: 0.04...0.22) : .random(in: 0.78...0.96)
                    return Spark(x: x,
                                 y: .random(in: 0.08...0.9),
                                 size: .random(in: 18...34),
                                 delay: Double(i) * 0.12,
                                 color: colors[i % colors.count])
                }
            }
            twinkle = true
        }
    }
}
