import SwiftUI

/// Gentle success screen: banner, sticker reveal, calm twinkling stars.
/// No loud fanfare — encouraging, never overstimulating.
/// When the final activity in a world is finished, it also reveals the world's
/// bonus character and points the child to their collection.
struct CelebrationView: View {
    let worldID: String
    let activityID: String

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService
    @EnvironmentObject private var progress: ProgressStore

    @State private var revealed = false
    @State private var bonusRevealed = false

    private var world: BibleWorld? { ContentLibrary.world(worldID) }

    private var worldComplete: Bool {
        guard let world, world.bonusReward != nil else { return false }
        return world.activities.allSatisfy { progress.isCompleted($0.id) }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.cream, Theme.creamDeep],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            GentleSparkles()

            if let pair = ContentLibrary.lookup(worldID: worldID, activityID: activityID) {
                VStack(spacing: 18) {
                    BannerTitle(text: worldComplete ? "You Did It!" : "Great Job!",
                                color: Theme.leaf, textSize: 42)

                    Text(pair.activity.completionLine)
                        .font(Theme.body(24))
                        .foregroundColor(Theme.textDark)

                    HStack(spacing: 30) {
                        VStack(spacing: 8) {
                            StickerView(collectible: pair.activity.reward)
                                .frame(width: worldComplete ? 150 : 200,
                                       height: worldComplete ? 150 : 200)
                                .scaleEffect(revealed ? 1 : 0.1)
                                .opacity(revealed ? 1 : 0)
                            Text(pair.activity.reward.name)
                                .font(Theme.body(18))
                                .foregroundColor(Theme.textDark.opacity(0.72))
                        }

                        // Bonus character revealed on world completion.
                        if worldComplete, let bonus = world?.bonusReward {
                            VStack(spacing: 8) {
                                StickerView(collectible: bonus)
                                    .frame(width: 150, height: 150)
                                    .scaleEffect(bonusRevealed ? 1 : 0.1)
                                    .opacity(bonusRevealed ? 1 : 0)
                                Text(bonus.name)
                                    .font(Theme.body(18))
                                    .foregroundColor(Theme.textDark.opacity(0.72))
                            }
                        }
                    }

                    Text(worldComplete
                         ? "You finished \(world?.title ?? "the story")! You earned a new friend."
                         : "\(pair.activity.reward.name) joined your collection!")
                        .font(Theme.body(19))
                        .foregroundColor(Theme.textDark.opacity(0.72))
                        .multilineTextAlignment(.center)

                    HStack(spacing: 22) {
                        ChunkyButton(title: "More Games", icon: "arrow.backward", color: Theme.sunny, size: 22) {
                            router.go(.storyHub(worldID: worldID))
                        }
                        if worldComplete {
                            ChunkyButton(title: "My Collection", icon: "star.fill", color: Theme.berry, size: 22) {
                                router.go(.collection)
                            }
                        }
                        ChunkyButton(title: "Home", icon: "house.fill", color: Theme.sky, size: 22) {
                            router.go(.home)
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear(perform: reveal)
    }

    private func reveal() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.25)) {
            revealed = true
        }
        if worldComplete {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55).delay(0.9)) {
                bonusRevealed = true
            }
        }
        if let pair = ContentLibrary.lookup(worldID: worldID, activityID: activityID) {
            if worldComplete {
                audio.speak("You did it! You finished \(world?.title ?? "the story") and earned a new friend!")
            } else {
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
            ArtView(key: collectible.art).padding(30)
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
                    let x: CGFloat = Bool.random() ? .random(in: 0.04...0.20) : .random(in: 0.80...0.96)
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
