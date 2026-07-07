import SwiftUI

/// "My Collection" — organized world by world. Only earned stickers appear;
/// each world shows a progress bar and an "x of y" counter so the child (and
/// parent) can see how much is left to discover — without spoiling what.
struct CollectionView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var audio: AudioService

    var body: some View {
        ZStack {
            MeadowBackground()

            VStack(spacing: 16) {
                HStack {
                    RoundIconButton(systemName: "arrow.backward", color: Theme.sunny) {
                        router.go(.home)
                    }
                    Spacer()
                    BannerTitle(text: "My Collection", color: Theme.sunny)
                    Spacer()
                    Color.clear.frame(width: 64, height: 64)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(ContentLibrary.worlds) { world in
                            WorldCollectionSection(world: world)
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 28)
                }
            }
        }
        .onAppear {
            audio.speakOnce("Look at all your friends!", key: "collection")
        }
    }
}

struct WorldCollectionSection: View {
    let world: BibleWorld

    @EnvironmentObject private var progress: ProgressStore

    private var allCollectibles: [Collectible] {
        world.activities.map(\.reward) + (world.bonusReward.map { [$0] } ?? [])
    }

    private var earned: [Collectible] {
        allCollectibles.filter { progress.isUnlocked($0.id) }
    }

    private var percentage: Int {
        guard !allCollectibles.isEmpty else { return 0 }
        return Int((Double(earned.count) / Double(allCollectibles.count) * 100).rounded())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // World header: icon, title, counter.
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(world.accent.opacity(0.18))
                    ArtView(key: world.icon).padding(6)
                }
                .frame(width: 54, height: 54)

                Text(world.title)
                    .font(Theme.body(24))
                    .foregroundColor(Theme.textDark)

                Text("\(percentage)%")
                    .font(Theme.body(18))
                    .foregroundColor(world.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(world.accent.opacity(0.14)))

                Spacer()

                Text("\(earned.count) of \(allCollectibles.count)")
                    .font(Theme.body(18))
                    .foregroundColor(Theme.textDark.opacity(0.6))
            }

            // Progress bar.
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.creamDeep)
                    if !earned.isEmpty {
                        Capsule()
                            .fill(world.accent)
                            .frame(width: geo.size.width * CGFloat(earned.count) / CGFloat(max(allCollectibles.count, 1)))
                    }
                }
            }
            .frame(height: 14)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: earned.count)

            // Earned stickers only — the rest stay a surprise.
            if earned.isEmpty {
                Text("Play the games in \(world.title) to earn stickers!")
                    .font(Theme.body(16))
                    .foregroundColor(Theme.textDark.opacity(0.5))
                    .padding(.vertical, 4)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 6),
                          spacing: 14) {
                    ForEach(earned) { collectible in
                        VStack(spacing: 6) {
                            ZStack {
                                Circle().fill(Theme.cream)
                                ArtView(key: collectible.art).padding(10)
                            }
                            .frame(height: 84)
                            Text(collectible.name)
                                .font(Theme.body(14))
                                .foregroundColor(Theme.textDark)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 5)
        )
    }
}
